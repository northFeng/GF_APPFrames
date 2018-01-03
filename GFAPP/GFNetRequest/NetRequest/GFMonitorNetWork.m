//
//  GFURLRequest.h
//  MJExtension
//
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFMonitorNetWork.h"

@interface GFMonitorNetWork ()

//网络监测管理类
@property (readwrite, nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

@end

@implementation GFMonitorNetWork


+ (instancetype)managerForDomain
{
   
    static GFMonitorNetWork *sharedNetWork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetWork = [[GFMonitorNetWork alloc] init];
    });
    
    return sharedNetWork;
 
}

- (instancetype)init
{
    if (self = [super init]) {
        //开始监测网络
        self.reachabilityManager = [AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:AFNetworkingReachabilityDidChangeNotification
                                                   object:nil];
        
    }
    return self;
}

/**
 *  开启网络监听
 */
- (void)startMonitoring
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.reachabilityManager startMonitoring];
    });
}

/**
 *  停止网络监听
 */
- (void)stopMonitoring{
    
    [self.reachabilityManager stopMonitoring];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    
    NSDictionary *statusDictionary = note.userInfo;
    AFNetworkReachabilityStatus status = [[statusDictionary objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    GFNetworkStatus networkStatus;
     NSString *statusString  = nil;
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
        {
            networkStatus = GF_NETWORK_STATUS_NONE;
            statusString = @"网络已经断开";
        }
           
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            networkStatus = GF_NETWORK_STATUS_WWAN;
            statusString = @"正在使用蜂窝网络";
        }
            
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            networkStatus = GF_NETWORK_STATUS_WiFi;
            statusString = @"正在使用WiFi";
        }
           
            break;
        default:
        {
            networkStatus = GF_NETWORK_STATUS_UNKNOWN;
            statusString = @"未知网络类型";
        }
            
            break;
    }
    
    //通知网络
    [[NSNotificationCenter defaultCenter] postNotificationName:_kGlobal_NetworkingReachabilityChangeNotification object:[NSNumber numberWithInt:networkStatus]];
   
}


- (GFNetworkStatus)getNetworkStatus
{
    GFNetworkStatus networkStatus;

    switch (self.reachabilityManager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:
            //没有网络
            networkStatus = GF_NETWORK_STATUS_NONE;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            //蜂窝网络
            networkStatus = GF_NETWORK_STATUS_WWAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            //WiFi网络
            networkStatus = GF_NETWORK_STATUS_WiFi;
            break;
        default:
            //未知网络
            networkStatus = GF_NETWORK_STATUS_UNKNOWN;
            break;
    }
    return networkStatus;
}

- (NSString *)getNetworkStatusDescription{
    NSString *des = @"";
    switch (self.reachabilityManager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:
            des = @"网络未连接";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            des = @"蜂窝移动网络";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            des = @"WiFi网络";
            break;
        default:
            des = @"未知网络";
            break;
    }
    return des;
}
- (NSString *)getNetworkStatusDescriptionForExceptionCache{
    NSString *des = @"1";
    switch (self.reachabilityManager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:
            des = @"1";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            des = @"2";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            des = @"1";
            break;
        default:
            des = @"1";
            break;
    }
    return des;
}

#pragma mark - 监测网络状态
- (void)monitoringNetworkStatus{
    
    //AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //监听状态的改变
    /*
     AFNetworkReachabilityStatusUnknown          = -1, 未知
     AFNetworkReachabilityStatusNotReachable     = 0,  没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,  蜂窝网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2   Wifi
     */
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            default:
                break;
        }
    }];
    
    //开始监听
    //[manager startMonitoring];
    [self.reachabilityManager startMonitoring];
    
}


@end




