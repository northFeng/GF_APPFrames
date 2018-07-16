//
//  UIView+GFExtension.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/7/16.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "UIView+GFExtension.h"

@implementation UIView (GFExtension)

/** frame */
- (void)setGf_Frame:(CGRect)gf_Frame{
    self.frame = gf_Frame;
}

- (CGRect)gf_Frame{
    CGRect temp = self.frame;
    return temp;
}

/** 坐标X */
- (void)setGf_X:(CGFloat)gf_X{
    CGRect temp = self.frame;
    temp.origin.x = gf_X;
    self.frame = temp;
}

- (CGFloat)gf_X{
    return self.frame.origin.x;
}

/** 坐标Y */
- (void)setGf_Y:(CGFloat)gf_Y{
    CGRect temp = self.frame;
    temp.origin.y = gf_Y;
    self.frame = temp;
}

- (CGFloat)gf_Y{
    return self.frame.origin.y;
}

/** 宽度 */
- (void)setGf_Width:(CGFloat)gf_Width{
    CGRect temp = self.frame;
    temp.size.height = gf_Width;
    self.frame = temp;
}

- (CGFloat)gf_Width{
    return self.frame.size.width;
}

/** 高度 */
- (void)setGf_Height:(CGFloat)gf_Height{
    CGRect temp = self.frame;
    temp.size.height = gf_Height;
    self.frame = temp;
}

- (CGFloat)gf_Height{
    return self.frame.size.height;
}

/** 中心 */
- (void)setGf_Center:(CGPoint)gf_Center{
    self.center = gf_Center;
}

- (CGPoint)gf_Center{
    return self.center;
}

/** 中心X */
- (void)setGf_CenterX:(CGFloat)gf_CenterX{
    CGPoint point = self.center;
    point.x = gf_CenterX;
    self.center = point;
}

- (CGFloat)gf_CenterX{
    return self.center.x;
}

/** 中心Y */
- (void)setGf_CenterY:(CGFloat)gf_CenterY{
    CGPoint point = self.center;
    point.y = gf_CenterY;
    self.center = point;
}

- (CGFloat)gf_CenterY{
    return self.center.y;
}

/** 最大X */
- (void)setGf_MaxX:(CGFloat)gf_MaxX{
    
}
- (CGFloat)gf_MaxX{
    return self.gf_X + self.gf_Width;
}

/** 最大Y */
- (void)setGf_MaxY:(CGFloat)gf_MaxY{
    
}
- (CGFloat)gf_MaxY{
    return self.gf_Y + self.gf_Height;
}





@end
