//
//  TuyaRNShareModule.m
//  TuyaRnDemo
//
//  Created by 浩天 on 2019/2/28.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "TuyaRNShareModule.h"
#import <ThingSmartDeviceKit/ThingSmartDeviceKit.h>
#import "TuyaRNUtils.h"
#import "YYModel.h"


@interface TuyaRNShareModule()
@property (nonatomic, strong) ThingSmartHomeDeviceShare *deviceShare;
@end

@implementation TuyaRNShareModule

RCT_EXPORT_MODULE(TuyaShareModule)

RCT_EXPORT_METHOD(initWithOptions:(NSDictionary *)params) {
  
}

RCT_EXPORT_METHOD(onDestory:(NSDictionary *)params) {
  
}

#pragma mark 添加共享
// 添加多个设备共享（覆盖）：
RCT_EXPORT_METHOD(addShareWithHomeId:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  
      ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
      self.deviceShare = deviceShare;
      [deviceShare addShareWithHomeId:[params[@"homeId"] longLongValue] countryCode:params[@"countryCode"] userAccount:params[@"userAccount"] devIds:params[@"devIds"] success:^(ThingSmartShareMemberModel *model) {
          if (resolver) {
            resolver([model yy_modelToJSONObject]);
          }
      } failure:^(NSError *error) {
          [TuyaRNUtils rejecterV2WithError:error handler:resolver];
      }];
}

// 添加多个设备共享（追加
RCT_EXPORT_METHOD(addShareWithMemberId:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  
    ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
    self.deviceShare = deviceShare;
    [deviceShare addShareWithMemberId:[params[@"memberId"] integerValue] devIds:params[@"devIds"] success:^{
        if (resolver) {
          resolver(@"success");
        }
    } failure:^(NSError *error) {
      [TuyaRNUtils rejecterV2WithError:error handler:resolver];
    }];
}

//// 单个设备取消共享：
//RCT_EXPORT_METHOD(disableDevShare:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
//
//    TuyaSmartHomeDeviceShare *deviceShare  = [[TuyaSmartHomeDeviceShare alloc] init];
//    [deviceShare removeShareMemberWithMemberId:[params[@"memberId"] integerValue] success:^{
//        if (resolver) {
//          resolver(@"removeShareMember success");
//        }
//    } failure:^(NSError *error) {
//        [TuyaRNUtils rejecterV2WithError:error handler:resolver];
//    }];
//}

// 查询分享:
// 查询主动分享的关系列表:
RCT_EXPORT_METHOD(queryUserShareList:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  
    ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
    self.deviceShare = deviceShare;
    [deviceShare getShareMemberListWithHomeId:[params[@"homeId"] integerValue] success:^(NSArray<ThingSmartShareMemberModel *> *list) {
      
    NSMutableArray *res = [NSMutableArray array];
        for (ThingSmartShareMemberModel *item in list) {
          NSMutableDictionary *dic = [item yy_modelToJSONObject];
          dic[@"homeId"] = params[@"homeId"];
          [res addObject:[self shareMemberDicAdapter:dic]];
        }
        if (resolver) {
          resolver(res);
        }
     } failure:^(NSError *error) {
        [TuyaRNUtils rejecterV2WithError:error handler:resolver];
     }];
}

