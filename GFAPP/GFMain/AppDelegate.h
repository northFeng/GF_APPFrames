//
//  AppDelegate.h
//  GFAPP
//
//  Created by XinKun on 2017/4/21.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 引导滑动图 */
@property (nonatomic,strong) UIScrollView *scrollerView;

///是否允许屏幕旋转
@property (nonatomic,assign) BOOL allowRotate;

@end

