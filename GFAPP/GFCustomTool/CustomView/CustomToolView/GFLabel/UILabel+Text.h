//
//  UILabel+Text.h
//  GFAPP
//  赋值text
//  Created by gaoyafeng on 2018/6/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Text)


/**
 *  @brief 赋值text ——> 空数据
 *
 *  @param text 数据字符串
 */
- (void)set_text:(NSString *)text;

/**
 *  @brief 赋值text ——> 自定义空数据
 *
 *  @param text 数据字符串
 *  @param nodataStr 数据为空，占位字符串
 */
- (void)set_text:(NSString *)text nodataStr:(NSString *)nodataStr;

/**
 *  @brief 赋值text 格式字符串 + 空字符
 *
 *  @param formatStr 格式字符串
 *  @param dataStr 数据为空
 */
- (void)set_placeholderText:(NSString *)formatStr withText:(NSString *)dataStr;

/**
 *  @brief 赋值text 格式字符串 + 自定义空数据
 *
 *  @param formatStr 格式字符串
 *  @param dataStr 数据字符串
 *  @param nodataStr 数据为空时，占位字符串
 */
- (void)set_placeholderText:(NSString *)formatStr withText:(NSString *)dataStr nodataStr:(NSString *)nodataStr;



@end
