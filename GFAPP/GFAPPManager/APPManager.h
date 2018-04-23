//
//  APPManager.h
//  GFAPP
//  APP管理者
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APPUserInfoModel.h"//用户信息Model

@interface APPManager : NSObject

/** 是否处于已登录状态 */
@property (atomic, strong) APPUserInfoModel *userInfo;


/** 是否处于已登录状态 */
@property (nonatomic, assign) BOOL isLogined;


/**
 *  APP管理者单例
 */
+ (APPManager *)sharedInstance;


///存储用户信息
- (void)storUserInfo;

///清楚用户信息
- (void)clearUserInfo;

///主动退出
- (void)forcedExitUser;


@end
