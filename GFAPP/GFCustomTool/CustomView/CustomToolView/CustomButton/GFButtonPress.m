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


@end
