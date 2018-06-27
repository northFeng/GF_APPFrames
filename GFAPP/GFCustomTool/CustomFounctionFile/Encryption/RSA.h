//
//  RSA.h
//  GFAPP
//  RSA加密
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSA : NSObject

/**
 公钥加密最大长度：117
 私钥加密最大长度：245
 
 同一个字段进行RSA加密每次加密的结果都是不一样的！！！！但是解密都能解密出原文！
 
 */

//公钥加密
// return base64 encoded string
+ (NSString *)encryptString:(id)params publicKey:(NSString *)pubKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
//公钥加密，私钥解密
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;

//********************************** RSA  **********************************

//私钥签名
// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;
//公钥验证
// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;




@end


#pragma mark - 为什么要分段加密
/**
 rsa加解密的内容超长的问题解决
 2016年12月21日 11:35:57
 阅读数：7841
 一. 现象：
 有一段老代码用来加密的，但是在使用key A的时候，抛出了异常：javax.crypto.IllegalBlockSizeException: Data must not be longer than 117 bytes。老代码已经做了分段的加密，应该是已经考虑了加密长度的问题才对。换了另一个线上代码中的key B，正常加密没有异常。
 
 二. 解决：
 老代码如下：
 private static String encryptByPublicKey(String plainText, String publicKey) throws Exception {
 int MAX_ENCRYPT_BLOCK = 128;
 byte[] data = plainText.getBytes("utf-8");
 Key e = RSASignature.getPublicKey(publicKey);
 // 对数据加密
 Cipher cipher = Cipher.getInstance("RSA");
 cipher.init(Cipher.ENCRYPT_MODE, e);
 int inputLen = data.length;
 ByteArrayOutputStream out = new ByteArrayOutputStream();
 int offSet = 0;
 byte[] cache;
 int i = 0;
 // 对数据分段加密
 while (inputLen - offSet > 0) {
 if (inputLen - offSet > MAX_ENCRYPT_BLOCK) {
 cache = cipher.doFinal(data, offSet, MAX_ENCRYPT_BLOCK);
 } else {
 cache = cipher.doFinal(data, offSet, inputLen - offSet);
 }
 out.write(cache, 0, cache.length);
 i++;
 offSet = i * MAX_ENCRYPT_BLOCK;
 }
 byte[] encryptedData = out.toByteArray();
 out.close();
 return Base64.encodeBase64String(encryptedData);
 }
 将MAX_ENCRYPT_BLOCK值换为64就解决了问题。按报错提示的改为117也可以，不过为了凑整，选择了64。
 
 三. 原因：
 实际使用RSA加解密算法通常有两种不同的方式，一种是使用对称密钥（比如AES/DES等加解密方法）加密数据，然后使用非对称密钥（RSA加解密密钥）加密对称密钥；另一种是直接使用非对称密钥加密数据。第一种方式安全性高，复杂度也高，不存在加密数据长度限制问题，第二种方式安全性差一些，复杂度低，但是存在加密数据限制问题（即使用非对称密钥加密数据时，一次加密的数据长度是（密钥长度／8-11））。
 目前双方约定的方式为第二种方式，而对应于本次抛错的密钥，key长度为1024位，1024/8 - 11 = 117，所以一次加密内容不能超过117bytes。另一个密钥没有问题，因为key的长度为2048位，2048/8 - 11 = 245，一次加密内容不能超过245bytes。而分段加密代码中用128为单位分段，从而使得一个密钥报错，另一个不报错。
 
 四.扩展：
 为什么一次加密的数据长度为 （密钥长度／8-11） ？
 网上有说明文长度小于等于密钥长度（Bytes）-11，这说法本身不太准确，会给人感觉RSA 1024只能加密117字节长度明文。实际上，RSA算法本身要求加密内容也就是明文长度m必须0<m<n，也就是说内容这个大整数不能超过n，否则就出错。那么如果m=0是什么结果？普遍RSA加密器会直接返回全0结果。如果m>n，由于me ≡ c (mod n)，c为密文，m为明文，e和n组成公钥，显然当m>n时，m与m-n得出的密文一样，无法解密，运算就会出错。
 所以，RSA 1024实际可加密的明文长度最大也是1024bits，但问题就来了：
 如果小于这个长度怎么办？就需要进行padding，因为如果没有padding，用户无法确分解密后内容的真实长度，字符串之类的内容问题还不大，以0作为结束符，但对二进制数据就很难理解，因为不确定后面的0是内容还是内容结束符。
 只要用到padding，那么就要占用实际的明文长度，于是才有117字节的说法。我们一般使用的padding标准有NoPPadding、OAEPPadding、PKCS1Padding等，其中PKCS#1建议的padding就占用了11个字节。
 如果大于这个长度怎么办？很多算法的padding往往是在后边的，但PKCS的padding则是在前面的，此为有意设计，有意的把第一个字节置0以确保m的值小于n。
 这样，128字节（1024bits）-减去11字节正好是117字节，但对于RSA加密来讲，padding也是参与加密的，所以，依然按照1024bits去理解，但实际的明文只有117字节了。
 关于PKCS#1 padding规范可参考：RFC2313 chapter 8.1，我们在把明文送给RSA加密器前，要确认这个值是不是大于n，也就是如果接近n位长，那么需要先padding再分段加密。除非我们是“定长定量自己可控可理解”的加密不需要padding。
 为什么有不同长度的key？
 看一下密钥的生成过程：
 第一步，随机选择两个不相等的质数p和q。
 第二步，计算p和q的乘积n。n即密钥长度。
 第三步，计算n的欧拉函数φ(n)。
 第四步，随机选择一个整数e，条件是1< e < φ(n)，且e与φ(n) 互质。
 第五步，计算e对于φ(n)的模反元素d。
 第六步，将n和e封装成公钥，n和d封装成私钥。
 加密（c为密文，m为明文）：　　me ≡ c (mod n)
 解密（c为密文，m为明文）：　　cd ≡ m (mod n)
 对极大整数做因数分解（由n,e推出d）的难度决定了RSA算法的可靠性。换言之，对一极大整数做因数分解愈困难，RSA算法愈可靠。假如有人找到一种快速因数分解的算法，那么RSA的可靠性就会极度下降。但找到这样的算法的可能性是非常小的。今天只有短的RSA密钥才可能被暴力破解。只要密钥长度足够长，用RSA加密的信息实际上是不能被解破的。目前一般为1024 bit以上的密钥，推荐2048 bit以上。
 对称加密vs分对称加密？
 对称加密是最快速、最简单的一种加密方式，加密（encryption）与解密（decryption）用的是同样的密钥（secret key）。对称加密有很多种算法，由于它效率很高，所以被广泛使用在很多加密协议的核心当中。对称加密通常使用的是相对较小的密钥，一般小于256 bit。因为密钥越大，加密越强，但加密与解密的过程越慢。密钥的大小既要照顾到安全性，也要照顾到效率，是一个trade-off。对称加密的一大缺点是密钥的管理与分配。
 非对称加密为数据的加密与解密提供了一个非常安全的方法，它使用了一对密钥，公钥（public key）和私钥（private key）。私钥只能由一方安全保管，不能外泄，而公钥则可以发给任何请求它的人。非对称加密使用这对密钥中的一个进行加密，而解密则需要另一个密钥。虽然非对称加密很安全，但是和对称加密比起来，它非常的慢。
 将两者结合起来，将对称加密的密钥使用非对称加密的公钥进行加密，然后发送出去，接收方使用私钥进行解密得到对称加密的密钥，然后双方可以使用对称加密来进行沟通。
 
 五.结论：
 优先选择方案：使用对称密钥（比如AES/DES等加解密方法）加密数据，然后使用非对称密钥（RSA加解密密钥）加密对称密钥。原问题中由于双方约定了非对称加密的方式，所以用分段加密来解决了问题，但是可以知道这样是比较低效的。

 
 */
