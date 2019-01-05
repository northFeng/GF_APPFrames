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

#pragma mark - 判断APP是否安装
///判断APP是否安装 appType: 0微信   1QQ  2微博
+ (BOOL)appIsOpenWithAppType:(NSInteger)appType;

#pragma mark - 数组与字符串之间的转换
///字符串转换对应的对象（数组/字典）
+ (id)jsonStringConversionToObject:(NSString *)jsonString;

///对象转换成字符串
+ (NSString *)jsonObjectConversionToString:(id)jsonObject;

#pragma mark - array数组操作方法
///数组的升序
+ (void)array_ascendingSortWithMutableArray:(NSMutableArray *)oldArray;

///数组降序
+ (void)array_descendingSortWithMutableArray:(NSMutableArray *)oldArray;

#pragma mark - base64编码
///编码字符串--->base64字符串
+ (NSString *)base64_encodeBase64StringWithString:(NSString *)encodeStr;

///编码字符串--->base64data
+ (NSString *)base64_encodeBase64StringWithData:(NSData *)encodeData;

///解码----->原字符串
+ (NSString *)base64_decodeBase64StringWithBase64String:(NSString *)base64Str;

///解码----->原Data
+ (NSData *)base64_decodeBase64DataWithBase64Data:(NSData *)base64Data;

#pragma mark - d时间操作
///获取当前时间@"YYYY-MM-dd HH:mm
+ (NSString *)date_getCurrentDateWithType:(NSString *)timeType;

///时间戳转换时间 timeStamp:时间戳（记得转化精度为秒） timeType:转换格式(@"YYYY-MM-dd  HH:mm:ss" / YYYY年MM月dd日)
+ (NSString *)date_getDateWithTimeStamp:(NSInteger)timeStamp timeType:(NSString *)timeType;

///获取当前时间戳 && 精度1000毫秒 1000000微妙
+ (NSInteger)date_getNowTimeStampWithPrecision:(NSInteger)precision;

///把日期数字换换成 年月日
+ (NSString *)date_getTimeString:(NSString *)timeString;

///把日期数字换换成 年月日 不带 ——
+ (NSString *)date_getTimeStringTwo:(NSString *)timeString;

///指定年月——>到现在的年月
+ (NSMutableArray *)date_getDateArrayToNowWithYear:(NSInteger)startYear startMonth:(NSInteger)startMonth;

#pragma mark - 字体操作
///设置字体
+ (UIFont *)font_setFontWithPingFangSC:(NSString *)fontName size:(NSInteger)size;

#pragma mark - 加载图片 && GIF
///加载图片
+ (void)img_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholderImgName imgView:(UIImageView *)imgView;

///加载动画
+ (void)img_setImageWithGifName:(NSString *)gifName imgView:(UIImageView *)imgView;

///加载 Bundle 中图片的三种方法
+ (UIImage *)img_loadFormBundleWithImagePath:(NSString *)path imgType:(NSString *)imgType;


#pragma mark - s字符串操作

///获取富文本文字
+ (NSAttributedString *)string_getAttributeStringWithString:(NSString *)text textFont:(UIFont *)font textColor:(UIColor *)color;

///数据字符串处理
+ (NSString *)string_handleNull:(NSString *)string;

///获取文字的高度
+ (CGFloat)string_getTextHeight:(NSString *)text textFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textWidth:(CGFloat)textWidth;

///获取文字的宽度
+ (CGFloat)string_getTextWidth:(NSString *)text textFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textHeight:(CGFloat)textHeigh;

/**
 获取指定的属性字符串(标准型！)
 param:font --字体大小
 param:lineHeight -- 行高
 textWeight: 0，标准字体 1:粗体
 */
+ (NSMutableAttributedString *)string_getAttributedStringWithString:(NSString *)textString textFont:(CGFloat)font textLineHeight:(CGFloat)lineHeight textWight:(NSInteger)textWeight;

