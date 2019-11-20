//
//  APPBaseController+ScreenRotation.m
//  CleverBaby
//
//  Created by 峰 on 2019/11/5.
//  Copyright © 2019 小神童. All rights reserved.
//

#import "APPBaseController+ScreenRotation.h"

#import "AppDelegate.h"

@implementation APPBaseController (ScreenRotation)


- (void)setAllowScreenRotate:(BOOL)allowScreenRotate{
    
    if (allowScreenRotate) {
        ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotate = YES;
    }else{
        ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotate = NO;
    }
}

- (BOOL)allowScreenRotate{
    
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotate;
}

#pragma mark - ************************* 屏幕旋转设置 *************************
//设置屏幕是否旋转
- (BOOL)shouldAutorotate{
    
    return YES;
}

///VC支持的旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;//上+左+右
}

///使得特定ViewController坚持特定的interfaceOrientation
/**
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
 */


#pragma mark - ************************* 代码强制控制屏幕方向 *************************
//设置屏幕向左翻转
- (void)setScreenInterfaceOrientationLeft{
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
//设置屏幕向右翻转
- (void)setScreenInterfaceOrientationRight{
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
//设置屏幕竖屏（默认）
- (void)setScreenInterfaceOrientationDefault{
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}


@end
