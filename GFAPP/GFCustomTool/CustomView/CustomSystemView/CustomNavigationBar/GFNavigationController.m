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

+ (GFNavigationController *)sharedInstance
{
    static GFNavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navi = [[GFNavigationController alloc] init];
    });
    return navi;
}

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




@end
