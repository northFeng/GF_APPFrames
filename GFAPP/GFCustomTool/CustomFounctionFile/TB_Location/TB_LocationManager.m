//
//  TB_LocationManager.m
//  WealthBorrowed
//
//  Created by 斑马 on 2017/9/12.
//  Copyright © 2017年 斑马. All rights reserved.
//

#import "TB_LocationManager.h"

#import "PPAddressBookHandle.h"

#import <CoreLocation/CoreLocation.h>

@interface TB_LocationManager ()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *locMgr;

@end

@implementation TB_LocationManager


+ (instancetype)TB_ShareLocation
{
    static TB_LocationManager * manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[self new];
    });
    return manager;
}

-(BOOL)TB_ChargeIslocation{

    return [CLLocationManager locationServicesEnabled] ? NO : YES;

}

-(void)TB_StartRequstLocation{

    [self.locMgr startUpdatingLocation];//是否开启定位
    [self.locMgr requestWhenInUseAuthorization];
    
}

#pragma mark - 代理方法，当授权改变时调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    

    
    // 获取授权后，通过
    if (status == kCLAuthorizationStatusAuthorizedAlways) {

        
        //开始定位(具体位置要通过代理获得)
        [self.locMgr startUpdatingLocation];
        
        //设置精确度
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        //设置过滤距离
        self.locMgr.distanceFilter = 1000;
        
        //开始定位方向
        [self.locMgr startUpdatingHeading];
    }
    else if(status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        self.lislocation = @"0";
        //  定位授权成功
        [PPAddressBookHandle sharedAddressBookHandle].isLocation = @"0";
    }
    else
    {
        self.lislocation = @"1";
        //  定位授权失败
        [PPAddressBookHandle sharedAddressBookHandle].isLocation = @"1";
        
    }
    
}

#pragma mark - 方向
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    //输出方向

    //地理方向
    NSLog(@"true = %f ",newHeading.trueHeading);
    
    // 磁极方向
    NSLog(@"mag = %f",newHeading.magneticHeading);
}

#pragma mark - 定位代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //    NSLog(@"%@",locations);
    
    
    
    //获取当前位置
    CLLocation *location = manager.location;
    //获取坐标
    CLLocationCoordinate2D corrdinate = location.coordinate;
    
    //打印地址
    NSLog(@"latitude = %f longtude = %f",corrdinate.latitude,corrdinate.longitude);
    
    // 地址的编码通过经纬度得到具体的地址
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks firstObject];
        
        self.locationstar = placemark.name;
        
        [PPAddressBookHandle sharedAddressBookHandle].locaionstr = placemark.name;
        
        //打印地址
        NSLog(@"%@",placemark.name);
    }];
    
    // 通过具体地址去获得经纬度
    CLGeocoder *coder = [[CLGeocoder alloc] init];
    
    if(self.locationstar.length>0){
        
//        [coder geocodeAddressString:@"鸟巢" completionHandler:^(NSArray *placemarks, NSError *error) {
//            
//            NSLog(@"_________________________反编码");
//            
//            CLPlacemark *placeMark = [placemarks firstObject];
//            
//            NSLog(@"%@ lati = %f long = %f",placeMark.name,placeMark.location.coordinate.latitude,placeMark.location.coordinate.longitude);
//        }];
        
        NSLog(@"定位的地址-----%@",self.locationstar);
        //停止定位
        [self.locMgr stopUpdatingLocation];
        
    }

    
}

//检测网络
-(void)detectionNetwork
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
        }
    }];
    
    //开始监控
    [manager startMonitoring];
}





-(CLLocationManager *)locMgr{
    if (_locMgr==nil)
    {
       //1.创建位置管理器（定位用户的位置）
       _locMgr=[[CLLocationManager alloc]init];
        //2.设置代理
       _locMgr.delegate=self;
        [_locMgr requestAlwaysAuthorization];
        _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
        _locMgr.distanceFilter = 30;
        _locMgr.activityType = CLActivityTypeFitness;
        _locMgr.pausesLocationUpdatesAutomatically = NO;
    }
    return _locMgr;
}

@end
