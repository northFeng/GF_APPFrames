//
//  GFGlobalVariable.m
//  GFAPP
//  全局变量
//  Created by XinKun on 2017/5/7.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFGlobalVariable.h"

/** 网络状态变化key */
NSString * const _kGlobal_NetworkingReachabilityChangeNotification = @"GFNetworkingReachabilityDidChangeNotification";

/** SDWebImage框架缓存Cache文件下路径 */
NSString * const _kGlobal_SDWebImagePath = @"default/com.hackemist.SDWebImageCache.default";

/** 首页标题 */
NSString * const _kGlobal_home_title = @"首页";

#pragma mark - 网络相关的提示
NSString * const _kGlobal_Network_RequestTimeout       =       @"请求超时";
NSString * const _kGlobal_Network_Anomaly              =       @"网络异常";
NSString * const _kGlobal_Network_NoneConnect          =       @"无网络连接";
NSString * const _kGlobal_Network_Failure              =       @"网络连接失败";
NSString * const _kGlobal_Network_FailureLaterOption   =       @"网络连接失败,请稍后重试";
NSString * const _kGlobal_Network_CheckNetwork         =       @"请检查网络设置";
NSString * const _kGlobal_Network_ChangeGPRS           =       @"已切换到非WiFi网络";
NSString * const _kGlobal_Network_ChangeWiFi           =       @"已切换到WiFi网络";
NSString * const _kGlobal_Network_IsNone               =       @"亲、当前无网络,请连接网络后重试";


