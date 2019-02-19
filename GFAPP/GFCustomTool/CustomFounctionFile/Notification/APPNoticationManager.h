//
//  APPNoticationManager.h
//  FlashRider
//
//  Created by gaoyafeng on 2019/1/30.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

// iOS10.0 需要导入
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPNoticationManager : NSObject <UNUserNotificationCenterDelegate>

///角标
@property (nonatomic,assign) NSInteger appBadge;

///单利初始化
+ (instancetype)shareInstance;

///注册通知
- (void)registerLocalAPN;

///添加一个本地通知
- (void)addLocalNoticeWithTitle:(NSString *)title subTitle:(NSString *)subTitle notiId:(NSString *)notiId;

///移除某一个指定的通知
- (void)removeOneNotificationWithID:(NSString *)noticeId;

/** 移除所有通知
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//设置为0时，会清除 角标！&&通知栏！
  [[APPNoticationManager shareInstance] removeAllNotification];//移除所有的通知 ——> 不会清除角标&&通知栏 只是清除ios系统通知中心中已发送的通知(未发生的)
 */
- (void)removeAllNotification;

///判断用户是否允许接收通知
- (BOOL)checkUserNotificationEnable;

///判断用户是否允许接受通知（改进）
- (void)checkUserNotificationEnableBlock:(APPBackBlock)blockResult;



@end

NS_ASSUME_NONNULL_END

