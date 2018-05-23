//
//  MBProgressHUDTool.h
//  GFAPP
//  第三方提示图
//  Created by gaoyafeng on 2018/5/23.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBProgressHUDTool : NSObject

SingletonIterface(MBProgressHUDTool)

/**
 *  显示提示文字,显示完毕，自动消失
 *
 *  @param message 提示文字
 */
- (void)showTextToastView:(NSString *)message view:(UIView *)view;
- (void)showTextToastView:(NSString *)message afterDelay:(NSTimeInterval)delay view:(UIView *)view;
- (void)showTextToastView:(NSString *)message superView:(UIView *)superView afterDelay:(NSTimeInterval)delay;

- (void)showLoadingAnimation:(UIView *)view;
- (void)hiddenLoadingAnimation;

///显示动画 (在这个方法后，记得把导航条放到最上层，每次都得调用！)
- (void)showLoadingAnimationImage:(UIView *)view;

@end
