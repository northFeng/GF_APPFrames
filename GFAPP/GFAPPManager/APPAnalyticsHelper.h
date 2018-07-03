//
//  APPAnalyticsHelper.h
//  GFAPP
//  APP分析与统计（百度移动统计（无埋点/手动埋点）、友盟统计（）、GrowingIO无埋点统计三行代码搞定）
//  Created by gaoyafeng on 2018/5/10.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPAnalyticsHelper : NSObject


//跟踪VC页面 （进入跟离开viewController）
+ (void)analyticsViewController;


#pragma mark - 统计页面  &&  统计事件
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
/**
 NSDictionary *dict = @{@"type" : @"book", @"quantity" : @"3"};
 [MobClick event:@"purchase" attributes:dict];
 统计电商应用中“购买”事件发生的次数，以及购买的商品类型及数量，那么在购买的函数里调用：
 */
+ (void)logEvent:(NSString*)eventId attributes:(NSDictionary *)attributes;

#pragma mark - 统计APP内用户行为（可采用友盟统计、百度统计，是埋点统计）&& pod 'GrowingIO', '~>2.3.1'（诸葛IO无埋点统计，三行搞定统计）






@end
