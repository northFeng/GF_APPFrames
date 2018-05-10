//
//  APPManager.m
//  GFAPP
//
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPManager.h"

#import "GFTabBarController.h"

#define Current_Login_User @"current_login_user"

@implementation APPManager

///获取APP管理者
+ (APPManager *)sharedInstance
{
    static APPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APPManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if ([super init]) {
        //初始化数据
        [self initializeData];
    }
    return self;
}

- (void)initializeData{
    
    //从本地沙盒获取用户数据
    // 初始化本地用户信息(也可以指定到某个沙盒文件中去)
    NSDictionary * dic = (NSDictionary *)[APPUserDefault objectForKey:Current_Login_User];
    //用户信息
    self.userInfo = [APPUserInfoModel mj_objectWithKeyValues:dic];
    //判断是否登录
    self.isLogined = self.userInfo ? YES : NO;

}

///存储用户信息
- (void)storUserInfo{
    //存储用户信息
    [APPUserDefault setObject:[self.userInfo mj_keyValues] forKey:Current_Login_User];
}

///清楚用户信息
- (void)clearUserInfo{
    
    [APPUserDefault removeObjectForKey:Current_Login_User];
}

///主动退出
- (void)forcedExitUserWithShowControllerItemIndex:(NSInteger)index{
    
    UIWindow *mainWindow = ([UIApplication sharedApplication].delegate).window;
    UINavigationController *rootNavi = (UINavigationController *)mainWindow.rootViewController;
    [rootNavi popToRootViewControllerAnimated:YES];//直接弹到最上层
    
    //tabBar进行切换到我的页面让用户进行登录
    [[GFTabBarController sharedInstance] setSelectItemBtnIndex:index];//设置切换的位置
    
    //进行发送通知刷新所有的界面（利用通知进行刷新根VC）
}

///清楚URL缓存和web中产生的cookie
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}







@end
