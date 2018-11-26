//
//  DES.h
//  GFAPP
//  DES加密（改变变量则可进行3DES加解密）
//  Created by gaoyafeng on 2018/11/23.
//  Copyright © 2018 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

NS_ASSUME_NONNULL_BEGIN

@interface DES : NSObject

///(任何数据都可————>转化成字符串 来进行加解密,如果有特殊符号那就先进行URL编码再进行加密)
///将数组转为json字符串,再将json字符串先url编码,然后des加密.     后台获取到该参数时,先des解密,在url解码.

//加密
+ (NSString *)EncryUseDES:(NSString *)string withKey:(NSString *)key;
//解密
+ (NSString *)DecryUseDES:(NSString *)string withKey:(NSString *)key;

//url编码
+ (NSString *)UrlValueEncode:(NSString *)str;
//url解码
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;


#pragma mark - 字符串 与 16进制字符串 转换
// 普通字符串转换为十六进制的字符串
+ (NSString *)hexStringFromString:(NSString *)string;


// 十六进制转换为普通字符串
+ (NSString *)stringFromHexString:(NSString *)hexString;


#pragma mark - data 与 16进制字符串 转换
//data转换为十六进制的string
+ (NSString *)hexStringFromData:(NSData *)myD;


///将十六进制字符串转换成NSData
+ (NSData *)convertHexStrToData:(NSString *)str;



#pragma mark - 数字 与 16进制 转换
///数字转十六进制字符串
+ (NSString *)stringWithHexNumber:(NSUInteger)hexNumber;


///十六进制字符串转数字
+ (NSInteger)numberWithHexString:(NSString *)hexString;



@end

NS_ASSUME_NONNULL_END

/**
Base64加密和DES加密、以及JAVA和iOS中DES加密统一性问题
Oct 6, 2016 | iOS |  阅读
前言

我们在项目中为了安全方面的考虑，通常情况下会选择一种加密方式对需要安全性的文本进行加密，而Base64加密和DES64加密是常用的加密算法。我记得我在前一个项目中使用的就是这两种加密算法的结合：Base64 ＋ DES加密。当然这需要移动端和后台服务器做一个统一。

1、Base64加解密

值得一提的是：apple提供了基础的Base64加解密算法。这样我们就可以直接使用方法去实现Base64加解密。先看一下apple都提供了哪些方法：

1
2
3
4
5
6
@interface NSData (NSDataBase64Encoding)
-(nullable instancetype)initWithBase64EncodedString:(NSString * )base64String options:(NSDataBase64DecodingOptions)options NS_AVAILABLE(10_9, 7_0);
-(NSString * )base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)options NS_AVAILABLE(10_9, 7_0);
-(nullable instancetype)initWithBase64EncodedData:(NSData * )base64Data options:(NSDataBase64DecodingOptions)options NS_AVAILABLE(10_9, 7_0);
-(NSData * )base64EncodedDataWithOptions:(NSDataBase64EncodingOptions)options NS_AVAILABLE(10_9, 7_0);
@end
我们先创建一个NSData，再去一条一条的分析以上的方法

1
NSData *data = [@"Base64 encoding string" dataUsingEncoding:NSUTF8StringEncoding];
（1）创建一个Data（从一个Base64编码字符串使用给出的设置创建一个Data）
1
NSData *dataFromBase64String = [[NSData alloc]initWithBase64EncodedString:base64String options:0];
(2)创建一个Base64编码字符串（从接受者内容创建）
1
NSString *base64String = [data base64EncodedStringWithOptions:0];
(3)创建一个Data（从一个Base64、UTF-8编码的Data创建）
1
NSData *base64AndUTFData = [base64Data initWithBase64EncodedData:base64Data options:0];
(4)创建一个Base64、UTF-8编码的Data（从接受者内容创建）
1
NSData *base64Data = [data base64EncodedDataWithOptions:0];
当然，我们最后也可以将Data转化成String类型。

1
NSString *base64Decoded = [[NSString alloc]initWithData:dataFromBase64String encoding:NSUTF8StringEncoding];
以上是Base64加解密方法。下面我们看看DES的加解密。

2、DES加解密

我们都知道安卓和后台可以使用统一的代码去解决这个问题，这也是java的优势之一吧。这里我会附一段java的代码。主要是为了下面说明java和iOS端实现中需要注意的地方（也是不同点）。
为了使说明更方便一些，我们先看一下java的DES加密方法：


// EDS加密
public static String Encrypt(String originalStr) {
    String result = null;
    byte[] tmpOriginalStr = null;
    try {
        if (!Tools.isEmpty(originalStr)) {
            tmpOriginalStr = originalStr.getBytes("utf-8");
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
            DESKeySpec dks = new DESKeySpec(KEY);
            SecretKey secretKey = keyFactory.generateSecret(dks);
            IvParameterSpec param = new IvParameterSpec(IV);
            Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secretKey,param);
            byte[] tmpEncypt = cipher.doFinal(tmpOriginalStr);
            if (tmpEncypt != null) {
                result = Base64.encodeToString(tmpEncypt,Base64.NO_WRAP);
            }
        }
    } catch (Exception e) {
        Log.e("Erro",e.getMessage());
    }
    return result;
}
}
我们可以看出Java针对DES加密算法默认使用的是CBC模式，对齐方式采用的是:PKCS5Padding。

而OC中的加密并不是java中的形式实现加密的，接下来我们看一看OC中实现DES加密的代码：


+(NSString *) encryptUseDES:(NSString *)plainText {
    NSString * ciphertext = nil;
    NSData * textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024 * 5];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          [iv UTF8String],
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64EncodedStringWithOptions:0];
    }
    return ciphertext;
}
先说一下代码中的key和iv 。key：是DES加密的公钥。而iv：是初始化的矢量。两者都是DES加密的关键参数。这个是必须要和Android、后台有个统一的。

我们可以看出OC使用的是kCCOptionPKCS7Padding对齐方式。而java中很明确的指出使用的是PKCS5Padding。接下来我们点进去看看OC中给出的对齐选择有哪些，我直接以代码的形式展示出来：


@constant   kCCOptionPKCS7Padding   Perform PKCS7 padding.
@constant   kCCOptionECBMode        Electronic Code Book Mode.
Default is CBC.
enum {
    //* options for block ciphers
    kCCOptionPKCS7Padding   = 0x0001,
    kCCOptionECBMode        = 0x0002
    //* stream ciphers currently have no options
};
OC中给出的是kCCOptionECBMode 和kCCOptionPKCS7Padding这两种选择。那么，问题现在出现了。java中的DES加密算法有很多种，例如：ECB，CBC，OFB，CFB等。

java 和 OC的DES加密怎样才能实现一致性呢？（这也是我在项目中遇到的问题）。

查阅很多资料，再加上自己的很多次测试，得出的结果如下：

在JAVA中使用这种方式加密：DES/CBC/PKCS5Padding 对应的Object-C的是 kCCOptionPKCS7Padding.
而使用DES/ECB/PKCS5Padding 对应的Object-C的是 kCCOptionPKCS7Padding | kCCOptionECBMod
觉得似乎OC目前只支持这两种方式的加密。当然结果是已经得到验证的。

注意：md5加密（iOS SDK中自带了CommonCrypto）出现警告⚠️ 。解决方法添加：引入函数定义的头文件 :#import <CommonCrypto/CommonDigest.h>

其他链接：

《Objective C与Java之间的DES加解密实现》

《iOS 7: Base64 Encode and Decode NSData and NSString Objects》

这里附上demo：https://github.com/Wheat-Qin/Base64-DES
 */
