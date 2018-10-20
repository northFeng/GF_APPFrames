//
//  FSLoadWaitView.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/9/4.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSLoadWaitView.h"

@implementation FSLoadWaitView
{
    UIImageView *_imgBigView;//转圈
    
    UIImageView *_imgSmallView;//灰色
    
    UILabel *_labelTitle;//显示文字
    
    ///定时器
    NSTimer *_timer;
    
    NSInteger _count;
}

- (void)dealloc{
    //销毁定时器
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.hidden = YES;
        [self createView];
    }
    return self;
}


///创建视图
- (void)createView{
    
    //初始化数据
    _count = 0;
    
    _imgBigView = [[UIImageView alloc] init];
    _imgBigView.image = [UIImage imageNamed:@"ic_loading_big"];
    [self addSubview:_imgBigView];
    
    _imgSmallView = [[UIImageView alloc] init];
    _imgSmallView.image = [UIImage imageNamed:@"ic_loading_inner_big"];
    [self addSubview:_imgSmallView];
    
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.text = @"加载中";
    _labelTitle.textColor = [UIColor grayColor];
    _labelTitle.font = [UIFont systemFontOfSize:15];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_labelTitle];
    
    
    //添加约束
    //_imgBigView.sd_layout.leftSpaceToView(self, 18).topSpaceToView(self, 8).rightSpaceToView(self, 18).heightIs(85);
    _imgBigView.frame = CGRectMake(18, 8, 85, 85);
    
    _imgSmallView.sd_layout.leftSpaceToView(self, 18).topSpaceToView(self, 8).rightSpaceToView(self, 18).heightIs(85);
    
    _labelTitle.sd_layout.leftEqualToView(self).rightEqualToView(self).bottomSpaceToView(self, 6).heightIs(20);
    
    //创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    //暂停
    [_timer setFireDate:[NSDate distantFuture]];
    
}

///定时器事件
- (void)timerFired{
    
    if (_count >= 36) {
        _count = 0;
    }
    _imgBigView.transform = CGAffineTransformMakeRotation(M_PI/18.*_count);
    _count++;
}


///开启
- (void)startAnimation{
    self.hidden = NO;
    //开启
    [_timer setFireDate:[NSDate distantPast]];
}

///关闭
- (void)stopAnimation{
    self.hidden = YES;
    //暂停
    [_timer setFireDate:[NSDate distantFuture]];
    _imgBigView.transform = CGAffineTransformMakeRotation(M_PI/18.*0);
    _count = 0;
    _labelTitle.text = @"加载中";
    
    //从父视图中移除
    //[self removeFromSuperview];
}


///开启 && 显示文字
- (void)startAnimationWithTitle:(NSString *)title{
    
    _labelTitle.text = title;
    [self startAnimation];
}

///关闭 && 显示文字
- (void)stopAnimationWithTitle:(NSString *)title{
    
    _labelTitle.text = title;
    //0.5秒后执行
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.5];
}

///设置显示文字
- (void)setShowLabelText:(NSString *)showStr{
    
    _labelTitle.text = showStr;
}


@end
