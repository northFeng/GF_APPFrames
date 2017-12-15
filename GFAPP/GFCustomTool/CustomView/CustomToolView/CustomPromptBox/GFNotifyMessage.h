//
//  GFNotifyMessage.h
//  GFAPP
//  APP内提示文字
//  Created by XinKun on 2017/11/16.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GFDismissBlcok)(void);

@interface GFNotifyMessage : UIView

/**
 *  消息提示者单例
 */
+ (GFNotifyMessage *)sharedInstance;

- (void)showMessage:(NSString *)message;

- (void)showMessage:(NSString *)message inView:(UIView *)view duration:(CGFloat)duration;

- (void)showMessage:(NSString *)message inView:(UIView *)view duration:(CGFloat)duration complete:(GFDismissBlcok)block;


@end
