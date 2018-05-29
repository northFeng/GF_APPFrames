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


/**
 AES相比同类对称加密算法速度算是非常快，比如在有AES-NI的x86服务器至少能达到几百M/s的速度。安全性在可预见的未来是基本等同的，因为即使是128位也足够复杂无法被暴力破解。现在112位密码还在商业应用，而128位是112位的几万倍，所以在实务中用128位比较划算(稍节约资源)。
 
 AES256比128大概需要多花40%的时间，用于多出的4轮round key生成以及对应的SPN操作。另外，产生256-bit的密钥可能也需要比128位密钥多些开销，不过这部分开销应该可以忽略。
 安全程度自然是256比128安全，因为目前除了暴力破解，并没有十分有效的代数攻击方法。
 针对具体的AES-256或AES-128的软/硬件实现有特定的攻击方式，不好一概而论。
 
 AES128和AES256主要区别是密钥长度不同（分别是128bits,256bits)、加密处理轮数不同（分别是10轮，14轮），后者强度高于前者。当前AES是较为安全的公认的对称加密算法。
 现代密码学分为对称加密与非对称加密（公钥加密），代表算法分别有DES(现在发展为3DES）、AES与RSA等。非对称加密算法的资源消耗大于对称加密。一般是进行混合加密处理，例如使用RSA进行密钥分发、协商，使用AES进行业务数据的加解密。
 
 */
