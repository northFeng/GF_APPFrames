//
//  GFTimer.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/11/22.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "GFTimer.h"

@implementation GFTimer
{
    
    NSTimeInterval _timestamp;//时间间隔
    
    NSInteger _downSeconds;
}


+ (instancetype)initWithCountDownTimer:(NSInteger)downTimer{
    
    GFTimer *timerGf = [[GFTimer alloc] init];
    timerGf.countdownTimer = downTimer;
    
    timerGf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timerGf.timer forMode:NSRunLoopCommonModes];
    //暂停
    [timerGf.timer setFireDate:[NSDate distantFuture]];
    timerGf.isStart = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:timerGf selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:timerGf selector:@selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    return timerGf;
}

///开启定时器
- (void)openTimer{
    _downSeconds = _countdownTimer;
    _timer.fireDate = [NSDate distantPast];//开启定时器
    _isStart = YES;
}

///关闭定时器
- (void)closeTimer{
    
    _timer.fireDate = [NSDate distantFuture];//开启定时器
    _isStart = NO;
}

///开始定时器
- (void)startTimer{
    
    _timer.fireDate = [NSDate distantPast];//开启定时器
    _isStart = YES;
}

///暂停定时器
- (void)stopTimer{
    
    _timer.fireDate = [NSDate distantFuture];//开启定时器
    _isStart = NO;
}


///定时器事件
- (void)timerFired{
    
    if (_downSeconds > 0) {
        
        _downSeconds -= 1;

        //回调 && 更新UI
        if (self.delegate) {
            [self.delegate refreshUIWithSection:_downSeconds isOver:YES];
        }
        
    }else{
        _downSeconds = _countdownTimer;
        //暂停
        [self.timer setFireDate:[NSDate distantFuture]];
        _isStart = NO;
        
        //回调 && 更新UI
        if (self.delegate) {
            [self.delegate refreshUIWithSection:_downSeconds isOver:NO];
        }
    }
}

///APP进入前台
- (void)applicationDidBecomeActive{
    
    if (_isStart) {
        
        NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970 - _timestamp;
        _timestamp = 0;
        
        NSTimeInterval ret = _downSeconds - timeInterval;
        
        if (ret > 0) {
            _downSeconds = ret;
            
            _timer.fireDate = [NSDate distantPast];//开启定时器
        } else {
            _downSeconds = 0;

            [self timerFired];
        }
        
    }
}

///APP进入后台
- (void)applicationDidEnterBackground{
    
    if (_isStart) {
        _timestamp = [NSDate date].timeIntervalSince1970;
        _timer.fireDate = [NSDate distantFuture];
    }
}

///销毁定时器
- (void)deallocTimer{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


@end
