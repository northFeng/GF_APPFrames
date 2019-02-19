//
//  FSMapManager.h
//  FlashSend
//  iOS原生地图管理类（获取定位信息）
//  Created by gaoyafeng on 2018/8/25.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BlockLocalInfo)(NSString *codeStr,NSString *addressStr);

@interface FSMapManager : NSObject


///获取地图管理者
+(instancetype)shareInstance;


///获取地理位置名字
- (void)getGeographicInformationWithCallback:(BlockLocalInfo)BlockLocalInfo;

///获取地理编码
- (void)getGeographicCodeStrWithAddressStr:(NSString *)addressName callBlock:(BlockLocalInfo)BlockLocalInfo;


///计算两点之间的距离
- (double)distanceByLongitude:(double)longitude1 latitude:(double)latitude1 longitude:(double)longitude2 latitude:(double)latitude2;

///跳到系统地图
+ (void)gotoSystemMapNavigationWithLocation:(CLLocationCoordinate2D)location;

@end

NS_ASSUME_NONNULL_END