// 查询收到分享关系列表
RCT_EXPORT_METHOD(queryShareReceivedUserList:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
  self.deviceShare = deviceShare;
  [deviceShare getReceiveMemberListWithSuccess:^(NSArray<ThingSmartShareMemberModel *> *list) {
      NSMutableArray *res = [NSMutableArray array];
      for (ThingSmartShareMemberModel *item in list) {
        NSMutableDictionary *dic = [item yy_modelToJSONObject];
        [res addObject:[self shareMemberDicAdapter:dic]];
      }
      if (resolver) {
        resolver(res);
      }
  } failure:^(NSError *error) {
      [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];

}

// 查询指定设备的分享用户列表
RCT_EXPORT_METHOD(queryDevShareUserList:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
  self.deviceShare = deviceShare;
  [deviceShare getDeviceShareMemberListWithDevId:params[@"devId"] success:^(NSArray<ThingSmartShareMemberModel *> *list) {
    NSMutableArray *res = [NSMutableArray array];
    for (ThingSmartShareMemberModel *item in list) {
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

// 查询指定设备是谁共享的:
RCT_EXPORT_METHOD(queryShareDevFromInfo:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  
  ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
  self.deviceShare = deviceShare;
  [deviceShare getShareInfoWithDevId:params[@"devId"] success:^(ThingSmartReceivedShareUserModel *model) {
      if (resolver) {
        resolver([model yy_modelToJSONObject]);
      }
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}


// 查询分享到指定用户的共享关系:
RCT_EXPORT_METHOD(getUserShareInfo:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  
    ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
    self.deviceShare = deviceShare;
    [deviceShare getShareMemberDetailWithMemberId:[params[@"memberId"] integerValue] success:^(ThingSmartShareMemberDetailModel *model) {
      
      NSMutableArray *res = [NSMutableArray array];
      for (ThingSmartShareDeviceModel *item in model.devices) {
        NSMutableDictionary *dic = [item yy_modelToJSONObject];
        dic[@"deviceName"] = dic[@"name"];
        [res addObject:dic];
      }
      
      NSMutableDictionary *dic = [model yy_modelToJSONObject];
      dic[@"devices"] = res;
      
      if (resolver) {
        resolver(dic);
      }
    } failure:^(NSError *error) {
      [TuyaRNUtils rejecterV2WithError:error handler:resolver];
    }];
}

// 查询收到指定用户共享的信息:
RCT_EXPORT_METHOD(getReceivedShareInfo:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  
  ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
  self.deviceShare = deviceShare;
  [deviceShare getReceiveMemberDetailWithMemberId:[params[@"memberId"] integerValue] success:^(ThingSmartReceiveMemberDetailModel *model) {
      if (resolver) {
        resolver([model yy_modelToJSONObject]);
      }
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}

#pragma mark 移除分享
// 删除共享关系:
RCT_EXPORT_METHOD(removeUserShare:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  
    ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
    self.deviceShare = deviceShare;
    [deviceShare removeShareMemberWithMemberId:[params[@"memberId"] integerValue] success:^{
        if (resolver) {
          resolver(@"success");
        }
    } failure:^(NSError *error) {
        [TuyaRNUtils rejecterV2WithError:error handler:resolver];
    }];

}



// 删除收到的共享关系:
RCT_EXPORT_METHOD(removeReceivedUserShare:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  
    ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
  self.deviceShare = deviceShare;
  [deviceShare removeReceiveShareMemberWithMemberId:[params[@"memberId"] integerValue] success:^{
      if (resolver) {
        resolver(@"success");
      }
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}


 // 删除某个设备共享:
RCT_EXPORT_METHOD(disableDevShare:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  
    ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
  self.deviceShare = deviceShare;
  [deviceShare removeDeviceShareWithMemberId:[params[@"memberId"] integerValue] devId:params[@"devId"] success:^{
      if (resolver) {
        resolver(@"success");
      }
  } failure:^(NSError *error) {
      [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
  
}


// 移除收到的分享设备:
RCT_EXPORT_METHOD(removeReceivedDevShare:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
    self.deviceShare = deviceShare;
    [deviceShare removeReceiveDeviceShareWithDevId:params[@"devId"] success:^{
        if (resolver) {
          resolver(@"success");
        }
    } failure:^(NSError *error) {
        [TuyaRNUtils rejecterV2WithError:error handler:resolver];
    }];
}

#pragma mark 修改备注名

// 修改发出的分享人的备注名:
RCT_EXPORT_METHOD(renameShareNickname:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
    self.deviceShare = deviceShare;
    [deviceShare renameShareMemberNameWithMemberId:[params[@"memberId"] integerValue] name:params[@"name"] success:^{
        if (resolver) {
          resolver(@"success");
        }
    } failure:^(NSError *error) {
        [TuyaRNUtils rejecterV2WithError:error handler:resolver];
    }];
}

// 修改接收到的分享人的备注名:
RCT_EXPORT_METHOD(renameReceivedShareNickname:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  
    ThingSmartHomeDeviceShare *deviceShare  = [[ThingSmartHomeDeviceShare alloc] init];
    self.deviceShare = deviceShare;
    [deviceShare renameReceiveShareMemberNameWithMemberId:[params[@"memberId"] integerValue] name:params[@"name"] success:^{
        if (resolver) {
          resolver(@"success");
        }
    } failure:^(NSError *error) {
        [TuyaRNUtils rejecterV2WithError:error handler:resolver];
    }];

}

- (NSDictionary *)shareMemberDicAdapter:(NSMutableDictionary *)origin {
  NSMutableDictionary *res = [NSMutableDictionary dictionary];
      res[@"homeId"] = origin[@"homeId"];
      res[@"iconUrl"] = origin[@"headPic"];
      res[@"memeberId"] = origin[@"memberId"];
      res[@"mobile"] = origin[@"userName"];
      res[@"remarkName"] = origin[@"nickName"];
      res[@"userName"] = origin[@"userName"];
  return res;
}


@end
