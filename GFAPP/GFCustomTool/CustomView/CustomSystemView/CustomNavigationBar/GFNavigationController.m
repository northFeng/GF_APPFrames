//
//  GFNavigationController.m
//  GFAPP
//
//  Created by XinKun on 2017/11/20.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFNavigationController.h"

@interface GFNavigationController ()

@end

@implementation GFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 屏幕旋转受根控制器的影响（屏幕方向由根控制器控制）
- (BOOL)shouldAutorotate{
    //self.topViewController 也可以
    return [self.visibleViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{

    return [self.visibleViewController supportedInterfaceOrientations];
}

//// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{

    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}


#pragma mark - 状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return [self.visibleViewController preferredStatusBarStyle];
    
}

//是否隐藏
- (BOOL)prefersStatusBarHidden{
    return [self.visibleViewController prefersStatusBarHidden];
}


//控制第二个视图后面 隐藏底部按钮条
//- (void)pushViewController:(UIViewController *)viewController
//                  animated:(BOOL)animated {
//
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        //控制右滑返回手势交互
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//
//    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//
//    [super pushViewController:viewController animated:animated];
//}





@end
