//
//  FSLoadWaitView.h
//  FlashSend
//  项目里等待视图
//  Created by gaoyafeng on 2018/9/4.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSLoadWaitView : UIView

///开启
- (void)startAnimation;

///关闭
- (void)stopAnimation;


///开启 && 显示文字
- (void)startAnimationWithTitle:(NSString *)title;

///关闭 && 显示文字
- (void)stopAnimationWithTitle:(NSString *)title;


@end
