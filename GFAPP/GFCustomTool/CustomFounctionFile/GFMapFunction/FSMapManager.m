//
//  FSMapManager.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/8/25.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSMapManager.h"

@interface FSMapManager () <CLLocationManagerDelegate>//遵守定位代理

///定位管理者
@property (nonatomic,strong) CLLocationManager *locationManager;

///block
@property (nonatomic,copy) BlockLocalInfo BlockLocalInfo;

///位置字符串
@property (nonatomic,copy) NSString *localCodeString;

///位置地名
@property (nonatomic,copy) NSString *localNameString;

@end

@implementation FSMapManager


///获取地图管理者
+(instancetype)shareInstance
{
    static FSMapManager *mapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapManager = [[self alloc] init];
    });
    return mapManager;
}




///获取地理位置信息
- (void)getGeographicInformationWithCallback:(BlockLocalInfo)BlockLocalInfo{
    
    _BlockLocalInfo = BlockLocalInfo;
    
//    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
//        //申请用户位置权限
//        [self.locationManager requestAlwaysAuthorization];
//    }else{
//
//        //开始跟新用户位置
//        [self.locationManager startUpdatingLocation];
//    }

    if (self.localCodeString.length > 0) {
        NSString *localCode = [self.localCodeString copy];
        NSString *localName = [self.localNameString copy];
        self.BlockLocalInfo(localCode, localName);
    }else{
        //申请用户位置权限
        [self.locationManager requestAlwaysAuthorization];
        //开始跟新用户位置
        [self.locationManager startUpdatingLocation];
    }
}

///获取地理编码
- (void)getGeographicCodeStrWithAddressStr:(NSString *)addressName callBlock:(BlockLocalInfo)BlockLocalInfo{
    
    //地理编码器
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    APPWeakSelf
    //地理编码器 ---> 根据地理编码 得到 位置名字  / 根据 名字 反编码 出 地理编码
    [geocoder geocodeAddressString:addressName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        for (CLPlacemark *placemark in placemarks) {
            
            if (placemark != nil) {
                //坐标（经纬度）地理编码
                CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                
                //获取的地理编码
                NSString *codeStr = [NSString stringWithFormat:@"%.8f+%.8f", coordinate.longitude,coordinate.latitude];
                
                if (weakSelf.BlockLocalInfo) {
                    weakSelf.BlockLocalInfo(codeStr, @"");
                }
                break ;
            }
        }
        
    }];
    
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self createLocationManager];
    }
    return self;
}

///创建地理信息管理者
- (void)createLocationManager{
    
    //位置管理器常见属性
    //当用户移动多长距离，才更新用户位置，单位 米
    self.locationManager.distanceFilter = 10;
    
    //定位精度，精度越高越费电
    /*
     extern const CLLocationAccuracy kCLLocationAccuracyBestForNavigation __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
     extern const CLLocationAccuracy kCLLocationAccuracyBest;
     extern const CLLocationAccuracy kCLLocationAccuracyNearestTenMeters;
     extern const CLLocationAccuracy kCLLocationAccuracyHundredMeters;
     extern const CLLocationAccuracy kCLLocationAccuracyKilometer;
     extern const CLLocationAccuracy kCLLocationAccuracyThreeKilometers;
     
     */
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //导航类型
    /*
     CLActivityTypeOther = 1,
     CLActivityTypeAutomotiveNavigation,    // 汽车导航
     CLActivityTypeFitness,                // 步行
     CLActivityTypeOtherNavigation //其他导航
     */
    //self.locationManager.activityType = CLActivityTypeOther;
}


///懒加载
- (CLLocationManager *)locationManager{
    
    if (_locationManager == nil) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
    }
    
    return _locationManager;
}



#pragma mark - 定位代理

///当授权状态发生改变时调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"用户授权失败");
        //申请用户位置权限
        [self.locationManager requestAlwaysAuthorization];
    }
    
}


///当更新用户位置时 调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //距离当前时间最近的那个位置是这个数组的最后一个元素
    CLLocation *lastLocation = locations.lastObject;
    /**
     struct CLLocationCoordinate2D {
     CLLocationDegrees latitude;
     CLLocationDegrees longitude;
     };
     */
    CGFloat weidu = lastLocation.coordinate.latitude;
    CGFloat jingdu = lastLocation.coordinate.longitude;
    
    NSString *geocodingStr = [NSString stringWithFormat:@"%.8f|%.8f",jingdu,weidu];
    
    self.localCodeString = [geocodingStr copy];
    
    //地理编码器
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //反地理编码
    APPWeakSelf
    [geocoder reverseGeocodeLocation:lastLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        //CLPlacemark 地标：描述了地理的经纬度， 地名，省，市，区，街，道
        for (CLPlacemark *placemark in placemarks) {
            
            NSLog(@"获取的经度：%f,纬度：%f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
            
            NSDictionary *addressDic = placemark.addressDictionary;
            NSString *state = [addressDic objectForKey:@"State"];
            NSString *city = [addressDic objectForKey:@"City"];
            NSString *subLocality= [addressDic objectForKey:@"SubLocality"];
            NSString *street = [addressDic objectForKey:@"Street"];
            NSLog(@"%@%@%@%@",state,city,subLocality,street);
            
            //地址名字
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
            weakSelf.localNameString = [address copy];
            if (weakSelf.BlockLocalInfo) {
                //执行回调
                weakSelf.BlockLocalInfo(geocodingStr, address);
            }
        }
        
    }];
    
    [manager stopUpdatingLocation];   //停止定位
}


#pragma mark - 计算两点之间的距离
- (double)distanceByLongitude:(double)longitude1 latitude:(double)latitude1 longitude:(double)longitude2 latitude:(double)latitude2{
    
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
    
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];
    
    double distance  = [curLocation distanceFromLocation:otherLocation];//单位是m
    return distance;
}


///跳到系统地图
+ (void)gotoSystemMapNavigationWithLocation:(CLLocationCoordinate2D)location{
    
    ////跳转系统地图
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    
    //目的地
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil]];
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
     
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}




@end
