//
//  GFDrawPicture.h
//  GFAPP
//  绘制（签名）
//  Created by gaoyafeng on 2018/7/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFDrawPicture : UIView

/** 线条宽度 */
@property (nonatomic,assign) CGFloat lineWidth;

/** 线条颜色(默认为黑色) */
@property (nonatomic,strong) UIColor *lineColor;


///退回一步
- (void)back;

///清空所有
- (void)clear;

///把当前绘制的图形生成图片
- (UIImage *)getImageFormCurrentView;


@end
