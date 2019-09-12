//
//  GFButtonPress.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/10/27.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "GFButtonPress.h"

@implementation GFButtonPress
{
    BOOL _isLongPress;//是否长按
}

#pragma mark - 长按事件交互

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isLongPress = YES;
    
    [self performSelector:@selector(longpressBegin) withObject:nil afterDelay:0.5];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _isLongPress = NO;
    
    if (self.blockTap) {
        self.blockTap(YES);
    }
}


///长按事件开始
- (void)longpressBegin{
    
    if (self.blockPress) {
        
        if (_isLongPress) {
            
            self.blockPress(YES);
            
            [self performSelector:@selector(longpressBegin) withObject:nil afterDelay:_timeSpace];
        }
    }
}

/**
#pragma mark - 手势触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isLongPress = YES;//开始触摸
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchStart];
    });
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchEnd];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self touchEnd];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self touchEnd];
}

///触摸开始
- (void)touchStart {
    
    if (_isLongPress) {
        //触摸没结束
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
    }else{
        //触摸已经结束 ——> 触发点击事件
        _isLongPress = NO;
        [self.actionSignal sendNext:self.model];
    }
}

///触摸结束
- (void)touchEnd {
    
    if (_isLongPress) {
        _isLongPress = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1., 1.);
        }];
    }
}

- (RACSubject *)actionSignal{
    if (!_actionSignal) {
        _actionSignal = [RACSubject subject];
    }
    return _actionSignal;
}
 */

@end
