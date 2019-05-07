//
//  GFNumberConversion.h
//  GFAPP
//  进制转换
//  Created by gaoyafeng on 2019/5/7.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GFNumberConversion : NSObject

#pragma mark - 10进制 转 ————> 2进制 & 8进制 & 16进制
/**
 十进制转换为二进制
 
 @param decimal 十进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;

/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

#pragma mark - 2进制 & 8进制 & 16进制 转 ————> 10进制
/**
 二进制转换为十进制
 
 @param binary 二进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalByBinary:(NSString *)binary;

///十六进制转10进制
+ (NSInteger)getDecimalByHex:(NSString *)hex;

#pragma mark - 16进制 && 2进制 互转
/**
 二进制转换成十六进制
 
 @param binary 二进制数
 @return 十六进制数
 */
+ (NSString *)getHexByBinary:(NSString *)binary;

/**
 十六进制转换为二进制
 
 @param hex 十六进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByHex:(NSString *)hex;

@end

NS_ASSUME_NONNULL_END
