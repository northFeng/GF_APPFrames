//
//  GFFunctionMethod.h
//  GFAPP
//
//  Created by XinKun on 2017/11/28.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GFFunctionMethod : NSObject

#pragma mark - array数组操作方法
///数组的升序
- (void)array_ascendingSortWithMutableArray:(NSMutableArray *)oldArray;

///数组降序
- (void)array_descendingSortWithMutableArray:(NSMutableArray *)oldArray;

#pragma mark - base64编码
///编码字符串--->base64字符串
- (NSString *)base64_encodeBase64StringWithString:(NSString *)encodeStr;

///编码字符串--->base64data
- (NSString *)base64_encodeBase64StringWithData:(NSData *)encodeData;

///解码----->原字符串
- (NSString *)base64_decodeBase64StringWithBase64String:(NSString *)base64Str;

///解码----->原Data
- (NSData *)base64_decodeBase64DataWithBase64Data:(NSData *)base64Data;

#pragma mark - d时间操作
///获取当前时间@"YYYY-MM-dd HH:mm
- (NSString *)date_getCurrentDateWithType:(NSString *)timeType;

///把日期数字换换成 年月日
- (NSString *)date_getTimeString:(NSString *)timeString;

///把日期数字换换成 年月日 不带 ——
- (NSString *)date_getTimeStringTwo:(NSString *)timeString;


#pragma mark - s字符串操作
///获取文字的高度
- (CGFloat)string_getTextHeight:(NSString *)text textFont:(CGFloat)font lineSpacing:(CGFloat)lineSpace textWidth:(CGFloat)textWidth;

///获取文字的宽度
- (CGFloat)string_getTextWidth:(NSString *)text textFont:(CGFloat)font lineSpacing:(CGFloat)lineSpace textHeight:(CGFloat)textHeigh;

/**
 获取指定的属性字符串(标准型！)
 param:font --字体大小
 param:lineHeight -- 行高
 textWeight: 0，标准字体 1:粗体
 */
- (NSMutableAttributedString *)string_getAttributedStringWithString:(NSString *)textString textFont:(CGFloat)font textLineHeight:(CGFloat)lineHeight textWight:(NSInteger)textWeight;

///获取文字段内指定文字所有的范围集合
- (NSArray *)string_getSameStringRangeArray:(NSString *)superString andAppointString:(NSString *)searchString;

///获取价格
- (NSMutableAttributedString *)string_getPriceAttributedString:(NSString *)price oneSize:(CGFloat)oneSize twoSize:(CGFloat)twoSize textColor:(UIColor *)textColor;

///获取唯一标识符字符串
- (NSString *)string_getUUIDString;

///把字符串 以中间空格拆分 得到 数组
- (NSArray *)string_getArrayWithNoSpaceString:(NSString *)string;

///获取去除字符串的首位空格
- (NSString *)string_getStringWithRemoveFrontAndRearSpacesByString:(NSString *)oldString;

///去除字符串的标点符号
- (NSString *)string_getStringFilterPunctuationByString:(NSString *)string;

///判断字符串是否含有表情符号
- (BOOL)string_getStringIsOrNotContainEmojiByString:(NSString *)string;

///去除字符串中的表情符号
- (NSString *)string_getStringFilterEmojiByString:(NSString *)string;

///处理高亮文字
- (NSMutableAttributedString *)string_getHighLigntText:(NSString *)hightText hightFont:(NSInteger)hifhtFont hightColor:(UIColor *)hightColor hightTextIsBlod:(BOOL)isHightBlod totalStirng:(NSString *)totalStirng defaultFont:(NSInteger)defaultFont defaultColor:(UIColor *)defaultColor defaultTextIsBlod:(BOOL)defaultIsBlod;

#pragma mark - 创建定时器
- (void)timer_createTimerToViewController:(UIViewController *)VCSelf selector:(SEL)aSelector;


#pragma mark - u判断URL是否有效
///判断url是否可链接成功
- (BOOL)url_ValidateUrIsLinkSuccessForUrl:(NSString *)urlStr;

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
- (BOOL)url_ValidationUrlForUrlString:(NSString *)string;

#pragma mark - v视图操作
///设置视图的圆角和边框线
- (void)view_addBorderOnView:(UIView *)view borderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius;

///创建label  参数weight为 0：不加粗  1:加粗
- (UILabel *)view_createLabelWith:(NSString *)text font:(CGFloat)font textColor:(CGColorRef)cgColor textAlignment:(NSTextAlignment)alignment textWight:(NSInteger)weight;

///父视图主动移除所有的子视图
- (void)view_removeAllChildsViewFormSubView:(UIView *)subView;



@end
