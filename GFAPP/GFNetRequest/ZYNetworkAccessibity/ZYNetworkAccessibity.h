//
//  ZYNetworkAccessibity.h
//
//  Created by zie on 16/11/17.
//  Copyright © 2017年 zie. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ZYNetworkAccessibityChangedNotification;

typedef NS_ENUM(NSUInteger, ZYNetworkAccessibleState) {
    ZYNetworkChecking  = 0,
    ZYNetworkUnknown     ,
    ZYNetworkAccessible  ,
    ZYNetworkRestricted  ,
};

typedef void (^NetworkAccessibleStateNotifier)(ZYNetworkAccessibleState state);

@interface ZYNetworkAccessibity : NSObject

/**
 开启 ZYNetworkAccessibity
 */
+ (void)start;

/**
 停止 ZYNetworkAccessibity
 */
+ (void)stop;

/**
 当判断网络状态为 ZYNetworkRestricted 时，提示用户开启网络权限
 */
+ (void)setAlertEnable:(BOOL)setAlertEnable;

/**
  通过 block 方式监控网络权限变化。
 */
+ (void)setStateDidUpdateNotifier:(void (^)(ZYNetworkAccessibleState))block;

/**
 返回的是最近一次的网络状态检查结果，若距离上一次检测结果短时间内网络授权状态发生变化，该值可能会不准确。
 */
+ (ZYNetworkAccessibleState)currentState;

@end

/**
#import "ZYNetworkAccessibity.h"
//用法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [ZYNetworkAccessibity setAlertEnable:YES];
    
    [ZYNetworkAccessibity setStateDidUpdateNotifier:^(ZYNetworkAccessibleState state) {
        NSLog(@"setStateDidUpdateNotifier > %zd", state);
    }];
    
    [ZYNetworkAccessibity start];
    
    return YES;
}

用法

1、将 ZYNetworkAccessibity.h 和 ZYNetworkAccessibity.m 在合适的时机，比如 didFinishLaunchingWithOptions 开启，ZYNetworkAccessibity：

[ZYNetworkAccessibity start];
2、监听 ZYNetworkAccessibityChangedNotification 并处理通知

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:ZYNetworkAccessibityChangedNotification object:nil];
- (void)networkChanged:(NSNotification *)notification {
    
    ZYNetworkAccessibleState state = ZYNetworkAccessibity.currentState;
    
    if (state == ZYNetworkRestricted) {
        NSLog(@"网络权限被关闭");
    }
}
另外还实现了自动提醒用户打开权限，如果你需要，请打开

[ZYNetworkAccessibity setAlertEnable:YES];
 
 */
