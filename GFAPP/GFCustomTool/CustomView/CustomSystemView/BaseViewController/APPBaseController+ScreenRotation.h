//
//  APPBaseController+ScreenRotation.h
//  CleverBaby
//  屏幕旋转分类
//  Created by 峰 on 2019/11/5.
//  Copyright © 2019 小神童. All rights reserved.
//


#import "APPBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface APPBaseController (ScreenRotation)


///屏蔽旋转的VC必须设置 该属性 YES，VC消失时必须设置为NO
@property (nonatomic,assign) BOOL allowScreenRotate;


#pragma mark - ************************* 代码强制控制屏幕方向(用在锁屏时) *************************
//设置屏幕向左翻转
- (void)setScreenInterfaceOrientationLeft;


//设置屏幕向右翻转
- (void)setScreenInterfaceOrientationRight;


//设置屏幕竖屏（默认）
- (void)setScreenInterfaceOrientationDefault;



@end

NS_ASSUME_NONNULL_END
