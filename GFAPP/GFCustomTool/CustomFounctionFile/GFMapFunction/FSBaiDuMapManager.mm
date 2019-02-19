//
//  FSBaiDuMapManager.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/8/30.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSBaiDuMapManager.h"


@interface FSBaiDuMapManager () <BMKGeneralDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate>//遵守百度定位代理

///百度地图管理者
@property (nonatomic,strong) BMKMapManager *mapManager;

///定位管理者
@property (nonatomic,strong) BMKLocationManager *locationManager;

///block
@property (nonatomic,copy) BlockInfo blockinfo;

///位置字符串
@property (nonatomic,copy) NSString *localCodeString;

///位置地名
@property (nonatomic,copy) NSString *localNameString;

///定位信息
@property (nonatomic,strong,nullable) BMKLocation *locationInfo;

@end

@implementation FSBaiDuMapManager


///获取地图管理者
+(instancetype)shareInstance
{
    static FSBaiDuMapManager *mapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapManager = [[self alloc] init];
    });
    return mapManager;
}

- (instancetype)init{
    
    if ([super init]) {
        
        [self configurationInformation];
    }
    return self;
}


///配置地图信息
- (void)configurationInformation{
    
    //地图管理
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:[APPKeyInfo getBaiDuAK]  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //定位管理
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:[APPKeyInfo getBaiDuAK] authDelegate:self];
    

    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    
}

///开始连续定位
- (void)startUpdatingLocation{
    
    [_locationManager startUpdatingLocation];
    
}

///停止里连续定位
- (void)stopUpdatingLocation{
    [_locationManager stopUpdatingLocation];
}


#pragma mark - ********************* 百度地图管理者 BMKGeneralDelegate *********************
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


#pragma mark - ********************* 百度授权验证代理BMKLocationAuthDelegate *********************
/**
 *@brief 返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKLocationAuthErrorCode
 */
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{

}


#pragma mark - ********************* 百度定位代理 BMKLocationManagerDelegate *********************
/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error{
    NSLog(@"定位发生错误");
    NSString *errorStr;
    NSString *titleStr;
    switch (error.code) {
        case 2:
            //未授权
            //[weakSelf showMessage:@"获取定位失败,请到设置中开启定位服务"];
            //定位没有授权
            errorStr = @"接单等功能需要持续访问您的位置信息!为了不影响您的使用体验\n请到->设置->隐私->定位服务->闪送骑手端中开启定位服务";
            titleStr = @"定位服务已关闭";
            break;
        case 5:
            //无网络
            errorStr = @"获取定位失败,请检查网络";
            titleStr = @"警告";
            break;
        default:
            errorStr = @"获取地理位置失败";
            break;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:errorStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancleAction];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


/**
 *  @brief 连续定位回调函数。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param location 定位结果，参考BMKLocation。
 *  @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    NSLog(@"连续定位回调函数");
    if (location) {
        //获取地理位置成功

        [APPManager sharedInstance].localLatitude = [NSString stringWithFormat:@"%.8f",location.location.coordinate.latitude];
        [APPManager sharedInstance].localLongitude = [NSString stringWithFormat:@"%.8f",location.location.coordinate.longitude];
        [APPManager sharedInstance].localCityName = location.rgcData.city;
        
        _locationInfo = location;
    }
}

/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 BMKLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"定位权限状态改变");

}


/**
 * @brief 该方法为BMKLocationManager提示需要设备校正回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例。
 */
- (BOOL)BMKLocationManagerShouldDisplayHeadingCalibration:(BMKLocationManager * _Nonnull)manager{


    return YES;
}

/**
 * @brief 该方法为BMKLocationManager提供设备朝向的回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 * @param heading 设备的朝向结果
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
          didUpdateHeading:(CLHeading * _Nullable)heading{


}

/**
 * @brief 该方法为BMKLocationManager所在App系统网络状态改变的回调事件。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 * @param state 当前网络状态
 * @param error 错误信息
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
     didUpdateNetworkState:(BMKLocationNetworkState)state orError:(NSError * _Nullable)error{


}


#pragma mark - 自定义接口
///获取一次地理位置
- (void)getGeographicInformationWithCallback:(BlockInfo)blockInfo{
    
    /**
    [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        
        LocaleInfoModel *model;
        if (location) {
            //获取地理位置成功
            model = [[LocaleInfoModel alloc] init];

            model.latitude = [NSString stringWithFormat:@"%.8f",location.location.coordinate.latitude];
            model.longitude = [NSString stringWithFormat:@"%.8f",location.location.coordinate.longitude];
            
            
            model.country = location.rgcData.country;
            model.countryCode = location.rgcData.countryCode;
            model.province = location.rgcData.province;
            model.city = location.rgcData.city;
            model.district = location.rgcData.district;
            model.street = location.rgcData.street;
            model.streetNumber = location.rgcData.streetNumber;
            model.cityCode = location.rgcData.cityCode;
            model.adCode = location.rgcData.adCode;
            model.locationDescribe = location.rgcData.locationDescribe;
            
            if (blockInfo) {
                blockInfo(model,error);
            }
            
        }else{
            NSLog(@"获取位置失败：%@",error.description);
            if (blockInfo) {
                blockInfo(model,error);
            }
        }
    }];
     */
    LocaleInfoModel *model;
    NSError *error;
    if (_locationInfo) {
        //获取地理位置成功
        model = [[LocaleInfoModel alloc] init];
        
        model.latitude = [NSString stringWithFormat:@"%.8f",_locationInfo.location.coordinate.latitude];
        model.longitude = [NSString stringWithFormat:@"%.8f",_locationInfo.location.coordinate.longitude];
        
        
        model.country = _locationInfo.rgcData.country;
        model.countryCode = _locationInfo.rgcData.countryCode;
        model.province = _locationInfo.rgcData.province;
        model.city = _locationInfo.rgcData.city;
        model.district = _locationInfo.rgcData.district;
        model.street = _locationInfo.rgcData.street;
        model.streetNumber = _locationInfo.rgcData.streetNumber;
        model.cityCode = _locationInfo.rgcData.cityCode;
        model.adCode = _locationInfo.rgcData.adCode;
        model.locationDescribe = _locationInfo.rgcData.locationDescribe;
        
        if (blockInfo) {
            blockInfo(model,error);
        }
        
    }else{
        if (blockInfo) {
            blockInfo(model,error);
        }
    }

}