///获取文字段内指定文字所有的范围集合
+ (NSArray *)string_getSameStringRangeArray:(NSString *)superString andAppointString:(NSString *)searchString;

///合并富文本字符串
+ (NSAttributedString *)string_getMergeAttributedStringWithHeadString:(NSString *)headString headStringFont:(UIFont *)headFont headStringColor:(UIColor *)headColor endString:(NSString *)endString endStringFont:(UIFont *)endFont endStringColor:(UIColor *)endColor;

///合并富文本字符 —— 特殊文字在中间
+ (NSAttributedString *)string_getMergeAttributedStringWithHeadString:(NSString *)headString headStringFont:(UIFont *)headFont headStringColor:(UIColor *)headColor middleString:(NSString *)middleStr middleStrFont:(UIFont *)middleFont middleStrColor:(UIColor *)middleColor endString:(NSString *)endString endStringFont:(UIFont *)endFont endStringColor:(UIColor *)endColor;

///合并富文本字符 —— 特殊文字在中间
+ (NSAttributedString *)string_getMergeAttributedStringWithHeadString:(NSString *)headString headStringFont:(UIFont *)headFont headStringColor:(UIColor *)headColor middleString:(NSString *)middleStr middleStrFont:(UIFont *)middleFont middleStrColor:(UIColor *)middleColor endString:(NSString *)endString endStringFont:(UIFont *)endFont endStringColor:(UIColor *)endColor lineSpace:(CGFloat)lineSpace;

///获取唯一标识符字符串
+ (NSString *)string_getUUIDString;

///把字符串 以中间空格拆分 得到 数组
+ (NSArray *)string_getArrayWithNoSpaceString:(NSString *)string;

///获取去除字符串的首位空格
+ (NSString *)string_getStringWithRemoveFrontAndRearSpacesByString:(NSString *)oldString;

///去除字符串的标点符号
+ (NSString *)string_getStringFilterPunctuationByString:(NSString *)string;

///判断字符串是否含有表情符号
+ (BOOL)string_getStringIsOrNotContainEmojiByString:(NSString *)string;

///去除字符串中的表情符号
+ (NSString *)string_getStringFilterEmojiByString:(NSString *)string;

///处理高亮文字
+ (NSMutableAttributedString *)string_getHighLigntText:(NSString *)hightText hightFont:(NSInteger)hifhtFont hightColor:(UIColor *)hightColor hightTextIsBlod:(BOOL)isHightBlod totalStirng:(NSString *)totalStirng defaultFont:(NSInteger)defaultFont defaultColor:(UIColor *)defaultColor defaultTextIsBlod:(BOOL)defaultIsBlod;

/**
 *  @brief 获取图片附件富文本
 *
 *  @param mutableString 需要拼接的富文本字符串
 *  @param image 转换富文本的图片
 *  @param imgRect 图片的rect
 *  @param index 图片要插入的富文本字符串位置(-1为默认直接拼接后面)
 *  @return NSMutableAttributedString 返回拼接的富文本
 */
+ (NSMutableAttributedString *)string_getAttachmentStringWithString:(NSMutableAttributedString *)mutableString image:(UIImage *)image imageRect:(CGRect)imgRect index:(NSInteger)index;


///十六进制转10进制字符串
+ (NSString *)string_getStringFormHexString:(NSString *)hexString;

///10进制转16进制字符串
+ (NSString *)string_getHexStringFromString:(NSString *)string;


#pragma mark - 创建定时器 (定时器一定要在视图delloc之前手动释放！！)
+ (void)timer_createTimerToViewController:(UIViewController *)VCSelf selector:(SEL)aSelector;


#pragma mark - u判断URL是否有效
///判断url是否可链接成功
+ (BOOL)url_ValidateUrIsLinkSuccessForUrl:(NSString *)urlStr;

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
+ (BOOL)url_ValidationUrlForUrlString:(NSString *)string;

