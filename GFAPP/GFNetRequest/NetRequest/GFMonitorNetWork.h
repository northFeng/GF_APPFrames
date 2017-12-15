//
//  GFURLRequest.h
//  MJExtension
//  网络状态监测
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//  Copyright © 2016年 彬万. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GFMonitorNetWork : NSObject

/**
 *  网络监听类的单例
 *
 *  @return <#return value description#>
 */
+ (instancetype)managerForDomain;

/**
 *  启动网络监听
 */
- (void)startMonitoring;

/**
 *  停止网络监听
 */
- (void)stopMonitoring;

/**
 *  获取网络的状态
 *
 *  @return 返回网络的状态
 */
- (GFNetworkStatus)getNetworkStatus;

/**
 *  获取网络的状态描述
 *
 *  @return 返回网络的状态描述
 */
- (NSString *)getNetworkStatusDescription;

/**
 *  获取网络的状态描述 为崩溃上报
 *
 *  @return 返回网络的状态描述 为崩溃上报
 */
- (NSString *)getNetworkStatusDescriptionForExceptionCache;



@end
