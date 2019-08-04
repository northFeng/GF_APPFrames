//
//  UIView+GFExtension.h
//  GFAPP
//  属性快速获取
//  Created by gaoyafeng on 2018/7/16.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    
    GFShadowPathLeft,
    
    GFShadowPathRight,
    
    GFShadowPathTop,
    
    GFShadowPathBottom,
    
    GFShadowPathNoTop,
    
    GFShadowPathAllSide
    
} GFShadowPathSide;


@interface UIView (GFExtension)

/** frame */
@property (nonatomic,assign) CGRect gf_Frame;

/** 坐标X */
@property (nonatomic,assign) CGFloat gf_X;

/** 坐标Y */
@property (nonatomic,assign) CGFloat gf_Y;

/** 宽度 */
@property (nonatomic,assign) CGFloat gf_Width;

/** 高度 */
@property (nonatomic,assign) CGFloat gf_Height;

/** 中心 */
@property (nonatomic,assign) CGPoint gf_Center;

/** 中心X */
@property (nonatomic,assign) CGFloat gf_CenterX;

/** 中心Y */
@property (nonatomic,assign) CGFloat gf_CenterY;

/** 最大X */
@property (nonatomic,assign) CGFloat gf_MaxX;

/** 最大Y */
@property (nonatomic,assign) CGFloat gf_MaxY;


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
-(void)LX_SetShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(GFShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth;

- (void)disableAWhile;
- (void)disableAWhile:(NSTimeInterval)time;

@end
