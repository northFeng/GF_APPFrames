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

///倒计时
@property (nonatomic,assign) NSInteger countdownTimer;

///定时器是否开启
@property (nonatomic,assign) BOOL isStart;

///创建自定义定时器对象
+ (instancetype)initWithCountDownTimer:(NSInteger)downTimer;

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
