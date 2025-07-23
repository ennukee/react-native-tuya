//
//  TuyaBLERNActivatorModule.m
//  TuyaRnDemo
//
//  Created by 浩天 on 2019/2/28.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "TuyaBLERNActivatorModule.h"
#import <React/RCTBridgeModule.h>
#import <ThingSmartActivatorKit/ThingSmartActivatorKit.h>
#import <ThingSmartBaseKit/ThingSmartBaseKit.h>
#import <ThingSmartDeviceKit/ThingSmartDeviceKit.h>
#import <ThingSmartBLEKit/ThingSmartBLEWifiActivator.h>
#import "TuyaRNUtils+Network.h"
#import "YYModel.h"

#define kTuyaRNActivatorModuleHomeId @"homeId"
#define kTuyaRNActivatorModuleDeviceId @"deviceId"
#define kTuyaRNActivatorModuleProductId @"productId"
#define kTuyaRNActivatorModuleSSID @"ssid"
#define kTuyaRNActivatorModulePassword @"password"

// Bluetooth Pairing
static TuyaBLERNActivatorModule * activatorInstance = nil;

@interface TuyaBLERNActivatorModule()<ThingSmartBLEWifiActivatorDelegate>

@property(copy, nonatomic) RCTPromiseResolveBlock promiseResolveBlock;
@property(copy, nonatomic) RCTPromiseRejectBlock promiseRejectBlock;

@end

@implementation TuyaBLERNActivatorModule

RCT_EXPORT_MODULE(TuyaBLEActivatorModule)

RCT_EXPORT_METHOD(initActivator:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  if (activatorInstance == nil) {
    activatorInstance = [TuyaBLERNActivatorModule new];
  }

  [ThingSmartBLEWifiActivator sharedInstance].bleWifiDelegate = activatorInstance;
  activatorInstance.promiseResolveBlock = resolver;
  activatorInstance.promiseRejectBlock = rejecter;

  NSNumber *homeId = params[kTuyaRNActivatorModuleHomeId];
  NSString *deviceId = params[kTuyaRNActivatorModuleDeviceId];
  NSString *productId = params[kTuyaRNActivatorModuleProductId];
  NSString *ssid = params[kTuyaRNActivatorModuleSSID];
  NSString *password = params[kTuyaRNActivatorModulePassword];
  long long int homeIdValue = [homeId longLongValue];

  [[ThingSmartBLEWifiActivator sharedInstance] startConfigBLEWifiDeviceWithUUID:deviceId homeId:homeIdValue productId:productId ssid:ssid password:password  timeout:60 success:^{
      NSLog(@"[TuyaBLERNActivatorModule][ennukee][INFO] Activation started for device ID: %@", deviceId);
    } failure:^ {
      if (activatorInstance.promiseRejectBlock) {
        NSDictionary *errorDict = @{
          @"code": @"UNKNOWN_CONNECT_ERROR",
          @"msg": [NSString stringWithFormat:@"Error activating device with ID: %@", deviceId],
          @"error": @YES
        };
        resolver(errorDict);
      }
      return;
    }];
}

- (void)bleWifiActivator:(ThingSmartBLEWifiActivator *)activator didReceiveBLEWifiConfigDevice:(ThingSmartDeviceModel *)deviceModel error:(NSError *)error {
  if (!activatorInstance.promiseResolveBlock) {
    NSLog(@"[TuyaBLERNActivatorModule][ennukee][ERROR] No promise resolve or reject block set for activation result.");
    return;
  }
  
  if (!error && deviceModel) {
    [TuyaRNUtils resolverWithHandlerandData:activatorInstance.promiseResolveBlock data:[deviceModel yy_modelToJSONObject]];
  } else if (error) {
    [TuyaRNUtils rejecterV2WithError:error handler:activatorInstance.promiseResolveBlock];
  } else {
    NSDictionary *errorDict = @{
      @"code": @"UNKNOWN_ACTIVATION_ERROR",
      @"msg": [NSString stringWithFormat:@"Error activating device with ID: %@", deviceModel.deviceId],
      @"error": @YES
    };
    [TuyaRNUtils resolverWithHandlerandData:activatorInstance.promiseResolveBlock data:errorDict];
  }
  activatorInstance.promiseResolveBlock = nil;
}

@end
