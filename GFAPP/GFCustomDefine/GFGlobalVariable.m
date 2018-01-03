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
NSString * const _kGlobal_RequestTimeout                   =       @"请求超时";
NSString * const _kGlobal_NetworkAnomaly                   =       @"网络异常";
NSString * const _kGlobal_NetworkNone                      =       @"无网络连接";
NSString * const _kGlobal_NetworkFailure                   =       @"网络连接失败";
NSString * const _kGlobal_NetworkFailureLaterOption        =       @"网络连接失败,请稍后重试";
NSString * const _kGlobal_CheckNetwork                     =       @"请检查网络设置";
NSString * const _kGlobal_NetworkChangeGPRS                  =       @"已切换到非WiFi网络";
NSString * const _kGlobal_NetworkChangeWiFi                =       @"已切换到WiFi网络";
NSString * const _kGlobal_NoneNetworkIsNone                =       @"亲、当前无网络,请连接网络后重试";

