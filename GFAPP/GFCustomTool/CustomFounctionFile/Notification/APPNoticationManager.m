//
//  APPNoticationManager.m
//  FlashRider
//
//  Created by gaoyafeng on 2019/1/30.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPNoticationManager.h"


@implementation APPNoticationManager

+ (instancetype)shareInstance
{
    static APPNoticationManager *notiMannager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notiMannager = [[APPNoticationManager alloc] init];
        notiMannager.appBadge = 0;
    });
    return notiMannager;
}

///注册通知
- (void)registerLocalAPN{
    
    if (@available(iOS 10.0, *)) { // iOS10 以上
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        //center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge + UNAuthorizationOptionSound + UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
    } else {// iOS8.0 以上
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}

///添加一个本地通知
- (void)addLocalNoticeWithTitle:(NSString *)title subTitle:(NSString *)subTitle notiId:(NSString *)notiId{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        // 标题
        content.title = @"您有新的订单了，请及时接单";
        content.subtitle = title;
        // 内容
        content.body = subTitle;
        // 声音
        // 默认声音
        content.sound = [UNNotificationSound defaultSound];
        // 添加自定义声音
        //content.sound = [UNNotificationSound soundNamed:@"Alert_ActivityGoalAttained_Salient_Haptic.caf"];
        // 角标
        content.badge = [NSNumber numberWithInteger:++self.appBadge];
        
        // 多少秒后发送,可以将固定的日期转化为时间
        NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:1.0] timeIntervalSinceNow];
        //        NSTimeInterval time = 10;
        // repeats，是否重复，如果重复的话时间必须大于60s，要不会报错
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
        
        
        //添加通知的标识符，可以用于移除，更新等操作
        NSString *identifier = notiId;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"成功添加推送");
        }];
        
    }else {
        UILocalNotification *notif = [[UILocalNotification alloc] init];
    
        //设置调用时间
        notif.timeZone = [NSTimeZone localTimeZone];
        notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];//通知触发的时间，10s以后
        notif.repeatInterval = 0;//通知重复次数
        //notif.repeatCalendar = [NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        
        //设置通知属性
        if (@available(iOS 8.2, *)) {
            notif.alertTitle = @"您有新的订单了，请及时接单";
            notif.alertBody = [NSString stringWithFormat:@"%@\n%@",title,subTitle]; //通知主体 推送的内容
        } else {
            // Fallback on earlier versions
            notif.alertBody = [NSString stringWithFormat:@"您有新的订单了，请及时接单\n%@\n%@",title,subTitle]; //通知主体 推送的内容
        }
        
        //notif.applicationIconBadgeNumber += 1;//应用程序图标右上角显示的消息数
        if (APPManagerObject.isEnterBackground) {
            //设置角标
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:(self.appBadge ++)];
        }
        
        //notif.alertAction = @"打开应用"; //待机界面的滑动动作提示
        notif.alertLaunchImage = @"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        
        notif.soundName = UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        //    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息 && 可以添加特定信息
        notif.userInfo = @{@"noticeId":notiId};//绑定到通知上的其他附加信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}


///移除某一个指定的通知
- (void)removeOneNotificationWithID:(NSString *)noticeId{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            for (UNNotificationRequest *req in requests){
                NSLog(@"存在的ID:%@\n",req.identifier);
            }
            NSLog(@"移除currentID:%@",noticeId);
        }];
        
        [center removePendingNotificationRequestsWithIdentifiers:@[noticeId]];
    }else {
        NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *localNotification in array){
            NSDictionary *userInfo = localNotification.userInfo;
            NSString *obj = [userInfo objectForKey:@"noticeId"];
            if ([obj isEqualToString:noticeId]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
}

///移除所有通知
- (void)removeAllNotification{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllPendingNotificationRequests];
    }else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}


///判断用户是否允许接收通知
- (BOOL)checkUserNotificationEnable{
    
    __block BOOL isOn = NO;
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.notificationCenterSetting == UNNotificationSettingEnabled) {
                isOn = YES;
                NSLog(@"打开了通知");
            }else {
                isOn = NO;
                NSLog(@"关闭了通知");
                [self showAlertView];
            }
        }];
    }else {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone){
            NSLog(@"关闭了通知");
            isOn = NO;
            [self showAlertView];
        }else {
            NSLog(@"打开了通知");
            isOn = YES;
        }
    }
    
    return isOn;
}

///判断用户是否允许接受通知（改进）
- (void)checkUserNotificationEnableBlock:(APPBackBlock)blockResult{
    
    __block BOOL isOn = NO;
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.notificationCenterSetting == UNNotificationSettingEnabled) {
                isOn = YES;
                NSLog(@"打开了通知");
            }else {
                isOn = NO;
                NSLog(@"关闭了通知");
                [self showAlertView];
            }
            if (blockResult) {
                blockResult(isOn,nil);
            }
        }];
    }else {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone){
            NSLog(@"关闭了通知");
            isOn = NO;
            [self showAlertView];
        }else {
            NSLog(@"打开了通知");
            isOn = YES;
        }
        if (blockResult) {
            blockResult(isOn,nil);
        }
    }
}

- (void)showAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"未获得通知权限，为了您能够及时抢单，请到 设置—>通知—>闪送骑手端 打开通知权限" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改
- (void)goToAppSystemSetting {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [application openURL:url options:@{} completionHandler:nil];
                }
            }else {
                [application openURL:url];
            }
        }
    });
}


#pragma mark - ****************** 通知代理 ******************

//ios10  && ios8的本地通知代理在 application.m中

//发送本地通知，收到通知会触发此代理
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(ios(10.0)){
    
}

//处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler __IOS_AVAILABLE(10.0){
    
    completionHandler();
}

/**
 如果已经注册了本地通知，当客户端响应通知时：
 
 a、应用程序在后台的时候，本地通知会给设备送达一个和远程通知一样的提醒
 
 b、应用程序正在运行中，则设备不会收到提醒!!!!!!!，但是会走应用程序delegate中的方法：
 - (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
 　　}
 
 */



@end
