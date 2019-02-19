//
//  FSBaiDuMapManager.h
//  FlashSend
//  百度地图管理类
//  Created by gaoyafeng on 2018/8/30.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

//定位
#import <BMKLocationkit/BMKLocationComponent.h>


#import "FSMapManager.h"//系统地图管理者

NS_ASSUME_NONNULL_BEGIN

@class LocaleInfoModel;


///回调block
typedef void(^BlockInfo)(LocaleInfoModel *localeModel,NSError *error);



@interface FSBaiDuMapManager : NSObject

///获取地图管理者
+(instancetype)shareInstance;

///开始连续定位
- (void)startUpdatingLocation;

///停止里连续定位
- (void)stopUpdatingLocation;


///获取一次地理位置
- (void)getGeographicInformationWithCallback:(BlockInfo)blockInfo;


///计算两点之间直线的距离
+ (double)calculateTheDistanceBetweenTwoPoints:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint;

///百度地图APP进行导航
+ (void)gotoBaiDuAPPNavigationWithLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName;

///获取GPS坐标 （从百度坐标转换）
+ (CLLocationCoordinate2D)getGaoDeMapLocationWithBaiDuLocation:(CLLocationCoordinate2D)locationBD;

///进行导航
+ (void)gotoNavigationWithLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName blockSResult:(APPBackBlock)blockResult;

@end


@interface LocaleInfoModel : NSObject

///纬度
@property (nonatomic,copy) NSString *latitude;

///经度
@property (nonatomic,copy) NSString *longitude;

///国家名字属性
@property(nonatomic, copy) NSString *country;

///国家编码属性
@property(nonatomic, copy) NSString *countryCode;

///省份名字属性
@property(nonatomic, copy) NSString *province;

///城市名字属性
@property(nonatomic, copy) NSString *city;

///区名字属性
@property(nonatomic, copy) NSString *district;

///街道名字属性
@property(nonatomic, copy) NSString *street;

///街道号码属性
@property(nonatomic, copy) NSString *streetNumber;

///城市编码属性
@property(nonatomic, copy) NSString *cityCode;

///行政区划编码属性
@property(nonatomic, copy) NSString *adCode;

///位置语义化结果的定位点在什么地方周围的描述信息
@property(nonatomic, copy) NSString *locationDescribe;



@end


NS_ASSUME_NONNULL_END






