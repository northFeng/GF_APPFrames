//
//  GFTimer.h
//  FlashSend
//  自定义定时器
//  Created by gaoyafeng on 2018/11/22.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GFTimerDelegate <NSObject>

- (void)refreshUIWithSection:(NSInteger)time isOver:(BOOL)over;

@end

@interface GFTimer : NSObject

///导航条代理
@property (nonatomic,weak) id <GFTimerDelegate> delegate;

///定时器
@property (nonatomic,strong,nullable) NSTimer *timer;

///倒计时（默认60秒）
@property (nonatomic,assign) NSInteger countdownTimer;

///定时器是否开启
@property (nonatomic,assign) BOOL isStart;


///定时器事件
- (void)timerFired;

///开启定时器
- (void)openTimer;


///关闭定时器
- (void)closeTimer;


///开始定时器
- (void)startTimer;

///暂停定时器
- (void)stopTimer;

///销毁定时器
- (void)deallocTimer;


@end

NS_ASSUME_NONNULL_END


/**
 _timer = [[GFTimer alloc] init];
 _timer.countdownTimer = 45;
 _timer.delegate = self;
 
 //记得销毁定时器
 [_timer deallocTimer];
 
 #pragma mark - 自定义定时器代理
 - (void)refreshUIWithSection:(NSInteger)time isOver:(BOOL)over{
 
 if (over == YES) {
 NSString *btnString = [NSString stringWithFormat:@"%lds",(long)time];
 [_btnCode setTitle:btnString forState:UIControlStateNormal];
 }else{
 
 _btnCode.enabled = YES;
 _btnCode.layer.borderColor = APPColor_Blue.CGColor;
 [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
 }
 }
 */

