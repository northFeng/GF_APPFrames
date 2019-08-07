//
//  ESInteractiveTransition.h
//  esReadStudent
//
//  Created by NSong on 2019/6/27.
//  Copyright © 2019 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GestureConifg)(void);

typedef NS_ENUM(NSUInteger, ESInteractiveTransitionGestureDirection) {//手势的方向
    ESInteractiveTransitionGestureDirectionLeft = 0,
    ESInteractiveTransitionGestureDirectionRight,
    ESInteractiveTransitionGestureDirectionUp,
    ESInteractiveTransitionGestureDirectionDown
};

typedef NS_ENUM(NSUInteger, ESInteractiveTransitionType) {//手势控制哪种转场
    ESInteractiveTransitionTypePresent = 0,
    ESInteractiveTransitionTypeDismiss,
    ESInteractiveTransitionTypePush,
    ESInteractiveTransitionTypePop,
};

@interface ESInteractiveTransition : UIPercentDrivenInteractiveTransition
/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;
/**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg presentConifg;
/**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg pushConifg;

//初始化方法

+ (instancetype)interactiveTransitionWithTransitionType:(ESInteractiveTransitionType)type GestureDirection:(ESInteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(ESInteractiveTransitionType)type GestureDirection:(ESInteractiveTransitionGestureDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END

/**
_interactiveTransitionPush = [ESInteractiveTransition interactiveTransitionWithTransitionType:ESInteractiveTransitionTypePush GestureDirection:ESInteractiveTransitionGestureDirectionLeft];
_interactiveTransitionPush.pushConifg = ^(){
    [weakSelf push];
};
[_interactiveTransitionPush addPanGestureForViewController:self];
 */