#pragma mark - v视图操作
///设置视图的圆角和边框线
+ (void)view_addBorderOnView:(UIView *)view borderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius;

///添加指定位置的圆角(使用前必须设置frame)
+ (void)view_addRoundedCornersOnView:(UIView *)view cornersPosition:(UIRectCorner)corners cornersWidth:(CGFloat)widthCorner;

///添加指定位置的圆角（参数frame为CGRectMake(0, 0, weidth, height)）宽和高必须是视图显示后的尺寸！！
+ (void)view_addRoundedCornersOnView:(UIView *)view viewFrame:(CGRect)frame cornersPosition:(UIRectCorner)corners cornersWidth:(CGFloat)widthCorner;

///添加阴影 offsetSize:阴影的偏移量  shadowColor:阴影的颜色  shadowAlpha:阴影透明度 (系统默认CGSizeMake(0, 3); //(0,0)时是四周都有阴影) (添加阴影的视图上面必须有图层！！否则无效果)
+ (void)view_addShadowOnView:(UIView *)view shadowOffset:(CGSize)offsetSize shadowColor:(UIColor *)shadowColor shadowAlpha:(CGFloat)shadowAlpha;

///创建label  参数weight为 0：不加粗  1:加粗
+ (UILabel *)view_createLabelWith:(NSString *)text font:(CGFloat)font textColor:(UIColor *)cgColor textAlignment:(NSTextAlignment)alignment textWight:(NSInteger)weight;

///创建button 参数：type 0:文字 1:图片
+ (UIButton *)view_createButtonWithType:(NSInteger)type title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor image:(NSString *)imgStr target:(id)target action:(SEL)action;

///给按钮添加富文本文字
+ (void)btn_addTitle:(NSString *)title textFont:(UIFont *)font textColor:(UIColor *)color forState:(UIControlState)state button:(UIButton *)button;

///父视图主动移除所有的子视图
+ (void)view_removeAllChildsViewFormSubView:(UIView *)subView;

///添加横向的混合颜色
+ (void)view_addHybridBackgroundColorWithColorOne:(UIColor *)colorOne andColorTwo:(UIColor *)colorTwo showOnView:(UIView *)onView;

///添加输入框
+ (UITextField *)view_createTextFieldWithPlaceholder:(NSString *)placeholderStr holderStrFont:(UIFont *)holderFont holderColor:(UIColor *)holderColor textFont:(UIFont *)textFont textColor:(UIColor *)textColor keyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType;

///创建无限按钮模式 spaceLeft:左边间距 spaceBetween:按钮中间间距 spaceRight:右边间距  spaceTB:按钮上下间距 spaceTop:上边间距 btnCount:按钮数量
+ (NSMutableArray *)view_createManyBtnViewWithSpaceLeft:(CGFloat)spaceLeft spaceBetween:(CGFloat)spaceBetween spaceRight:(CGFloat)spaceRight spacetopBottom:(CGFloat)spaceTB spaceTop:(CGFloat)spaceTop btnWidth:(CGFloat)btnWidth btnHeight:(CGFloat)btnHeight btnCount:(NSInteger)btnCount;

#pragma mark - 打电话
+ (void)tell_phoneWithNum:(NSString *)phoneNum;


#pragma mark - 接口请求
///post请求一个字典
+ (void)postRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(void(^)(BOOL result, id idObject))block;

///get请求一个字典
+ (void)getRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(void(^)(BOOL result, id idObject))block;


@end





