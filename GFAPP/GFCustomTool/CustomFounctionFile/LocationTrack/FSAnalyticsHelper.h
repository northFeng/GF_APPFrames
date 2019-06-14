//
//  FSAnalyticsHelper.h
//  FlashSend
//  APP分析与统计
//  Created by gaoyafeng on 2018/8/24.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSAnalyticsHelper : NSObject

//跟踪VC页面 （进入跟离开viewController）
+ (void)analyticsViewController;

///设置键盘弹出
+ (void)setKeyBoardlayout;


#pragma mark - 神策数据统计分析

///添加神策统计
+ (void)addSCDataStatisticalWithDic:(NSDictionary *)launchOptions;

/// 自定义事件
+ (void)logEvent:(NSString*)eventId;

///统计事件 + 属性
+ (void)logEvent:(NSString*)eventId attributes:(NSDictionary *)attributes;

///事件开始
+ (void)logEventTimeLengthWithBegin:(NSString *)eventViewId;

///事件结束
+ (void)logEventTimeLengthWithEnd:(NSString *)eventViewId;

///事件结束 && 属性
+ (void)logEventTimeLengthWithEnd:(NSString *)eventViewId attributes:(NSDictionary *)attributes;

///获取匿名ID
+ (NSString *)loginGetSCId;

///用户注册——>关联 DistinctId(匿名 ID)
+ (void)loginEventWithUserId:(NSString *)userId;

///设置用户属性
+ (void)loginUserInfoWithDic:(NSDictionary *)attributes;

///数值类型的属性累加
+ (void)loginNumTypeCumulativeWithDic:(NSDictionary *)attributes;

///统计webView
+ (BOOL)loginWebViewWithWebView:(id)webView request:(NSURLRequest *)request attributes:(NSDictionary *)attributes;

///设置神策发送数据时间间隔(默认15秒)
+ (void)loginSendDataTimeInterval:(NSInteger)interval;

///设置缓存条数 神策分析 SDK 默认的 flushBulkSize 为 100 条。可以设置 flushBulkSize 属性，修改事件发送的阈值。
+ (void)loginCachAerticleNumber:(NSInteger)number;

///在 App 进入后台状态前，神策分析 SDK 会将本地缓存的数据发送到神策分析
+ (void)loginAutoSendDataBeforeEnterBackground:(BOOL)isAuto;

///设置同步数据时的网络策略 神策分析 SDK 默认在 3G／4G／WI-FI 环境下，SDK 都会尝试发送数据
+ (void)loginSetSendNetState;

///设置本地缓存上限值 SDK 本地数据库默认缓存数据的上限值为10000条
+ (void)loginSetCacheMaxnum:(NSInteger)number;

///Debug 模式下，关闭提示框  Debug 模式下，数据出错时默认会以提示框的方式提示开发者。
+ (void)loginSetAlertClose:(BOOL)isClose;




@end

NS_ASSUME_NONNULL_END
