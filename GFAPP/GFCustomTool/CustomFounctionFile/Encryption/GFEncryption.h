//
//  GFEncryption.h
//  GFAPP
//  加密
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFEncryption : NSObject

#pragma mark - 哈希算法
///小写16位
+ (NSString *)md5LowercaseString_16:(NSString *)string;

///大写16位
+ (NSString *)md5UppercaseString_16:(NSString *)string;

///小写32位
+ (NSString *)md5LowercaseString_32:(NSString *)string;

///大写32位
+ (NSString *)md5UppercaseString_32:(NSString *)string;


#pragma mark - AES256加解密
///AES加密
+ (NSString *)AES256Encrypt:(NSString *)string;

///AES解密
+ (NSString *)AES256Decrypt:(NSString *)string;

#pragma mark - 3DES加解密
///3DES加密
+ (NSString *)DES3Encrypt:(NSString *)string;

///3SES解密
+ (NSString *)DES3Decrypt:(NSString *)string;


#pragma mark - RSA加解密
///RSA加密
+ (NSString *)RSAEncrypt:(NSString *)string;

///RSA解密
+ (NSString *)RSADecrypt:(NSString *)string;




@end
