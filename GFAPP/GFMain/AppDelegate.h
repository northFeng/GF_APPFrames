//
//  AppDelegate.h
//  GFAPP
//
//  Created by XinKun on 2017/4/21.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 引导滑动图 */
@property (nonatomic,strong) UIScrollView *scrollerView;

///是否允许屏幕旋转
@property (nonatomic,assign) BOOL allowRotate;

@end


/**
//蒲公英测试
 
 # 集成蒲公英测试，上线必须注销
 pod 'Pgyer'
 pod 'PgyUpdate'

//蒲公英测试应用
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

//*************** 蒲公英测试 **************
//启动基本SDK
[[PgyManager sharedPgyManager] startManagerWithAppId:@"f2eb6f9e70ef7770794a172f1b2a65c3"];
//启动更新检查SDK
[[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"f2eb6f9e70ef7770794a172f1b2a65c3"];
[[PgyUpdateManager sharedPgyManager] checkUpdate];
//关闭反馈功能
[[PgyManager sharedPgyManager] setEnableFeedback:NO];
 
 */
