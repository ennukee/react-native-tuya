//
//  TuyaRNMessageModule.m
//  TuyaRnDemo
//
//  Created by 浩天 on 2019/2/28.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "TuyaRNMessageModule.h"
#import "TuyaRNUtils.h"
#import <YYModel.h>
#import <ThingSmartMessageKit/ThingSmartMessageKit.h>


@interface TuyaRNMessageModule()
@property (nonatomic, strong) ThingSmartMessage *smartMessage;
@end


@implementation TuyaRNMessageModule

RCT_EXPORT_MODULE(TuyaMessageModule)

RCT_EXPORT_METHOD(initWithOptions:(NSDictionary *)params) {
  
}

RCT_EXPORT_METHOD(onDestory:(NSDictionary *)params) {
  
}


// 获取消息列表：
RCT_EXPORT_METHOD(getMessageList:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartMessage *smartMessage = [[ThingSmartMessage alloc] init];
    self.smartMessage = smartMessage;
    [smartMessage getMessageList:^(NSArray<ThingSmartMessageListModel *> *list) {
        NSMutableArray *res = [NSMutableArray array];
        for (ThingSmartMessageListModel *item in list) {
          NSDictionary *dic = [item yy_modelToJSONObject];
          [res addObject:dic];
        }
        if (resolver) {
          resolver(res);
        }
    } failure:^(NSError *error) {
        [TuyaRNUtils rejecterV2WithError:error handler:resolver];
    }];
}


// 删除消息：
RCT_EXPORT_METHOD(deleteMessage:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  ThingSmartMessage *smartMessage = [[ThingSmartMessage alloc] init];
  self.smartMessage = smartMessage;
  [smartMessage deleteMessage:params[@"ids"] success:^{
    if (resolver) {
      resolver(@"seccess");
    }
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}

// 获取最新的时间戳：
RCT_EXPORT_METHOD(getMessageMaxTime:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  ThingSmartMessage *smartMessage = [[ThingSmartMessage alloc] init];
  self.smartMessage = smartMessage;
  [smartMessage getMessageMaxTime:^(int result) {
    if (resolver) {
      resolver(@(result));
    }
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}












@end
