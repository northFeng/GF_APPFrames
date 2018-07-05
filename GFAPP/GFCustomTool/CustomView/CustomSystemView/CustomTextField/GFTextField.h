//
//  GFTextField.h
//  GFAPP
//
//  Created by XinKun on 2018/1/3.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFTextField : UITextField

///限制文字输入长度（汉语两个字节为一个汉字，英文一个单词为一个一字节）
@property (nonatomic,assign) NSInteger limitStringLength;


///设置占位文字的颜色
- (void)setPlaceholderTextColor:(UIColor *)placeholderColor;

///设置清楚按钮的图片
- (void)setCleatBtnImageWith:(UIImage *)image;

///密码输入 (前提必须先设置 limitStringLength 属性)
- (void)switchToPasswordStyleWithBorderColor:(UIColor *)borderColor;

@end
