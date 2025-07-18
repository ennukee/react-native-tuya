//
//  TuyaRNHomeModule.m
//  TuyaRnDemo
//
//  Created by 浩天 on 2019/3/1.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "TuyaRNHomeModule.h"
#import "YYModel.h"
#import "TuyaRNUtils.h"
#import <ThingSmartDeviceKit/ThingSmartHome.h>
#import <ThingSmartDeviceKit/ThingSmartHomeModel.h>
#import <ThingSmartDeviceKit/ThingSmartShareDeviceModel.h>
#import <ThingSmartDeviceKit/ThingSmartGroup+DpCode.h>
#import <ThingSmartBaseKit/ThingSmartRequest.h>
#import <ThingSmartDeviceKit/ThingSmartRoomModel.h>
#import "TuyaRNUtils+Cache.h"
#import "TuyaRNUtils+DeviceParser.h"
#import "TuyaRNHomeListener.h"

#define kTuyaRNHomeModuleHomeId @"homeId"
#define kTuyaRNHomeModuleName @"name"
#define kTuyaRNHomeModuleLon @"lon"
#define kTuyaRNHomeModuleLat @"lat"
#define kTuyaRNHomeModuleGeoName @"geoName"
#define kTuyaRNHomeModuleRoomId @"roomId"

@interface TuyaRNHomeModule()<ThingSmartHomeDelegate>

@property (nonatomic, strong) ThingSmartHome *currentHome;

@end

@implementation TuyaRNHomeModule

RCT_EXPORT_MODULE(TuyaHomeModule)

