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
 
 */



