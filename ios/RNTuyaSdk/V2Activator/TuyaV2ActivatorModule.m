//
//  TuyaV2ActivatorModule.m
//  TuyaRnDemo
//
//  Created by 浩天 on 2019/2/28.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "TuyaV2ActivatorModule.h"
#import <React/RCTBridgeModule.h>
#import <ThingSmartActivatorKit/ThingSmartActivatorKit.h>
#import <ThingSmartBaseKit/ThingSmartBaseKit.h>
#import <ThingSmartDeviceKit/ThingSmartDeviceKit.h>
#import <ThingSmartBLEKit/ThingSmartBLEWifiActivator.h>
#import <ThingSmartBLEKit/ThingSmartBLEManager+Biz.h>
#import "TuyaRNUtils+Network.h"
#import "YYModel.h"

#define kTuyaRNActivatorModuleHomeId @"homeId"
#define kTuyaRNActivatorModuleDeviceId @"devId"
#define kTuyaRNActivatorModuleProductId @"productId"
#define kTuyaRNActivatorModuleSSID @"ssid"
#define kTuyaRNActivatorModulePassword @"password"
#define kTuyaRNActivatorModuleToken @"token"

@interface TuyaV2ActivatorModule()<ThingSmartBLEManagerDelegate>

@property(copy, nonatomic) RCTPromiseResolveBlock resolver;
@property(copy, nonatomic) RCTPromiseResolveBlock scanResolver;

// Scan result
@property(nonatomic, strong) ThingBLEAdvModel *scannedDeviceInfo;
@property(copy, nonatomic) NSString *activatorToken;

@end

@implementation TuyaV2ActivatorModule

RCT_EXPORT_MODULE(TuyaV2ActivatorModule)

RCT_EXPORT_METHOD(startBluetoothScan:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  NSLog(@"[TuyaV2ActivatorModule][ennukee][INFO] Starting Bluetooth scan");

  [ThingSmartBLEManager sharedInstance].delegate = self;
  self.scanResolver = resolver;
  [[ThingSmartBLEManager sharedInstance] startListening:YES];
}

- (void)didDiscoveryDeviceWithDeviceInfo:(ThingBLEAdvModel *)deviceInfo {
  NSLog(@"[TuyaV2ActivatorModule][ennukee][INFO] Discovered device: %@", deviceInfo);
  if (self.scanResolver) {
    self.scannedDeviceInfo = deviceInfo;
    [[ThingSmartBLEManager sharedInstance] stopListening:NO];
    self.scanResolver([deviceInfo yy_modelToJSONObject]);
    self.scanResolver = nil; // Clear the resolve block to prevent resolutions
    [[ThingSmartBLEManager sharedInstance] stopListening:YES];
  }
}

RCT_EXPORT_METHOD(stopBluetoothScan:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  NSLog(@"[TuyaV2ActivatorModule][ennukee][INFO] Stopping Bluetooth scan");
  [[ThingSmartBLEManager sharedInstance] stopListening:NO];
  resolver(@(YES));
}

RCT_EXPORT_METHOD(getActivatorToken:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  NSLog(@"[TuyaV2ActivatorModule][ennukee][INFO] Getting activator token with params: %@", params);
  NSNumber *homeId = params[kTuyaRNActivatorModuleHomeId];
  long long int homeIdValue = [homeId longLongValue];

  [[ThingSmartActivator sharedInstance] getTokenWithHomeId:homeId.longLongValue success:^(NSString *result) {
    NSLog(@"[TuyaV2ActivatorModule][ennukee][INFO] Retrieved activator token: %@", result);
    self.activatorToken = result;
    resolver(result);
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}

RCT_EXPORT_METHOD(offlinePairBLEDevice:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  NSLog(@"[TuyaV2ActivatorModule][ennukee][INFO] Starting offline pairing with params: %@", params);
  long long int homeIdValue = [params[kTuyaRNActivatorModuleHomeId] longLongValue];
  ThingBLEAdvModel *deviceInfo = self.scannedDeviceInfo;

  [[ThingSmartBLEManager sharedInstance] activatorDualDeviceWithBleChannel:deviceInfo homeId:homeIdValue token:self.activatorToken success:^(ThingSmartDeviceModel *deviceModel) {
    NSLog(@"[TuyaV2ActivatorModule][ennukee][INFO] Offline pairing success");
    resolver([deviceModel yy_modelToJSONObject]);
  } failure:^(NSError *error) {
    NSLog(@"[TuyaV2ActivatorModule][ennukee][ERROR] Offline pairing FAILED");
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}

RCT_EXPORT_METHOD(activateBLEWifiChannel:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  NSLog(@"[TuyaV2ActivatorModule][ennukee][INFO] Activating BLE WiFi channel with params: %@", params);
  NSString *deviceId = params[kTuyaRNActivatorModuleDeviceId];
  NSString *ssid = params[kTuyaRNActivatorModuleSSID];
  NSString *password = params[kTuyaRNActivatorModulePassword];

  [[ThingSmartBLEManager sharedInstance] activeDualDeviceWifiChannel:deviceId ssid:ssid password:password timeout:60 success:^(ThingSmartDeviceModel *deviceModel) {
    NSLog(@"[TuyaV2ActivatorModule][ennukee][INFO] BLE WiFi activation success for device ID: %@", deviceId);
    resolver([deviceModel yy_modelToJSONObject]);
  } failure:^(NSError *error) {
    NSLog(@"[TuyaV2ActivatorModule][ennukee][ERROR] BLE WiFi activation FAILED for device ID: %@", deviceId);
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}

@end
