//
//  TuyaBLERNScannerModule.m
//  TuyaRnDemo
//
//  Created by 浩天 on 2019/2/28.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "TuyaBLERNScannerModule.h"
#import <ThingSmartActivatorKit/ThingSmartActivatorKit.h>
#import <ThingSmartBaseKit/ThingSmartBaseKit.h>
#import <ThingSmartDeviceKit/ThingSmartDeviceKit.h>
#import <ThingSmartBLEKit/ThingSmartBLEManager+Biz.h>
#import "TuyaRNUtils+Network.h"
#import "YYModel.h"

// Bluetooth Pairing
static TuyaBLERNScannerModule * scannerInstance = nil;

@interface TuyaBLERNScannerModule()<ThingSmartBLEManagerDelegate>

@property(copy, nonatomic) RCTPromiseResolveBlock promiseResolveBlock;
@property(copy, nonatomic) RCTPromiseRejectBlock promiseRejectBlock;

@end

@implementation TuyaBLERNScannerModule

RCT_EXPORT_MODULE(TuyaBLEScannerModule)

RCT_EXPORT_METHOD(startBluetoothScan:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  if (scannerInstance == nil) {
    scannerInstance = [TuyaBLERNScannerModule new];
  }

  [ThingSmartBLEManager sharedInstance].delegate = scannerInstance;
  scannerInstance.promiseResolveBlock = resolver;
  scannerInstance.promiseRejectBlock = rejecter;

  [[ThingSmartBLEManager sharedInstance] startListening:YES];
}

RCT_EXPORT_METHOD(stopBluetoothScan:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  if (scannerInstance == nil) {
    scannerInstance = [TuyaBLERNScannerModule new];
  }

  [ThingSmartBLEManager sharedInstance].delegate = nil;
  scannerInstance.promiseResolveBlock = nil;
  scannerInstance.promiseRejectBlock = nil;

  [[ThingSmartBLEManager sharedInstance] stopListening:YES];

  resolver(@"success");
}

- (void)didDiscoveryDeviceWithDeviceInfo:(ThingBLEAdvModel *)deviceInfo {
  if (scannerInstance.promiseResolveBlock) {
    scannerInstance.promiseResolveBlock([deviceInfo yy_modelToJSONObject]);
  }
}

@end
