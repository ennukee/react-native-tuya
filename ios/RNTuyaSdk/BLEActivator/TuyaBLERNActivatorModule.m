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
  NSLog(@"[TuyaBLERNActivatorModule][ennukee][INFO] Initializing BLE activator with params: %@", params);
  activatorInstance = nil;
  NSLog(@"[TuyaBLERNActivatorModule][ennukee][INFO] Reset activator instance");
  if (activatorInstance == nil) {
    NSLog(@"[TuyaBLERNActivatorModule][ennukee][INFO] Creating new activator instance");
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

  NSLog(@"[TuyaBLERNActivatorModule][ennukee][INFO] Attempting to connect with device... (device ID: %@)", deviceId);
  [[ThingSmartBLEWifiActivator sharedInstance] startConfigBLEWifiDeviceWithUUID:deviceId homeId:homeIdValue productId:productId ssid:ssid password:password timeout:60 success:^{
      NSLog(@"[TuyaBLERNActivatorModule][ennukee][INFO] Activation started for device ID: %@", deviceId);
    } failure:^ {
      NSLog(@"[TuyaBLERNActivatorModule][ennukee][ERROR] Activation FAILED for device ID: %@", deviceId);
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
  NSLog(@"[TuyaBLERNActivatorModule][ennukee][INFO] Activation result received");
  if (!activatorInstance.promiseResolveBlock) {
    NSLog(@"[TuyaBLERNActivatorModule][ennukee][ERROR] No promise resolve or reject block set for activation result.");
    [[ThingSmartBLEWifiActivator sharedInstance] stopDiscover];
    return;
  }
  if (error) {
    NSLog(@"[TuyaBLERNActivatorModule][ennukee][ERROR] Activation FAILED");
    [TuyaRNUtils rejecterV2WithError:error handler:activatorInstance.promiseResolveBlock];
    [[ThingSmartBLEWifiActivator sharedInstance] stopDiscover];
    activatorInstance.promiseResolveBlock = nil;
    return;
  }
  
  if (deviceModel) {
    NSLog(@"[TuyaBLERNActivatorModule][ennukee][INFO] Activation completed for device ID: %@", deviceModel.devId);
    [TuyaRNUtils resolverWithHandlerandData:activatorInstance.promiseResolveBlock data:[deviceModel yy_modelToJSONObject]];
  } else {
    NSLog(@"[TuyaBLERNActivatorModule][ennukee][ERROR] Activation completed but device model is nil");
    NSDictionary *errorDict = @{
      @"code": @"UNKNOWN_ACTIVATION_ERROR",
      @"msg": [NSString stringWithFormat:@"Error activating device with ID: %@", deviceModel.devId ?: @"Unknown"],
      @"error": @YES
    };
    [TuyaRNUtils resolverWithHandlerandData:activatorInstance.promiseResolveBlock data:errorDict];
  }
  [[ThingSmartBLEWifiActivator sharedInstance] stopDiscover];
  activatorInstance.promiseResolveBlock = nil;
}

RCT_EXPORT_METHOD(stopLePairing) {
  [[ThingSmartBLEWifiActivator sharedInstance] stopDiscover];
}

@end
