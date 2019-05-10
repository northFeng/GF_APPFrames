//
//  FRLoginManager.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/22.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "FRLoginManager.h"

#import "GFNavigationController.h"//导航控制器

#import "FRLoginHomeVC.h"//登录

@implementation FRLoginManager


/**
 *  登录统一入口
 */
+(void)login:(UIViewController *)superViewController completion:(APPBackBlock)block{
    
    if ([APPManager sharedInstance].isLogined) {
        NSLog(@"已登录");
        return ;
    }
    
    FRLoginHomeVC *loginHomeVC = [[FRLoginHomeVC alloc] init];
    loginHomeVC.block = ^(BOOL result, id idObject) {
        
        //进行发送通知刷新所有的界面（利用通知进行刷新根VC）
        [APPNotificationCenter postNotificationName:_kGlobal_LoginStateChange object:nil];
        
        if (block) {
            block(YES,nil);
        }
    };
    
    GFNavigationController *navi = [[GFNavigationController alloc] initWithRootViewController:loginHomeVC];
    navi.navigationBar.hidden = YES;//隐藏系统导航条（只是隐藏的NavigationController上的naviBar，因此返回手势存在）
    
    [superViewController presentViewController:navi animated:YES completion:nil];
    //[[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:navi animated:YES completion:nil];

}


/**
 *  登出接口
 */
+(void)logout:(APPBackBlock)block{
    
    //清楚用户信息
    [[APPManager sharedInstance] clearUserInfo];
    
    
    //进行发送通知刷新所有的界面（利用通知进行刷新根VC）
    [APPNotificationCenter postNotificationName:_kGlobal_LoginStateChange object:nil];
}

@end
