//
//  NSString+AES256.m
//  GFEncryptionAndDecryption
//
//  Created by 峰·高 on 2017/4/27.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "NSString+AES256.h"

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


#define XOR_KEY 0xBB

void xorString(unsigned char *str, unsigned char key)
{
    unsigned char *p = str;
    while( ((*p) ^=  key) != '\0')  p++;
}


@implementation NSString (AES256)

#pragma mark - 加密
///加密
+ (NSString *)AES256Encrypt:(NSString *)message WithKeyString:(NSString *)key{
    
    NSData *decry = [self AES256Encrypt:[message dataUsingEncoding:NSUTF8StringEncoding] WithKey:key];
    NSString *descryStr = [decry base64EncodedStringWithOptions:0];
    return descryStr;
}



+ (NSData *)AES256Encrypt:(NSData *)data WithKey:(NSString *)key{//加密
    
    char keyPtr[kCCKeySizeAES256 + 1];//改动
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCKeySizeAES256,//秘钥长度
                                          NULL,//向量偏移量
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

#pragma mark - 解密
///解密
+ (NSString *)AES256Decrypt:(NSString *)base64EncodedString WithKeyString:(NSString *)key
{
    if(base64EncodedString){
        NSData *encryptedData =  [[NSData alloc] initWithBase64EncodedString:base64EncodedString options:0];
        
        NSData *decry = [self AES256Decrypt:encryptedData WithKey:key];
        
        NSString *descryStr = [[NSString alloc] initWithData:decry encoding:NSUTF8StringEncoding];
        
        return descryStr;
    }
    else{
        return @"";
    }
}


+ (NSData *)AES256Decrypt:(NSData *)data WithKey:(NSString *)key
{
    
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    
    BOOL suc = [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    if (!suc) return [NSData data];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding/*这里就是刚才说到的PKCS7Padding填充了*/ | kCCOptionECBMode,
                                          keyPtr,
                                          kCCKeySizeAES256,//秘钥长度
                                          NULL,/* 初始化向量(可选) */
                                          [data bytes],
                                          dataLength,/* 输入 */
                                          buffer, bufferSize,/* 输出 */
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

///固定的key
+ (NSString *)getAKey{
    
    unsigned char str[] ={
        (XOR_KEY ^ '1'),
        (XOR_KEY ^ '3'),
        (XOR_KEY ^ '2'),
        (XOR_KEY ^ 'q'),
        (XOR_KEY ^ 'w'),
        (XOR_KEY ^ 'e'),
        (XOR_KEY ^ '5'),
        (XOR_KEY ^ '4'),
        (XOR_KEY ^ '6'),
        (XOR_KEY ^ 'r'),
        (XOR_KEY ^ 't'),
        (XOR_KEY ^ 'y'),
        (XOR_KEY ^ '8'),
        (XOR_KEY ^ '7'),
        (XOR_KEY ^ '9'),
        (XOR_KEY ^ 'u'),
        (XOR_KEY ^ 'i'),
        (XOR_KEY ^ 'o'),
        (XOR_KEY ^ 'a'),
        (XOR_KEY ^ 's'),
        (XOR_KEY ^ 'd'),
        (XOR_KEY ^ '8'),
        (XOR_KEY ^ '5'),
        (XOR_KEY ^ '2'),
        (XOR_KEY ^ 'f'),
        (XOR_KEY ^ 'g'),
        (XOR_KEY ^ 'h'),
        (XOR_KEY ^ '7'),
        (XOR_KEY ^ '4'),
        (XOR_KEY ^ '1'),
        (XOR_KEY ^ 'm'),
        (XOR_KEY ^ 'n'),
        (XOR_KEY ^ '\0')};
    xorString(str, XOR_KEY);
    static unsigned char result[33];
    memcpy(result, str, 33);
    
    return [NSString stringWithFormat:@"%s",result];
    
}

///生成八位随机字符串
+ (NSString *)shuffledAlphabet{
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSUInteger j = (arc4random_uniform((float)numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    
    // Turn the result back into a string   参数length：指定 随机 个数
    NSString *result = [NSString stringWithCharacters:characters length:8];
    free(characters);
    return result;
}






@end
