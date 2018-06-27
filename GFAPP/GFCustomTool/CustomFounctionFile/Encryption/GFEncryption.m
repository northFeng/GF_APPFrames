//
//  GFEncryption.m
//  GFAPP
//
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFEncryption.h"

#import "NSString+Hash.h"//哈希散列算法
#import "NSString+AES256.h"//AES256
#import "DES3Util.h"//3DES
#import "RSA.h"//RSA

/**
 -----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----
 */
static NSString const *pubkey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCiPnQfr7dbcLdvs+fKiuEuB2AaoIz/nEfO0E6BARatyg8MENBPY4SLSX4+njBoOhpfOoJlcDgcZSM1rB2Jr0NzLelDPfat+SVeTUMiBFPOfo668Xik3jWOPzq71yueSyVCYlKtj3JVcgl9wnWQ5zT6arQFL5aHOatBNhQIEVeZaQIDAQAB";

/**
 -----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END PRIVATE KEY-----
 */
static NSString const *privkey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKI+dB+vt1twt2+z58qK4S4HYBqgjP+cR87QToEBFq3KDwwQ0E9jhItJfj6eMGg6Gl86gmVwOBxlIzWsHYmvQ3Mt6UM99q35JV5NQyIEU85+jrrxeKTeNY4/OrvXK55LJUJiUq2PclVyCX3CdZDnNPpqtAUvloc5q0E2FAgRV5lpAgMBAAECgYABPYL7vwciztDILNLnzHn+NRY5/eI2DgbKgPMor05yE6pbyEEfaj5YJj6t0d3C3jbXZYYbqmjzZp6HSYKMS+ezFY9QjDXaJDYddcPieRvKgJd/H/JfUgiH83HIh2lCT8Pkly09smX8jdhUgv82K74hrZnOAfCRFyyZ3VV053qhAQJBAOxVaZYjEgUKi4UDTVRIEBuqjFgmNQBZJmLill46W6KyJf1nNwf6Ck1iFoAlitPnUI4BjJOg2xaB2fDc6zWKJ8kCQQCvvrepqo0aTAuP3ZntvUB9dndxNjJXjLN/e2rdtqO7QFehz+9N5CJZ2tRw8/ZCKKh3RtrY+8noC78xH3xxwfShAkEAzIJ9BDcE+OfPJCNfX3ecuNQ07nLhmpOK7Dc3+AJ4GaofxdDzhiuRjrU601mpcQXSZ5BfncCs1iU3+36w63vKQQJAHmjVxtnoCIDYD1C87dItcogpKsHB/DwwYwKr/yk3M5NylmEwez3aY8nlsJXGKrR2Ug1EmP8YdLpznsBf/B8fgQJBAI+2urTtm5aLd523kUlsX47932FT07yUIVLjNjJxdmHP8tL0XhqIraijamkCsBvrYfYrUBNbn3eLD2fIvTql1xs=";

/**
 #define rsaPrivateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKI+dB+vt1twt2+z58qK4S4HYBqgjP+cR87QToEBFq3KDwwQ0E9jhItJfj6eMGg6Gl86gmVwOBxlIzWsHYmvQ3Mt6UM99q35JV5NQyIEU85+jrrxeKTeNY4/OrvXK55LJUJiUq2PclVyCX3CdZDnNPpqtAUvloc5q0E2FAgRV5lpAgMBAAECgYABPYL7vwciztDILNLnzHn+NRY5/eI2DgbKgPMor05yE6pbyEEfaj5YJj6t0d3C3jbXZYYbqmjzZp6HSYKMS+ezFY9QjDXaJDYddcPieRvKgJd/H/JfUgiH83HIh2lCT8Pkly09smX8jdhUgv82K74hrZnOAfCRFyyZ3VV053qhAQJBAOxVaZYjEgUKi4UDTVRIEBuqjFgmNQBZJmLill46W6KyJf1nNwf6Ck1iFoAlitPnUI4BjJOg2xaB2fDc6zWKJ8kCQQCvvrepqo0aTAuP3ZntvUB9dndxNjJXjLN/e2rdtqO7QFehz+9N5CJZ2tRw8/ZCKKh3RtrY+8noC78xH3xxwfShAkEAzIJ9BDcE+OfPJCNfX3ecuNQ07nLhmpOK7Dc3+AJ4GaofxdDzhiuRjrU601mpcQXSZ5BfncCs1iU3+36w63vKQQJAHmjVxtnoCIDYD1C87dItcogpKsHB/DwwYwKr/yk3M5NylmEwez3aY8nlsJXGKrR2Ug1EmP8YdLpznsBf/B8fgQJBAI+2urTtm5aLd523kUlsX47932FT07yUIVLjNjJxdmHP8tL0XhqIraijamkCsBvrYfYrUBNbn3eLD2fIvTql1xs="
 // publicKeyStr
 #define rsaPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCiPnQfr7dbcLdvs+fKiuEuB2AaoIz/nEfO0E6BARatyg8MENBPY4SLSX4+njBoOhpfOoJlcDgcZSM1rB2Jr0NzLelDPfat+SVeTUMiBFPOfo668Xik3jWOPzq71yueSyVCYlKtj3JVcgl9wnWQ5zT6arQFL5aHOatBNhQIEVeZaQIDAQAB"
 
 */




//32位key
static NSString const *aesKey = @"asdfghjklqwertyuiopzxcvbnmqazxsw";

@implementation GFEncryption


#pragma mark - md5
//小写16位
+ (NSString *)md5LowercaseString_16:(NSString *)string{
    return [NSString MD5ForLower16Bate:string];
}

//大写16位
+ (NSString *)md5UppercaseString_16:(NSString *)string{
    return [NSString MD5ForUpper16Bate:string];
}

//小写32位
+ (NSString *)md5LowercaseString_32:(NSString *)string{
    return [NSString MD5ForLower32Bate:string];
}

//大写32位
+ (NSString *)md5UppercaseString_32:(NSString *)string{
    return [NSString MD5ForUpper32Bate:string];
}


#pragma mark - AES256加解密
//加密
+ (NSString *)AES256Encrypt:(NSString *)string{
    return [NSString AES256Encrypt:string WithKeyString:[aesKey copy]];
}

//解密
+ (NSString *)AES256Decrypt:(NSString *)string{
    return [NSString AES256Decrypt:string WithKeyString:[aesKey copy]];
}

#pragma mark - 3DES加解密
//3DES加密
+ (NSString *)DES3Encrypt:(NSString *)string{
    return [DES3Util encryptUseDES:string key:[aesKey copy]];
}

//3SES解密
+ (NSString *)DES3Decrypt:(NSString *)string{
    return [DES3Util decryptUseDES:string key:[aesKey copy]];
}


#pragma mark - RSA加解密
//RSA加密
+ (NSString *)RSAEncrypt:(id)params{
    return [RSA encryptString:params publicKey:[pubkey copy]];
}

//RSA解密
+ (NSString *)RSADecrypt:(NSString *)string{
    return [RSA decryptString:string privateKey:[privkey copy]];
}




@end
