//
//  AES.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/30.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "AES.h"

@implementation AES


///AES128加密
+ (NSString *)AES128EncryptWithString:(NSString *)encryString withKeyStirng:(NSString *)keyStr{
    //return [self AES128And256HandleString:encryString peration:kCCEncrypt key:keyStr iv:keyStr type:128];
   return [self AES128And256HandleString:encryString peration:kCCEncrypt key:keyStr type:128];
}

///AES128解密
+ (NSString *)AES128DecryptWithString:(NSString *)encryString withKeyStirng:(NSString *)keyStr{
//    return [self AES128And256HandleString:encryString peration:kCCDecrypt key:keyStr iv:keyStr type:128];
    return [self AES128And256HandleString:encryString peration:kCCDecrypt key:keyStr type:128];
}

///AES256加密
+ (NSString *)AES256EncryptWithString:(NSString *)encryString withKeyStirng:(NSString *)keyStr{
//   return [self AES128And256HandleString:encryString peration:kCCEncrypt key:keyStr iv:keyStr type:256];
    return [self AES128And256HandleString:encryString peration:kCCEncrypt key:keyStr type:256];
}

///AES256解密
+ (NSString *)AES256DecryptWithString:(NSString *)encryString withKeyStirng:(NSString *)keyStr{
//    return [self AES128And256HandleString:encryString peration:kCCDecrypt key:keyStr iv:keyStr type:256];
    return [self AES128And256HandleString:encryString peration:kCCDecrypt key:keyStr type:256];
}


/**
 *  @brief 加解密共同方法
 *
 *  @param AesString : 需要解密/解密 字符串
 *  @param operation : 加密&&解密 kCCEncrypt = 0, kCCDecrypt,
 *
 *  @return NSString
 */
+ (NSString *)AES128And256HandleString:(NSString *)AesString peration:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv type:(NSInteger)type{
    
    NSInteger lengthCount = 0;
    if (type == 128) {
        lengthCount = 16;
    }else if (type == 256){
        lengthCount = 32;
    }
    //kCCKeySizeAES128——>16 / kCCKeySizeAES198——>24 / kCCKeySizeAES256——>32
    char keyPtr[lengthCount+1];//需要改动
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data;
    if (operation == kCCEncrypt) {
        //加密
        data = [AesString dataUsingEncoding:NSUTF8StringEncoding];
    }else if (operation == kCCDecrypt){
        //解密
        data = [[NSData alloc] initWithBase64EncodedString:AesString options:0];
    }
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,//需要改动  加密&&解密——>kCCEncrypt = 0, kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,//需要改动 ———>填充模式，与后台不符合就调整这个模式
                                          keyPtr,
                                          [key length],//秘钥长度  kCCKeySizeAES128/kCCKeySizeAES256——>这个宏也可以
                                          ivPtr,//向量偏移 可以为空NULL /* 初始化向量(可选) */
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        //加密的话转base64  &&  解密转出字符串
        NSString *resultStr;
        if (operation == kCCEncrypt) {
            //加密——>base64字符串
            resultStr = [resultData base64EncodedStringWithOptions:0];
        }else if (operation == kCCDecrypt){
            //解密
            resultStr = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        }
        return resultStr;
    }
    free(buffer);
    return nil;
}



/**
 *  @brief 加解密共同方法
 *
 *  @param AesString : 需要解密/解密 字符串
 *  @param operation : 加密&&解密 kCCEncrypt = 0, kCCDecrypt,
 *
 *  @return NSString
 */
+ (NSString *)AES128And256HandleString:(NSString *)AesString peration:(CCOperation)operation key:(NSString *)key type:(NSInteger)type{
    
    NSInteger lengthCount = 0;
    if (type == 128) {
        lengthCount = 16;
    }else if (type == 256){
        lengthCount = 32;
    }
    //kCCKeySizeAES128——>16 / kCCKeySizeAES198——>24 / kCCKeySizeAES256——>32
    char keyPtr[lengthCount+1];//需要改动
    //memset(keyPtr, 0, sizeof(keyPtr));
    bzero(keyPtr, sizeof(keyPtr));
    BOOL suc = [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    if (!suc) {
        return nil;
    }
    
    NSData *data;
    if (operation == kCCEncrypt) {
        //加密
        data = [AesString dataUsingEncoding:NSUTF8StringEncoding];
    }else if (operation == kCCDecrypt){
        //解密
        data = [[NSData alloc] initWithBase64EncodedString:AesString options:0];
    }
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,//需要改动  加密&&解密——>kCCEncrypt = 0, kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,//需要改动 ———>填充模式，与后台不符合就调整这个模式
                                          keyPtr,
                                          [key length],//秘钥长度  kCCKeySizeAES128/kCCKeySizeAES256——>这个宏也可以
                                          NULL,//向量偏移 可以为空NULL
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        //加密的话转base64  &&  解密转出字符串
        NSString *resultStr;
        if (operation == kCCEncrypt) {
            //加密——>base64字符串
            resultStr = [resultData base64EncodedStringWithOptions:0];
        }else if (operation == kCCDecrypt){
            //解密
            resultStr = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        }
        return resultStr;
    }
    free(buffer);
    return nil;
}



@end
