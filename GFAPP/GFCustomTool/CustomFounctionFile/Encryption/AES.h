//
//  AES.h
//  GFAPP
//  AES加解密
//  Created by gaoyafeng on 2018/5/30.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

//引入加密库
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface AES : NSObject

///AES128加密
+ (NSString *)AES128EncryptWithString:(NSString *)encryString withKeyStirng:(NSString *)keyStr;

///AES128解密
+ (NSString *)AES128DecryptWithString:(NSString *)encryString withKeyStirng:(NSString *)keyStr;

///AES256加密
+ (NSString *)AES256EncryptWithString:(NSString *)encryString withKeyStirng:(NSString *)keyStr;

///AES256解密
+ (NSString *)AES256DecryptWithString:(NSString *)encryString withKeyStirng:(NSString *)keyStr;



@end

/**
 需要注意的地方有几个：
 
 CCCrypt 第一个参数：kCCEncrypt：加密 ；kCCDecrypt：解密
 CCCrypt 第二个参数：区分AES加密与DES加密
 
 1、注意秘钥的长度！！！！！！！！
 key(密钥)的长度,char keyPtr[kCCKeySizeAES256+1];需要注意此处后台给你的key的长度,AES的key长度kCCKeySizeAES128 = 16, kCCKeySizeAES192 = 24, kCCKeySizeAES256 = 32,
 
 2、注意向量的长度
 向量的长度，char ivPtr[kCCBlockSizeAES128 + 1];一般就是16位，我自己认为没有再多的了
 
 3、填充模式！！！！ 对称加密和分组加密中的四种模式(ECB、CBC、CFB、OFB)
 最后一个非常要注意的点：iOS中填充模式没有[kCCOptionPKCS5Padding][1]模式，而如果后台跟安卓又都是kCCOptionPKCS5Padding的话，那iOS就可以在CCCrypt参数中用kCCOptionPKCS7Padding | kCCOptionECBMode(不写的话默认为CBC模式)来代替。
 结果出来就跟kCCOptionPKCS5Padding的一样：因为IV向量默认是16个0，
 而kCCOptionPKCS7Padding的填充模式又是不足补0，但是ECB加密模式是不需要向量的，
 所以在kCCOptionPKCS7Padding的基础上加了kCCOptionECBMode就跟kCCOptionPKCS5Padding的是缺几个字节就补充几个字节的几模式结果一样了😜
 如果不写kCCOptionECBMode，使用了默认的CBC模式，并且没有固定向量IV的话，每次的加密结果都会是不一样的，因为，CBC时需要向量的，所以每次会生成一个随机的向量，所以每次加密结果都不一样。
 
 kCCOptionPKCS7Padding | kCCOptionECBMode  模式不足补0 模式：ECB ，不用设置偏移量，设置NULL即可
 kCCOptionPKCS7Padding 模式：CBC ，必须设置偏移量
 
 4、四种填充模式简介
 1>首先应该明白AES是基于数据块的加密方式，也就是说，每次处理的数据是一块（16字节），当数据不是16字节的倍数时填充，这就是所谓的分组密码（区别于基于比特位的流密码），16字节是分组长度。
 
 2>分组加密的几种方式
 ECB：是一种基础的加密方式，密文被分割成分组长度相等的块（不足补齐），然后单独一个个加密，一个个输出组成密文。
 CBC：是一种循环模式，前一个分组的密文和当前分组的明文异或操作后再加密，这样做的目的是增强破解难度。
 CFB/OFB实际上是一种反馈模式，目的也是增强破解的难度。
 
 ECB和CBC的加密结果是不一样的，两者的模式不同，而且CBC会在第一个密码块运算时加入一个初始化向量。
 
 
 在出现错误时从以下几个方面进行检查
 key与IV长度问题
 填充模式问题kCCOptionPKCS5Padding，kCCOptionPKCS7Padding
 很多时候，后台的同事也不明白AES加密的具体情况，他们可能也只是从网络上找了一些方法来加密，所以，不用太指望别人跟你说他们模式等东西。最好的办法就是，给后台一个明文，让他们用他们的模式生成一个秘文，然后确定好KEY与IV之后，在自己的程序中修改参数最终确定是那种模式（当然，如果后台给你，把AES加密的各种模式都跟你说了，最好）
 PKCS7Padding跟PKCS5Padding的区别就在于数据填充方式，PKCS7Padding是缺几个字节就补几个字节的0，而PKCS5Padding是缺几个字节就补充几个字节的几，好比缺6个字节，就补充6个字节的6 ↩
 
 */

/**
 AES相比同类对称加密算法速度算是非常快，比如在有AES-NI的x86服务器至少能达到几百M/s的速度。安全性在可预见的未来是基本等同的，因为即使是128位也足够复杂无法被暴力破解。现在112位密码还在商业应用，而128位是112位的几万倍，所以在实务中用128位比较划算(稍节约资源)。
 
 AES256比128大概需要多花40%的时间，用于多出的4轮round key生成以及对应的SPN操作。另外，产生256-bit的密钥可能也需要比128位密钥多些开销，不过这部分开销应该可以忽略。
 安全程度自然是256比128安全，因为目前除了暴力破解，并没有十分有效的代数攻击方法。
 针对具体的AES-256或AES-128的软/硬件实现有特定的攻击方式，不好一概而论。
 
 AES128和AES256主要区别是密钥长度不同（分别是128bits,256bits)、加密处理轮数不同（分别是10轮，14轮），后者强度高于前者。当前AES是较为安全的公认的对称加密算法。
 加密密钥长度不同  加密轮数不同 128 是16byte密钥 10轮加密 // 256是32byte密钥  14轮加密 。AES256 安全程度更高
 
 现代密码学分为对称加密与非对称加密（公钥加密），代表算法分别有DES(现在发展为3DES）、AES与RSA等。非对称加密算法的资源消耗大于对称加密。一般是进行混合加密处理，例如使用RSA进行密钥分发、协商，使用AES进行业务数据的加解密。
 
 */
