//
//  GFCustomImgTextButton.h
//  GFAPP
//  重写系统button的文字和图片布局
//  Created by XinKun on 2017/11/14.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFCustomImgTextButton : UIButton


/**
 *  设置按钮图片和文字的frame
 *
 *  @param imgRect 图片rect
 *  @param titleRect 标题rect
 */
- (void)setImgFrame:(CGRect)imgRect titleFrame:(CGRect)titleRect textContentMode:(NSTextAlignment)textAlignment textFont:(CGFloat)font textColor:(UIColor *)textColor;


@end


/**
 * 用法
 GFCustomImgTextButton *button = [GFCustomImgTextButton buttonWithType:1];
 button.backgroundColor = [UIColor whiteColor];
 [button setImage:ImageNamed(@"ic_1_2") forState:0];
 [button setTitle:@"返回" forState:0];
 
 CGRect imgRect = CGRectMake(25, 0, 50, 50);
 CGRect textRect = CGRectMake(0, 50, 100, 25);
 [button setImgFrame:imgRect titleFrame:textRect textContentMode:NSTextAlignmentCenter textFont:20 textColor:[UIColor grayColor]];
 
 button.frame = CGRectMake(100, 200, 100, 75);
 [self.view addSubview:button];

 */