/**
[一] NSCharacterSet是什么❓

1.1 先来看下面的例子：

需求： 有一个字符串:@"今天我们来学习NSCharacterSet我们快乐"，去除字符串中所有的@"今"、@"我"、@"s"。
【注意】s是小写
思考：如果是你怎么解决？
自己写。
用 NSCharacterSet。

1.1.2 用 NSCharacterSet,如下：

NSString *str = @"今天我们来学习NSCharacterSet我们快乐";
NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"我s今"];
NSArray *setArr = [str componentsSeparatedByCharactersInSet:characterSet];
NSString *resultStr1 = [setArr componentsJoinedByString:@""];
NSLog(@"拆分后的字符串数组------%@\n最终字符串------%@",setArr,resultStr1);
pp0001
总结： 至此，通过上面的两个方法，已经解决了需求的问题。通过自己写，结合用NSCharacterSet，可以推断出NSCharacterSet类似一个字符串处理工具类，而事实上，由名字也可以看出，它确实是！

[二] NSCharacterSet的常用API学习

// 001 根据一个给定的字符串获取一个NSCharacterSet对象
+ (NSCharacterSet *)characterSetWithCharactersInString:(NSString *)aString;

// 使用实例，如上例！！
// 002 相反字符串限制 【具体见接下的例子】
@property (readonly, copy) NSCharacterSet *invertedSet;
// 003 常用快捷方法集合 （常用的，已满足大多数需求）
+ controlCharacterSet
+ whitespaceCharacterSet              //空格
+ whitespaceAndNewlineCharacterSet    //空格和换行符
+ decimalDigitCharacterSet            //0-9的数字
+ letterCharacterSet                  //所有字母
+ lowercaseLetterCharacterSet         //小写字母
+ uppercaseLetterCharacterSet         //大写字母
+ alphanumericCharacterSet            //所有数字和字母（大小写不分）
+ punctuationCharacterSet             //标点符号
+ newlineCharacterSet                 //换行

002 的 例子

NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
NSString *str = @"7sjf78sf990s";
NSLog(@"set----%@",[str componentsSeparatedByCharactersInSet:set]);

NSCharacterSet *invertedSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
NSLog(@"invertedSet----%@",[str componentsSeparatedByCharactersInSet:invertedSet]);

//打印结果如下图：  【可以看出invertedSet后，刚好判断条件相反】
pp0001
明白了001和002，下面有个需求，该怎么实现？自己想吧！
需求：textFielf只能输入数字
[三] NSMutableCharacterSet的常用API学习

NSCharacterSet的，NSMutableCharacterSet都可以用。【这句貌似有些多余】。
// 工能同 invertedSet 方法一样，注意这个没有返回值
- (void)invert;

附 textFielf只能输入数字的答案,如下
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    if ([string isEqualToString:filteredStr]) {
        return YES;
    }
    return NO;
}

*/


#pragma mark - 循环创建数组进行添加

/**
 
if (dicData && kObjectEntity(dicData)) {
    
    NSArray *arrayModel = dicData[@"orderList"];
    
    NSMutableArray *arrayMutable = [superVC.arrayDataList lastObject];
    
    for (NSDictionary *dicModel in arrayModel) {
        
        FSOrderListModel *model = [FSOrderListModel yy_modelWithJSON:dicModel];
        
        if (kObjectEntity(model)) {
            model.orderDate = [FSFunctionMethod date_getDateWithTimeStamp:[model.createTime integerValue]/1000 timeType:@"YYYY年MM月dd日"];
            
            FSOrderListModel *upModel = [arrayMutable lastObject];
            
            if (kObjectEntity(upModel)) {
                if (![upModel.orderDate isEqualToString:model.orderDate]) {
                    //日期不同
                    arrayMutable = [NSMutableArray array];//开辟新的数组
                    [arrayDate gf_addObject:[model.orderDate copy]];//添加日期
                    [superVC.arrayDataList gf_addObject:arrayMutable];
                }
                
            }else{
                //arrayMutable为空
                arrayMutable = [NSMutableArray array];//开辟新的数组
                [arrayDate gf_addObject:[model.orderDate copy]];//添加日期
                [superVC.arrayDataList gf_addObject:arrayMutable];
            }
            
            [FSOrderCell getCellHeightWIthModel:model];
            
            [arrayMutable gf_addObject:model];
        }
        
    }
    
    [superVC.arrayDataList addObject:arrayMutable];

    */
