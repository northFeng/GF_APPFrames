//
//  GFLabel.h
//  GFAPP
//
//  Created by gaoyafeng on 2018/6/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GFLabel : UILabel


/** 自定义text */
@property (nonatomic,copy) NSString *gfText;

+ (instancetype)initLable;

/**
 *  @brief 创建一个label
 *
 *  @param text 显示文字
 *  @param font 字体大小
 *  @param color 文字颜色
 *  @param textAlignment 文字居中方式
 *  @return GFLbael
 */
+ (instancetype)initLableWithtext:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;




@end




/**
 *  @brief 对赋值text扩展，让空数据进行判断
 *
 */
@interface GFLabel (Text)

/**
 *  @brief 赋值text
 *
 *  @param text 数据字符串
 */
- (void)set_text:(NSString *)text;

/**
 *  @brief 赋值text
 *
 *  @param text 数据字符串
 *  @param nodataStr 数据为空，占位字符串
 */
- (void)set_text:(NSString *)text nodataStr:(NSString *)nodataStr;

/**
 *  @brief 赋值text
 *
 *  @param formatStr 格式字符串
 *  @param dataStr 数据为空
 */
- (void)set_placeholderText:(NSString *)formatStr withText:(NSString *)dataStr;

/**
 *  @brief 赋值text
 *
 *  @param formatStr 格式字符串
 *  @param dataStr 数据字符串
 *  @param nodataStr 数据为空时，占位字符串
 */
- (void)set_placeholderText:(NSString *)formatStr withText:(NSString *)dataStr nodataStr:(NSString *)nodataStr;




@end
