//
//  NetWorkReachability.h
//  SECC01
//  系统框架来监测网络变化
//  Created by Harvey on 16/6/29.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HLNetWorkStatus) {
    HLNetWorkStatusNotReachable = 0,
    HLNetWorkStatusUnknown = 1,
    HLNetWorkStatusWWAN2G = 2,
    HLNetWorkStatusWWAN3G = 3,
    HLNetWorkStatusWWAN4G = 4,
    
    HLNetWorkStatusWiFi = 9,
};

extern NSString *kNetWorkReachabilityChangedNotification;

@interface HLNetWorkReachability : NSObject

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

- (BOOL)startNotifier;

- (void)stopNotifier;

- (HLNetWorkStatus)currentReachabilityStatus;

@end



/** 用法

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kNetWorkReachabilityChangedNotification object:nil];
    
    HLNetWorkReachability *reachability = [HLNetWorkReachability reachabilityWithHostName:@"www.baidu.com"];
    self.hostReachability = reachability;
    [reachability startNotifier];
    
    return YES;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    HLNetWorkReachability *curReach = [notification object];
    HLNetWorkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus) {
        case HLNetWorkStatusNotReachable:
            NSLog(@"网络不可用");
            break;
        case HLNetWorkStatusUnknown:
            NSLog(@"未知网络");
            break;
        case HLNetWorkStatusWWAN2G:
            NSLog(@"2G网络");
            break;
        case HLNetWorkStatusWWAN3G:
            NSLog(@"3G网络");
            break;
        case HLNetWorkStatusWWAN4G:
            NSLog(@"4G网络");
            break;
        case HLNetWorkStatusWiFi:
            NSLog(@"WiFi");
            break;
            
        default:
            break;
    }
}
 
 
 
 */
