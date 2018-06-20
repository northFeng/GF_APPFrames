//
//  AppDelegate.m
//  GFAPP
//
//  Created by XinKun on 2017/4/21.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "AppDelegate.h"

#import "APPAnalyticsHelper.h"//分析统计

//设置根视图
#import "AppDelegate+RootController.h"

#import <IQKeyboardManager/IQKeyboardManager.h>//键盘框架


@interface AppDelegate ()

@end

@implementation AppDelegate
/**
 控制台打印：Application Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app’s Info.plist file.
 原因是：苹果官方为了安全使用了HTPPS 作为安全访问链接，如果想继续使用http
 
 解决办法：修改info.plist文件
 在 App Transport Security Settings 添加: Allow Arbitrary Loads 设置为YES 
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //四大管家
    [APPNetRequestManager sharedInstance];
    [APPManager sharedInstance];
    [APPCoreDataManager sharedInstance];
    [APPLogisticsManager sharedInstance];
    
    //设置键盘弹出
    [self setKeyBoard];
    
    //对APP做特别的配置
    [self setAPPConfiguration];
    
    //是否旋转
    self.allowRotate = NO;
    [self setRootViewController];
    
    
#if DEBUG
    //输入页面跟踪信息
    [APPAnalyticsHelper analyticsViewController];
#endif
    
    

    return YES;
}

///设置APP内的特别设置
- (void)setAPPConfiguration{
    
    //设置界面按钮只能点击一个（在iOS8-8.2有问题可能会崩溃）
    [[UIButton appearance] setExclusiveTouch:YES];
    
}


///设置键盘弹出
- (void)setKeyBoard{
    
    //******** 系统键盘做处理 ********
    //默认为YES，关闭为NO
    [IQKeyboardManager sharedManager].enable = YES;
    //键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //隐藏键盘上面的toolBar,默认是开启的
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}


#pragma mark - 设置APP的旋转方向
/*  这个方法来控制APP的屏幕旋转，viewController里面的代码是来控制界面的旋转
 1.建议去掉General里Device Orientation的勾选用代码方式设置。
 2.建议在AppDelegate.h里设置公有属性，通过设置该属性来灵活改变App支持方向。
 3.此方法在shouldAutorotate返回YES时会触发。
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotate) {

        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else {

        return UIInterfaceOrientationMaskPortrait;
    }
}

/** 通过改变状态栏的方向+旋转viewController，来达到屏幕旋转的假象iOS7之前使用以下方法
//     CGFloat rotation;
//     UIInterfaceOrientation orientation;
//
//     if (btn.selected) {
//         rotation = 0;
//         btn.selected = NO;
//         orientation = UIInterfaceOrientationPortrait;
//     }else {
//         rotation = 0.5;
//         btn.selected = YES;
//         orientation = UIInterfaceOrientationLandscapeLeft;
//
//     }
//     //状态栏动画持续时间
//     CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
//     [UIView animateWithDuration:duration animations:^{
//     //修改状态栏的方向及view的方向进而强制旋转屏幕
//         [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];
//         self.transform = CGAffineTransformMakeRotation(M_PI*(rotation));
//         self.frame = GF_SCREEN_BOUNDS;
//     }];

 */

@end
