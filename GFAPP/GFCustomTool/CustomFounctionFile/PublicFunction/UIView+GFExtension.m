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



/*
 * shadowColor 阴影颜色
 *
 * shadowOpacity 阴影透明度，默认0
 *
 * shadowRadius  阴影半径，默认3
 *
 * shadowPathSide 设置哪一侧的阴影，
 
 * shadowPathWidth 阴影的宽度，
 
 */
-(void)LX_SetShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(GFShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth{
    
    
    self.layer.masksToBounds = NO;
    
    self.layer.shadowColor = shadowColor.CGColor;
    
    self.layer.shadowOpacity = shadowOpacity;
    
    self.layer.shadowRadius =  shadowRadius;
    
    self.layer.shadowOffset = CGSizeZero;
    CGRect shadowRect;
    
    CGFloat originX = 0;
    
    CGFloat originY = 0;
    
    CGFloat originW = self.bounds.size.width;
    
    CGFloat originH = self.bounds.size.height;
    
    
    switch (shadowPathSide) {
        case GFShadowPathTop:
            shadowRect  = CGRectMake(originX, originY - shadowPathWidth/2, originW,  shadowPathWidth);
            break;
        case GFShadowPathBottom:
            shadowRect  = CGRectMake(originX, originH -shadowPathWidth/2, originW, shadowPathWidth);
            break;
            
        case GFShadowPathLeft:
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY, shadowPathWidth, originH);
            break;
            
        case GFShadowPathRight:
            shadowRect  = CGRectMake(originW - shadowPathWidth/2, originY, shadowPathWidth, originH);
            break;
        case GFShadowPathNoTop:
            shadowRect  = CGRectMake(originX -shadowPathWidth/2, originY +1, originW +shadowPathWidth,originH + shadowPathWidth/2 );
            break;
        case GFShadowPathAllSide:
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY - shadowPathWidth/2, originW +  shadowPathWidth, originH + shadowPathWidth);
            break;
            
    }
    
    UIBezierPath *path =[UIBezierPath bezierPathWithRect:shadowRect];
    
    self.layer.shadowPath = path.CGPath;
    
}


@end

