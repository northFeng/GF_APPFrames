//
//  GFLabel.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/6/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFLabel.h"

@implementation GFLabel


+ (instancetype)initLable{
    GFLabel *label = [[GFLabel alloc] init];
    return label;
}

+ (instancetype)initLableWithtext:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment {
    GFLabel *label = [self initLable];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    label.textAlignment = textAlignment;
    return label;
}


- (void)setGfText:(NSString *)gfText{
    
    [self set_text:gfText];
}

//文字描一圈黑边的效果:(重写系统方法)
- (void)drawTextInRect:(CGRect)rect{
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = [UIColor whiteColor];
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}
/** 文字描一圈黑边的效果:
---------------------
作者：H.A.N
来源：CSDN
原文：https://blog.csdn.net/u010960265/article/details/82977553
版权声明：本文为博主原创文章，转载请附上博文链接！
 */




@end



@implementation GFLabel (Text)


- (void)set_text:(NSString *)text{
    
    self.text = text.length > 0 ? text : @"";
}

- (void)set_text:(NSString *)text nodataStr:(NSString *)nodataStr{
    
    self.text = text.length > 0 ? text : nodataStr;
}

- (void)set_placeholderText:(NSString *)formatStr withText:(NSString *)dataStr{
    
    dataStr = dataStr.length > 0 ? dataStr : @"";
    self.text = [NSString stringWithFormat:formatStr,dataStr];
}

- (void)set_placeholderText:(NSString *)formatStr withText:(NSString *)dataStr nodataStr:(NSString *)nodataStr{
    dataStr = dataStr.length > 0 ? dataStr : nodataStr;
    self.text = [NSString stringWithFormat:formatStr,dataStr];
}


@end

