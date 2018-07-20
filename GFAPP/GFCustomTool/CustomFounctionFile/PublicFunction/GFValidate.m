//
//  GFValidate.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/7/19.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFValidate.h"

@implementation GFValidate


/** wanbin 2015-01-21 02:44 编辑
 *  邮箱验证
 *
 *  @param candidate 需要验证的邮箱内容
 *
 *  @return 验证结果
 */
+(BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}


/** wanbin 2015-01-21 02:52 编辑
 *  昵称验证
 *
 *  @param candidate 需要验证的昵称内容
 *
 *  @return 验证结果
 */
+(BOOL) validateNick: (NSString *) candidate
{
    NSString *nickRegex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *nicklTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nickRegex];
    return [nicklTest evaluateWithObject:candidate];
}


/** wanbin 2015-01-21 02:52 编辑
 *  密码验证
 *
 *  @param candidate 需要验证的密码内容
 *
 *  @return 验证结果
 */
+(BOOL) validatePassWord: (NSString *) candidate
{
    
    NSString *passWordRegex = @"^[^\\s]{6,12}$";//@"^[\\dA-Za-z(!@#$%&_.)]{6,16}$";
    NSPredicate *passWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordTest evaluateWithObject:candidate];
}


/**
 *  密码验证复杂度
 *
 *  @param candidate 密码是否含有小写字母、大写字母、数字、特殊符号的两种及以上
 *
 *  @return 验证结果
 */
+ (BOOL)validatePassWordComplex: (NSString *) candidate
{
    
    NSString *passWordRegex = @"^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{6,12}$";
    NSPredicate *passWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordTest evaluateWithObject:candidate];
}

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        NSString *MOBILE = @"^1+[123456789]+\\d{9}";//@"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        return [regextestmobile evaluateWithObject:mobile];
    }
}


@end