RCT_EXPORT_METHOD(getHomeDetail:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  self.currentHome = [self smartHomeWithParams:params];

  [self.currentHome getHomeDataWithSuccess:^(ThingSmartHomeModel *homeModel) {
    ThingSmartHome *newHome = [ThingSmartHome homeWithHomeId:homeModel.homeId];

    NSMutableDictionary *homeDic = [[NSMutableDictionary alloc] init];
    [homeDic setObject:getValidDataForDeviceModel(newHome.deviceList) forKey:@"deviceList"];
    [homeDic setObject:getValidDataForGroupModel(newHome.groupList) forKey:@"groupList"];
    [homeDic setObject:getValidDataForDeviceModel(newHome.sharedDeviceList) forKey:@"sharedDeviceList"];
    [homeDic setObject:getValidDataForGroupModel(newHome.sharedGroupList) forKey:@"sharedGroupList"];

    if(resolver) {
      resolver(homeDic);
    }

  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}


RCT_EXPORT_METHOD(getHomeLocalCache:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  self.currentHome = [self smartHomeWithParams:params];
  if(resolver) {
    resolver([self.currentHome yy_modelToJSONObject]);
  }
}

/**
 * 更新家庭信息
 *
 * @param name     家庭名称
 * @param lon      当前家庭的经度
 * @param lat      当前家庭的纬度
 * @param geoName  地理位置的地址
 * @param callback
 */
RCT_EXPORT_METHOD(updateHome:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  NSString *name = params[kTuyaRNHomeModuleName];
  NSNumber *lon = params[kTuyaRNHomeModuleLon];
  NSNumber *lat = params[kTuyaRNHomeModuleLat];
  NSString *geoName = params[kTuyaRNHomeModuleGeoName];

  self.currentHome = [self smartHomeWithParams:params];
  [self.currentHome updateHomeInfoWithName:name
                       geoName:geoName
                      latitude:lat.doubleValue
                     longitude:lon.doubleValue
                       success:^{
                         [TuyaRNUtils resolverWithHandler:resolver];
                       } failure:^(NSError *error) {
                         [TuyaRNUtils rejecterV2WithError:error handler:resolver];
                       }];
}


/**
 * 解散家庭
 *
 * @param callback
 */
RCT_EXPORT_METHOD(dismissHome:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  self.currentHome = [self smartHomeWithParams:params];
  [self.currentHome dismissHomeWithSuccess:^{
    [TuyaRNUtils resolverWithHandler:resolver];
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}

/**
 * 添加房间
 *
 * @param name
 * @param callback
 */
RCT_EXPORT_METHOD(addRoom:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  self.currentHome = [self smartHomeWithParams:params];
  NSString *name = params[kTuyaRNHomeModuleName];
  [self.currentHome addHomeRoomWithName:name success:^{
    [TuyaRNUtils resolverWithHandler:resolver];
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}

/**
 * 移除房间
 *
 * @param roomId
 * @param callback
 */
RCT_EXPORT_METHOD(removeRoom:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  self.currentHome = [self smartHomeWithParams:params];
  NSNumber *roomId = params[kTuyaRNHomeModuleRoomId];

  [self.currentHome removeHomeRoomWithRoomId:roomId.longLongValue success:^{
    [TuyaRNUtils resolverWithHandler:resolver];
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];

}

/**
 房屋排序
 */
RCT_EXPORT_METHOD(sortRoom:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  self.currentHome = [self smartHomeWithParams:params];

  NSMutableArray<ThingSmartRoomModel *> * list = [NSMutableArray array];
  for(NSNumber * homeId in params[@"idList"] ) {
    ThingSmartRoomModel *room = [[ThingSmartRoomModel alloc] init];
    room.roomId = [homeId longLongValue];
    [list addObject:room];
  }

  [self.currentHome sortRoomList:list success:^{
    [TuyaRNUtils resolverWithHandler:resolver];
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}

/**
 查询房屋的列表
 */
RCT_EXPORT_METHOD(queryRoomList:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  self.currentHome = [self smartHomeWithParams:params];

  //获取详情获取：
  [self.currentHome getHomeDataWithSuccess:^(ThingSmartHomeModel *homeModel) {
    if (self.currentHome.roomList.count == 0) {
      if (resolver) {
        resolver(@[]);
      }
      return;
    }

    NSMutableArray *list = [NSMutableArray array];
    for (ThingSmartRoomModel *roomModel in self.currentHome.roomList) {
      NSDictionary *dic = [roomModel yy_modelToJSONObject];
      //检查相关字段是否一致
      NSMutableDictionary *roomDic = [NSMutableDictionary dictionaryWithDictionary:dic];
      [roomDic setObject:[NSNumber numberWithLongLong:roomModel.roomId] forKey:@"roomId"];
      [list addObject:roomDic];
    }
    if (resolver) {
      resolver(list);
    }
  } failure:^(NSError *error) {
    [TuyaRNUtils rejecterV2WithError:error handler:resolver];
  }];
}

/**
 注册 Home信息监听

 */
RCT_EXPORT_METHOD(registerHomeStatusListener:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  NSNumber *homeIdNum = params[kTuyaRNHomeModuleHomeId];
  if (!homeIdNum || homeIdNum.longLongValue <= 0) {
    return;
  }
  [[TuyaRNHomeListener shareInstance] registerHomeStatusWithSmartHome:[ThingSmartHome homeWithHomeId:homeIdNum.longLongValue]];
}

/**
 取消Home注册监听

 */
RCT_EXPORT_METHOD(unRegisterHomeStatusListener:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  [[TuyaRNHomeListener shareInstance] removeHomeStatusSmartHome];
}


//
RCT_EXPORT_METHOD(queryDeviceListToAddGroup:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {


}

RCT_EXPORT_METHOD(onDestroy:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

}

#pragma mark -
- (ThingSmartHome *)smartHomeWithParams:(NSDictionary *)params {
  long long homeId = ((NSNumber *)params[kTuyaRNHomeModuleHomeId]).longLongValue;
  if (homeId > 0) {
    [TuyaRNUtils setCurrentHomeId:[NSNumber numberWithLongLong:homeId]];
  }
  self.currentHome = [ThingSmartHome homeWithHomeId:homeId];
  return self.currentHome;
}

@end