#pragma mark - 计算两点之间的距离

+ (double)calculateTheDistanceBetweenTwoPoints:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint{
    
    BMKMapPoint pointStart = BMKMapPointForCoordinate(startPoint);//将 经纬度坐标  转换为 投影后的  直角地理坐标(这个类里都是 转换/判断矩形、点与点 API)
    
    BMKMapPoint pointEnd = BMKMapPointForCoordinate(endPoint);
    
    CLLocationDistance distance = BMKMetersBetweenMapPoints(pointStart, pointEnd);
    
    return distance;
}

#pragma mark - 调用百度地图APP进行导航
///百度地图APP进行导航
+ (void)gotoBaiDuAPPNavigationWithLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName{
    
    //初始化调启导航时的参数管理类
    BMKNaviPara *para = [[BMKNaviPara alloc]init];
    //实例化线路检索节点信息类对象
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    end.pt = location;//CLLocationCoordinate2DMake(39.90868, 116.3956);
    //指定终点名称
    end.name = locationName;//@"天安门";
    //指定终点
    para.endPoint = end;
    //指定返回自定义scheme  (项目里添加协议)
    para.appScheme = @"flashriderbaidu://flashriderbaidumap";
    //应用名称
    para.appName = @"闪送骑手端";
    
    //调起百度地图客户端骑行导航界面
    [BMKNavigation openBaiduMapRideNavigation:para];
}

///获取GPS坐标 （从百度坐标转换）
+ (CLLocationCoordinate2D)getGaoDeMapLocationWithBaiDuLocation:(CLLocationCoordinate2D)locationBD{
    
    //获取高德WGS84坐标 不用转换！！！
    //CLLocationCoordinate2D wgs84j02Coord = CLLocationCoordinate2DMake(location.location.coordinate.latitude, location.location.coordinate.longitude);
    // 转为百度经纬度类型的坐标
    CLLocationCoordinate2D GPS09Coord = BMKCoordTrans(locationBD, BMK_COORDTYPE_BD09LL, BMK_COORDTYPE_COMMON);
    
    return GPS09Coord;
}


///进行导航
+ (void)gotoNavigationWithLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName blockSResult:(APPBackBlock)blockResult{
    
    /**
     设置跳转白名单
     LSApplicationQueriesSchemes ——>NSArray
       1、baidumap
       2、iosamap
       3、comgooglemaps
     */
    
    switch (APPManagerUserInfo.mapNavigation) {
        case APPEnumMapNavigationType_baiduMap:
        {
            //百度地图
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
                [FSBaiDuMapManager gotoBaiDuAPPNavigationWithLocation:location locationName:locationName];
            }else{
                if (blockResult) {
                    blockResult(YES,@"请安装百度地图APP");
                }
            }
        }
            break;
        case APPEnumMapNavigationType_gaodeMap:
        {
            //高德地图
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
                //高德地图 （坐标转换有点问题）
                location = [FSBaiDuMapManager getGaoDeMapLocationWithBaiDuLocation:location];
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"神骑出行",@"TrunkHelper",location.latitude, location.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }else{
                if (blockResult) {
                    blockResult(YES,@"请安装高德地图APP");
                }
            }
        }
            break;
        case APPEnumMapNavigationType_iosMap:
        {
            //系统地图
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]){
                //系统地图
                location = [FSBaiDuMapManager getGaoDeMapLocationWithBaiDuLocation:location];
                [FSMapManager gotoSystemMapNavigationWithLocation:location];
            }else{
                if (blockResult) {
                    blockResult(YES,@"请安装苹果地图APP");
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    /**
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        //百度地图
        [FSBaiDuMapManager gotoBaiDuAPPNavigationWithLocation:location locationName:locationName];
        
    }else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        //高德地图 （坐标转换有点问题）
        location = [FSBaiDuMapManager getGaoDeMapLocationWithBaiDuLocation:location];
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"神骑出行",@"TrunkHelper",location.latitude, location.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]){
        //系统地图
        location = [FSBaiDuMapManager getGaoDeMapLocationWithBaiDuLocation:location];
        [FSMapManager gotoSystemMapNavigationWithLocation:location];
    }else{
        if (blockResult) {
            blockResult(YES,@"请安装百度地图APP");
        }
    }
     */
}


@end




#pragma mark - 位置信息model

@implementation LocaleInfoModel



@end






