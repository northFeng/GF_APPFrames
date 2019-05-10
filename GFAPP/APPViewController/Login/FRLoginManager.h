//
//  FRLoginManager.h
//  FlashRider
//  APP统一登录管理类
//  Created by gaoyafeng on 2018/11/22.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FRLoginManager : NSObject


/**
 *  登录统一入口
 *
 *  @param superViewController 上下文
 *  @param block          登录回调
 */
+(void)login:(UIViewController *)superViewController completion:(APPBackBlock)block;


/**
 *  登出接口
 *
 *  @param block 登出回调
 */
+(void)logout:(APPBackBlock)block;



@end

NS_ASSUME_NONNULL_END
