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
  NSLog(@"[TuyaBLERNScannerModule][ennukee][INFO] Starting Bluetooth scan");
  scannerInstance = nil;
  NSLog(@"[TuyaBLERNScannerModule][ennukee][INFO] Reset scanner instance");
  if (scannerInstance == nil) {
    NSLog(@"[TuyaBLERNScannerModule][ennukee][INFO] Creating new scanner instance");
    scannerInstance = [TuyaBLERNScannerModule new];
  }

  [ThingSmartBLEManager sharedInstance].delegate = scannerInstance;
  scannerInstance.promiseResolveBlock = resolver;
  scannerInstance.promiseRejectBlock = rejecter;

  NSLog(@"[TuyaBLERNScannerModule][ennukee][INFO] BLE Scanner activating listening");
  [[ThingSmartBLEManager sharedInstance] startListening:YES];
}

- (void)didDiscoveryDeviceWithDeviceInfo:(ThingBLEAdvModel *)deviceInfo {
  NSLog(@"[TuyaBLERNScannerModule][ennukee][INFO] Discovered device: %@", deviceInfo);
  if (scannerInstance.promiseResolveBlock) {
    [[ThingSmartBLEManager sharedInstance] stopListening:NO];
    self.promiseResolveBlock([deviceInfo yy_modelToJSONObject]);
    self.promiseResolveBlock = nil; // Clear the resolve block to prevent resolutions
  }
}

@end
