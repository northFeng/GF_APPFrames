//
//  APPScreenRotationController.m
//  GFAPP
//
//  Created by 峰 on 2019/11/20.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "APPScreenRotationController.h"

#import "APPBaseController+ScreenRotation.h"//分类

@interface APPScreenRotationController ()

@end

@implementation APPScreenRotationController
{
    BOOL _isPlay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isPlay = NO;
    
    self.allowScreenRotate = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.allowScreenRotate = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _isPlay = !_isPlay;
    
    if (_isPlay) {
        [self setScreenInterfaceOrientationRight];
    }else{
        [self setScreenInterfaceOrientationDefault];
    }
}

/*iOS8以上，旋转控制器后会调用*/
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    //屏幕发生旋转后在这里进行重写布局
    
    /**
    有3种方式可以获取到“当前interfaceOrientation”：

    controller.interfaceOrientation，获取特定controller的方向

    [[UIApplication sharedApplication] statusBarOrientation] 获取状态条相关的方向

    [[UIDevice currentDevice] orientation] 获取当前设备的方向
     */
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            NSLog(@"向左横屏");
            break;
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"向右横屏");
            break;
        case UIInterfaceOrientationPortrait:
            NSLog(@"回到竖屏");
            break;
        default:
            break;
    }
}

@end
