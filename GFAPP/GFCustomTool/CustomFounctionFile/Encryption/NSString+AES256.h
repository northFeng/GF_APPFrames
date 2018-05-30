//
//  NSString+AES256.h
//  GFEncryptionAndDecryption
//
//  Created by 峰·高 on 2017/4/27.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES256)
/**
 AES128-->使用的key秘钥必须是：16位
 AES256-->使用的key秘钥必须是：32位
 */
///加密
+ (NSString *)AES256Encrypt:(NSString *)message WithKeyString:(NSString *)key;

///解密
+ (NSString *)AES256Decrypt:(NSString *)base64EncodedString WithKeyString:(NSString *)key;

///固定的key
+ (NSString *)getAKey;

///生成八位随机字符串
+ (NSString *)shuffledAlphabet;




@end


