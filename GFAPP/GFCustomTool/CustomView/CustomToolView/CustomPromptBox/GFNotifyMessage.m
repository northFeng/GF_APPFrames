//
//  GFNotifyMessage.m
//  GFAPP
//
//  Created by XinKun on 2017/11/16.
//  Copyright © 2017年 North_feng. All rights reserved.
//
#define kContainerHorizontalPadding 20
#define kContainerVerticalPadding 15
#define kViewAnimateTime .3

#import <QuartzCore/QuartzCore.h>
#import "GFNotifyMessage.h"

@implementation GFNotifyMessage

+ (GFNotifyMessage *)sharedInstance
{
    static GFNotifyMessage *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GFNotifyMessage alloc] init];
    });
    return manager;
}

///这个默认信息在Window的视图上
- (void)showMessage:(NSString *)message{
    sync();
    @synchronized(self){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                //如果当前设备是iphone 就改为 UIView
                UIView *view = [[UIApplication sharedApplication] keyWindow];
                [self showMessage:message inView:view duration:kViewAnimateTime];
            }else
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    //如果当前设备是ipad 就改为 UIView
                    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                    [self showMessage:message inView:window.rootViewController.view duration:kViewAnimateTime];
                }
        });
    }
}

- (void)showMessage:(NSString *)message inView:(UIView *)view duration:(CGFloat)duration {
    
    UIView *containerView = [[UIView alloc] init];
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    containerView.opaque = NO;
    containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    containerView.layer.shadowOpacity = 0.8;
    containerView.layer.shadowRadius = 3;
    containerView.layer.shadowOffset = CGSizeMake(0, 0);
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = message;
    //    NSLog(@"%@",message);
    //    CGSize labelSize = [message sizeWithFont:textLabel.font];
    //    CGSize labelSize = [message sizeWithFont:textLabel.font forWidth:APP_SCREEN_WIDTH - 40 lineBreakMode:NSLineBreakByWordWrapping];
    //    CGSize labelSize = [message sizeWithFont:textLabel.font constrainedToSize:CGSizeMake(APP_SCREEN_WIDTH - 40, 80) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(APP_SCREEN_WIDTH - 40, 80) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:[NSDictionary dictionaryWithObjectsAndKeys:textLabel.font,NSFontAttributeName, nil] context:nil].size;
    //    NSLog(@"%@",NSStringFromCGSize(labelSize));
    CGRect labelFrame = CGRectMake(kContainerHorizontalPadding, kContainerVerticalPadding, labelSize.width, labelSize.height);
    textLabel.frame = labelFrame;
    
    CGRect parentViewFrame = view.frame;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
        ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) | UIDeviceOrientationLandscapeRight)
    {
        parentViewFrame = CGRectMake(0, 0, 1024, 768);
    }
    
    CGFloat containerFrameWidth = kContainerHorizontalPadding * 2 + labelSize.width;
    CGFloat containerFrameHeight = kContainerVerticalPadding * 2 + labelSize.height;
    CGFloat x = (parentViewFrame.size.width / 2) - (containerFrameWidth / 2);
    CGRect containerFrame = CGRectMake(x, parentViewFrame.size.height, containerFrameWidth, containerFrameHeight);
    containerView.frame = containerFrame;
    containerView.layer.cornerRadius = containerFrame.size.height / 2;
    
    [containerView addSubview:textLabel];
    [view addSubview:containerView];
    
    dispatch_queue_t queue = dispatch_queue_create("xk.showQueue",DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect visibleContainerFrame = CGRectMake(containerFrame.origin.x, parentViewFrame.size.height - containerFrame.size.height - 20-100, containerFrame.size.width, containerFrame.size.height);
            containerView.frame = visibleContainerFrame;
            containerView.alpha = 0;
            [UIView animateWithDuration:kViewAnimateTime
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 containerView.alpha = 1;
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:kViewAnimateTime
                                                       delay:duration
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      containerView.alpha = 0;
                                                  } completion:^(BOOL finished) {
                                                      [containerView removeFromSuperview];
                                                  }];
                             }];
        });
    });
    
}


- (void)showMessage:(NSString *)message inView:(UIView *)view duration:(CGFloat)duration complete:(GFDismissBlcok)block
{
    UIView *containerView = [[UIView alloc] init];
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:14];
    
    containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    containerView.opaque = NO;
    containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    containerView.layer.shadowOpacity = 0.8;
    containerView.layer.shadowRadius = 3;
    containerView.layer.shadowOffset = CGSizeMake(0, 0);
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = message;
    
    CGSize labelSize = [message sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textLabel.font,@"NSFontAttributeName", nil]];
    CGRect labelFrame = CGRectMake(kContainerHorizontalPadding, kContainerVerticalPadding, labelSize.width, labelSize.height);
    textLabel.frame = labelFrame;
    
    CGRect parentViewFrame = view.frame;
    CGFloat containerFrameWidth = kContainerHorizontalPadding * 2 + labelSize.width;
    CGFloat containerFrameHeight = kContainerVerticalPadding * 2 + labelSize.height;
    CGFloat x = (parentViewFrame.size.width / 2) - (containerFrameWidth / 2);
    CGRect containerFrame = CGRectMake(x, parentViewFrame.size.height, containerFrameWidth, containerFrameHeight);
    containerView.frame = containerFrame;
    containerView.layer.cornerRadius = containerFrame.size.height / 2;
    
    [containerView addSubview:textLabel];
    [view addSubview:containerView];
    
    dispatch_queue_t queue = dispatch_queue_create("xk.showQueue",DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect visibleContainerFrame = CGRectMake(containerFrame.origin.x, parentViewFrame.size.height - containerFrame.size.height - 20-100, containerFrame.size.width, containerFrame.size.height);
            containerView.frame = visibleContainerFrame;
            containerView.alpha = 0;
            
            [UIView animateWithDuration:kViewAnimateTime
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 containerView.alpha = 1;
                                 
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:kViewAnimateTime
                                                       delay:duration
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      containerView.alpha = 0;
                                                  } completion:^(BOOL finished) {
                                                      [containerView removeFromSuperview];
                                                      if (block) {
                                                          block();
                                                      }
                                                  }];
                             }];
            
            
        });
    });
    
}


@end
