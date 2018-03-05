//
//  APPUserInfoModel.h
//  GFAPP
//  用户信息Model
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPUserInfoModel : NSObject

/** 用户id*/
@property (nonatomic, copy) NSString *userId;

/** 用户头像URL */
@property (nonatomic, copy) NSString *iconUrl;

@end
