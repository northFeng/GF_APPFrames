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


#import "FSMapManager.h"


/**
 *  地图导航类型
 */
typedef NS_ENUM(NSInteger,APPEnumMapNavigationType) {
    /**
     *  百度地图
     */
    APPEnumMapNavigationType_baiduMap = 0,
    /**
     *  高德地图
     */
    APPEnumMapNavigationType_gaodeMap = 1,
    /**
     *  系统地图
     */
    APPEnumMapNavigationType_iosMap = 2,
};



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


#pragma mark - 百度地图 检索 (百度地图iosSDK没有附近 推荐位置，web服务端有响应的接口)

///城市内检索
- (void)bmkSearchInCity:(NSString *)cityName keyWord:(NSString *)searchKey blockResult:(APPBackBlock)blockResult;

///附近（周边）检索(POI圆形区域检索)
- (void)bmkSearchNearInCity:(NSString *)cityName locationCoord:(CLLocationCoordinate2D)localInfo keyWord:(NSString *)searchKey nearRadius:(int)radius blockResult:(APPBackBlock)blockResult;

///城市关键词匹配检索
- (void)bmkSearchSuggestioInCity:(NSString *)cityName keyWord:(NSString *)searchKey blockResult:(APPBackBlock)blockResult;

///附近（周边）云检索(有问题不能用)
- (void)bmkCloudNearSearchInCity:(NSString *)cityName locationCoord:(NSString *)localInfo nearRadius:(int)radius blockResult:(APPBackBlock)blockResult;


///计算两点之间直线的距离
+ (double)calculateTheDistanceBetweenTwoPoints:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint;

///百度地图APP进行导航
+ (void)gotoBaiDuAPPNavigationWithLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName;


///获取GPS坐标 （从百度坐标转换）
+ (CLLocationCoordinate2D)getGaoDeMapLocationWithBaiDuLocation:(CLLocationCoordinate2D)locationBD;

///进行导航
+ (void)gotoNavigationWithLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName naviType:(APPEnumMapNavigationType)naviType blockSResult:(APPBackBlock)blockResult;

///计算两点之间的角度
+ (CGFloat)computingAngleWithStart:(CLLocationCoordinate2D)pointStart end:(CLLocationCoordinate2D)pointEnd;


@end

#pragma mark - *************************** 离线地图 ***************************

/**
 下载离线地图通知(通知里返回的是离线地图下载的信息)
 NSString* _cityName;
 int          _cityID;
 int64_t          _size;
 int64_t          _serversize;
 BOOL      _update;
 int          _ratio;
 int          _status;
 CLLocationCoordinate2D _pt;
 */
extern NSString *const kBMKOfflineDownloadNotification;

static const NSInteger kilobyte = 1024;
static const NSInteger megabyte = 1048576;
static const NSInteger gigabyte = 1073741824;

/**
 *  离线地图操作类型
 */
typedef NS_ENUM(NSInteger,MapOfflineType) {
    /**
     *  下载
     */
    MapOfflineType_startDownload = 0,
    /**
     *  暂停
     */
    MapOfflineType_pauseDownload = 1,
    /**
     *  更新下载
     */
    MapOfflineType_updateDownload = 2,
    /**
     *  删除
     */
    MapOfflineType_remove = 3,
};

@interface FSBaiDuMapManager (DownloadOffline) <BMKOfflineMapDelegate>

///获取热门城市
- (NSArray *)getHotOfflineCityList;

///获取
- (NSArray *)getAllOfflineCityList;

///获取某个城市离线地图信息
- (BMKOLUpdateElement *)getOffLineMapInfoWithCityId:(int)cityId;

///根据城市名获取该城市的离线地图信息
- (NSArray *)getOfflineMapInfoWithCityName:(NSString *)cityName;

///下载 && 暂停 && 删除 && 更新
- (void)offlineMapHandleWithType:(MapOfflineType)handleType bmkCityId:(int)cityId;

/**
 离线地图数据包大小单位转换
 
 @param packetSize 离线地图数据包总大小，单位是bytes
 @return 转换单位后的离线地图数据包大小
 */
- (NSString *)getDataSizeString:(NSInteger)packetSize;


@end


#pragma mark - *************************** 定位信息model ***************************

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







