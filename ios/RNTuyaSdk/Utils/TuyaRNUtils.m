//
//  TuyaRNUtils.m
//  TuyaRnDemo
//
//  Created by 浩天 on 2019/2/28.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "TuyaRNUtils.h"


@implementation TuyaRNUtils

+ (void)rejecterWithError:(NSError *)error
                  handler:(RCTPromiseRejectBlock)rejecter {
  if (rejecter) {
    rejecter([NSString stringWithFormat:@"%ld", error.code], error.userInfo[NSLocalizedDescriptionKey], error);
  }
}

+ (void)rejecterV2WithError:(NSError *)error
                  handler:(RCTPromiseResolveBlock)resolver {
  if (resolver) {
    NSDictionary *errorDict = @{
      @"code": [NSString stringWithFormat:@"%ld", error.code],
      @"msg": error.userInfo[NSLocalizedDescriptionKey] ?: @"",
      @"error": @YES
    };
    resolver(errorDict);
  }
}

+ (void)resolverWithHandler:(RCTPromiseResolveBlock)resolver {
  if (resolver) {
    resolver(@"success");
  }
}

@end
