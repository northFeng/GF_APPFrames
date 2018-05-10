//
//  APPAnalyticsHelper.h
//  GFAPP
//  APP分析与统计
//  Created by gaoyafeng on 2018/5/10.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPAnalyticsHelper : NSObject

//统计进入跟离开viewController
+ (void)analyticsViewController;

// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)beginLogPageView:(__unsafe_unretained Class)pageView;
// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)endLogPageView:(__unsafe_unretained Class)pageView;

// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)beginLogPageViewName:(NSString *)pageViewName;
// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)endLogPageViewName:(NSString *)pageViewName;

/// 自定义事件
+ (void)logEvent:(NSString*)eventId;
+ (void)logEvent:(NSString*)eventId attributes:(NSDictionary *)attributes;

@end
