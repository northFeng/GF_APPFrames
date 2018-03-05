//
//  APPManager.m
//  GFAPP
//
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPManager.h"

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



@end
