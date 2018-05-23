//
//  MBProgressHUDTool.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/23.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "MBProgressHUDTool.h"

#import "MBProgressHUD.h"

@interface MBProgressHUDTool()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation MBProgressHUDTool

SingletonImplementation(MBProgressHUDTool)

#pragma mark - toast相关

- (void)showLoadingAnimation:(UIView *)view {
    if (self.hud) {
        [self.hud hideAnimated:YES];
    }
    
    if (!view) {
        view = [self getCurrentVC].view;
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.hud.contentColor = [UIColor whiteColor];
}

- (void)hiddenLoadingAnimation {
    [self.hud hideAnimated:YES];
}

- (void)showTextToastView:(NSString *)message view:(UIView *)view {
    //默认1秒
    [self showTextToastView:message afterDelay:2.0f view:view];
}

- (void)showTextToastView:(NSString *)message afterDelay:(NSTimeInterval)delay view:(UIView *)view {
    [self showTextToastView:message superView:view afterDelay:delay];
}

- (void)showTextToastView:(NSString *)message superView:(UIView *)superView afterDelay:(NSTimeInterval)delay {
    if ([message isEqual:[NSNull null]] || message == nil) {
        return;
    }
    if (self.hud) {
        [self.hud hideAnimated:YES];
    }
    if (!superView) {
        superView = [self getCurrentVC].view;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    self.hud.detailsLabel.text = message;
    self.hud.contentColor = [UIColor whiteColor];
    
    [self.hud hideAnimated:YES afterDelay:delay];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
        if ([result isKindOfClass:[UITabBarController class]]) {
            result = ((UITabBarController *)result).selectedViewController;
            if ([result isKindOfClass:[UINavigationController class]]) {
                result = ((UINavigationController *)result).topViewController;
            }
        }
    }
    else
        result = window.rootViewController;
    
    return result;
}


#pragma mark - 显示动画 (在这个方法后，记得把导航条放到最上层，每次都得调用！)
- (void)showLoadingAnimationImage:(UIView *)view{
    
    if (self.hud.superview) {
        [self.hud hideAnimated:YES];
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.hud.contentColor = [UIColor whiteColor];
    self.hud.frame = CGRectMake(0, APP_NaviBarHeight, CGRectGetWidth(view.frame), CGRectGetMaxY(view.frame) - APP_NaviBarHeight);
    
    UIImageView *gifImageView = [[UIImageView alloc] init];
    
    NSMutableArray * imageArr = [NSMutableArray array];
    
    for(int i=1;i<=23;i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d.png",i]];
        [imageArr addObject:image];
    }
    
    ///设置动画frame
    gifImageView.frame = CGRectMake(0, 0, ((UIImage *)imageArr.firstObject).size.width, ((UIImage *)imageArr.firstObject).size.width);
    gifImageView.animationImages = imageArr;
    // 设置播放周期时间
    gifImageView.animationDuration = 2;
    // 设置播放次数
    gifImageView.animationRepeatCount = 0;
    // 播放动画
    [gifImageView startAnimating];
    
    
    gifImageView.contentMode = UIViewContentModeCenter;
    
    self.hud.backgroundView.backgroundColor = [UIColor clearColor];
    self.hud.backgroundColor = [UIColor clearColor];
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    //
    ////    UIView * customView = [UIView new];
    self.hud.customView = gifImageView;
}





@end
