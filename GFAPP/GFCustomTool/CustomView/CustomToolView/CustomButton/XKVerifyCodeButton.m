//
//  XKVerifyCodeButton.m
//  Lawpress
//
//  Created by 彬万 on 16/10/24.
//  Copyright © 2016年 彬万. All rights reserved.
//

#import "XKVerifyCodeButton.h"

@interface XKVerifyCodeButton ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSTimeInterval timestamp;

@end

@implementation XKVerifyCodeButton
{
    NSInteger _countdownTimer;      //倒计时
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self observeApplicationActionNotification];
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setup {
    
    [self setTitle:@" 获取验证码 " forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 2.;
    self.clipsToBounds = YES;
    [self setTitleColor:UIColorFromRGB(60,130,211) forState:UIControlStateNormal];
    self.layer.borderColor = UIColorFromRGB(60,130,211).CGColor;
    self.layer.borderWidth = .5;
}

- (void)timeFailBeginFrom:(NSInteger)timeCount {
    
    
    _countdownTimer = timeCount;
    self.enabled = NO;
    // 加1个计时器
    [self setTitle:@"获取验证码" forState:UIControlStateDisabled];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerFired {
//    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    if (_countdownTimer != 0) {
        _countdownTimer -= 1;
        
        [self setTitle:[NSString stringWithFormat:@"剩余%ld秒", _countdownTimer] forState:UIControlStateDisabled];
    } else {
        
        self.enabled = YES;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        //        self.count = 60;
        [self.timer invalidate];
    }
}


- (void)observeApplicationActionNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationDidEnterBackground {
    
    _timestamp = [NSDate date].timeIntervalSince1970;
    _timer.fireDate = [NSDate distantFuture];
}

- (void)applicationDidBecomeActive {
    
    NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970-_timestamp;
    _timestamp = 0;
    
    NSTimeInterval ret = _countdownTimer-timeInterval;
    if (ret>0) {
        _countdownTimer = ret;
        _timer.fireDate = [NSDate date];
    } else {
        _countdownTimer = 0;
        _timer.fireDate = [NSDate date];
        [self timerFired];
    }
}


@end
