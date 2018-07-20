//
//  GFValidate.h
//  GFAPP
//  正则验证
//  Created by gaoyafeng on 2018/7/19.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFValidate : NSObject

/** wanbin 2015-01-21 02:44 编辑
 *  邮箱验证
 *
 *  @param candidate 需要验证的邮箱内容
 *
 *  @return 验证结果
 */
+(BOOL) validateEmail: (NSString *) candidate;

/** wanbin 2015-01-21 02:52 编辑
 *  昵称验证
 *
 *  @param candidate 需要验证的昵称内容
 *
 *  @return 验证结果
 */
+(BOOL) validateNick: (NSString *) candidate;

/** wanbin 2015-01-21 02:52 编辑
 *  密码验证
 *
 *  @param candidate 需要验证的密码内容
 *
 *  @return 验证结果
 */
+(BOOL) validatePassWord: (NSString *) candidate;


/**
 *  密码验证复杂度
 *
 *  @param candidate 密码是否含有小写字母、大写字母、数字、特殊符号的两种及以上
 *
 *  @return 验证结果
 */
+ (BOOL)validatePassWordComplex: (NSString *) candidate;


/**
 *  手机号验证
 *
 *  @param candidate 需要验证的密码内容
 *
 *  @return 验证结果
 */
+ (BOOL)valiMobile:(NSString *)mobile;



@end
