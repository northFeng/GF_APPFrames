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

///加密
+ (NSString *)AES256Encrypt:(NSString *)message WithKeyString:(NSString *)key
{
    //    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decry = [self AES256Encrypt:[message dataUsingEncoding:NSUTF8StringEncoding] WithKey:key];
    NSString *descryStr = [self base64EncodedStringWithWrapWidth:0 data:decry];//[[NSString alloc] initWithData:decry encoding:NSUTF8StringEncoding];
    return descryStr;
}



+ (NSData *)AES256Encrypt:(NSData *)data WithKey:(NSString *)key
{//加密
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + 100;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
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

//base64编码
+ (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth data:(NSData *)data
{
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    long long inputLength = [data length];
    const unsigned char *inputBytes = [data bytes];
    
    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    
    long long i;
    long long outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    //truncate data to match actual output length
    outputBytes = realloc(outputBytes, outputLength);
    NSString *result = [[NSString alloc] initWithBytesNoCopy:outputBytes length:outputLength encoding:NSASCIIStringEncoding freeWhenDone:YES];
    
#if !__has_feature(objc_arc)
    [result autorelease];
#endif
    
    return (outputLength >= 4)? result: nil;
}



///解密
+ (NSString *)AES256Decrypt:(NSString *)base64EncodedString WithKeyString:(NSString *)key
{
    if(base64EncodedString){
        NSData *encryptedData =  [[NSData alloc]
                                  initWithBase64EncodedString:base64EncodedString options:0];
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
    size_t bufferSize = dataLength + 100;
    void *buffer = malloc(bufferSize);
    //    size_t numBytesEncrypted = 0;
    
    //同理，解密中，密钥也是32位的
    //    const void *keyPtr2 = [key bytes];
    //    char (*keyPtr)[32] = keyPtr2;
    //
    //    //对于块加密算法，输出大小总是等于或小于输入大小加上一个块的大小
    //    //所以在下边需要再加上一个块的大小
    //    NSUInteger dataLength = [self length];
    //    size_t bufferSize = dataLength + 32;
    //    void *buffer = malloc(bufferSize);
    //
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding/*这里就是刚才说到的PKCS7Padding填充了*/ | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,/* 初始化向量(可选) */
                                          [data bytes], dataLength,/* 输入 */
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
