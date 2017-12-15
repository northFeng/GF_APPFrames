//
//  GFCustomImgTextButton.m
//  GFAPP
//
//  Created by XinKun on 2017/11/14.
//  Copyright © 2017年 North_feng. All rights reserved.
//

/*
   1、按钮使用图片：系统按钮类型或者自定义按钮类型 都具有 按压渐变黑属性
   2、使用文字：系统按钮类型同样具有 按压渐变黑属性   自定义按钮则没有该属性
   3、图文一块使用：系统按钮具有 按压渐变黑属性  自定义则：按压时 图片渐变黑属性，但文字不具有该属性
   4、按钮上添加图片，则会
 */
#import "GFCustomImgTextButton.h"

@implementation GFCustomImgTextButton
{
    
    CGRect _imageRect;
    
    CGRect _textRect;
    
}


- (void)setImgFrame:(CGRect)imgRect titleFrame:(CGRect)titleRect textContentMode:(NSTextAlignment)textAlignment textFont:(CGFloat)font textColor:(UIColor *)textColor{
    
    _imageRect = imgRect;
    _textRect = titleRect;
    
    // 1.文字居中
    self.titleLabel.textAlignment = textAlignment;
    
    // 2.文字大小
    self.titleLabel.font = [UIFont systemFontOfSize:font];
    self.titleLabel.numberOfLines = 0;
    
    if (textColor) {
        [self setTitleColor:textColor forState:UIControlStateNormal];
    }else{
        //默认文字颜色
        [self setTitleColor:UIColorFromSameRGB(34) forState:UIControlStateNormal];
    }
    
    
    // 3.图片的内容模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //self.titleLabel.contentMode = UIViewContentModeCenter;
    
    // 4.设置选中时的背景 Highlighted：press按压状态
    //[self setBackgroundImage:[UIImage imageNamed:MCLocalizedImageName(@"bg_selected", nil)] forState:UIControlStateHighlighted];
    
    //设置填充rect
    [self imageRectForContentRect:_imageRect];
    [self titleRectForContentRect:_textRect];
}

#pragma mark 调整内部ImageView的frame
//重写图片内部方法
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return _imageRect;
}

#pragma mark 调整内部UILabel的frame
//重写文字内部方法
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return _textRect;
}



@end
