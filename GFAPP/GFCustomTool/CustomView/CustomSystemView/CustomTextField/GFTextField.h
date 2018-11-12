//
//  GFTextField.h
//  GFAPP
//
//  Created by XinKun on 2018/1/3.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  键盘输入类型
 */
typedef NS_ENUM(NSInteger,GFTFType) {
    /**
     *  默认输入框类型
     */
    GFTFType_Default = 0,
    /**
     *  密文
     */
    GFTFType_Cipher = 1,
    /**
     *  明文
     */
    GFTFType_Clear = 2
};

@interface GFTextField : UITextField

///限制文字输入长度（汉语两个字节为一个汉字，英文一个单词为一个一字节）
@property (nonatomic,assign) NSInteger limitStringLength;

/** 输入键盘密码显示类型 */
@property (nonatomic,readonly)  GFTFType textFieldType;

///是否为电话类型(默认为NO)
@property (nonatomic,assign) BOOL isPhoneType;


///设置占位文字的颜色
- (void)setPlaceholderTextColor:(UIColor *)placeholderColor;

///设置清楚按钮的图片
- (void)setCleatBtnImageWith:(UIImage *)image;


/**
 *  @brief 密码输入 (前提必须先设置 limitStringLength 属性)
 *
 *  @param borderColor 边框颜色 && 以及分割线颜色
 *  @param type 0:密文 1:明文
 */
- (void)switchToPasswordStyleWithBorderColor:(UIColor *)borderColor passwordType:(GFTFType)type;



@end



/** 用法
_tfFeng = [[GFTextField alloc] init];
_tfFeng.frame = CGRectMake(50, 200, 200, 50);
[self.view addSubview:_tfFeng];
_tfFeng.keyboardType = UIKeyboardTypeNumberPad;
_tfFeng.limitStringLength = 5;//调用类型之前必须设置字数限制
[_tfFeng switchToPasswordStyleWithBorderColor:[UIColor lightGrayColor] passwordType:GFTFType_Clear];
 //监测输入变化
 [self.tfPassword addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
 
 #pragma mark - 监测输入框
 - (void)textFiledEditChanged:(GFTextField *)textField{
     //实时监听获取输入内容，自带输入法中文拼音预输入，输入完整中文后再搜索
     //如果为nil的话就说明你现在没有未选中的字符，可以计算文字长度。否则此时计算出来的字符长度可能不正确。
     if (textField.markedTextRange == nil) {
 
 
     }
 }
 
 */

/** UITextView 的点击ruturn按钮键判断
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        //判断输入的字是否是回车，即按下return
        [_textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}
 
 */




