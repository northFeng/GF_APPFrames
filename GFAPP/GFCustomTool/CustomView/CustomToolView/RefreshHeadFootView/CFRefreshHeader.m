//
//  CFRefreshHeader.m
//  CurrencyFruit
//
//  Created by gaoyafeng on 2018/5/16.
//  Copyright © 2018年 斑马. All rights reserved.
//

#import "CFRefreshHeader.h"

#define kPullRefreshBgHeight (55/375.0 * KScreenWidth)

@interface CFRefreshHeader ()

/** 动画 */
@property (strong, nonatomic) UIImageView *gifImageView;

/** 背景图片 */
@property (strong, nonatomic) UIImageView *backgroundImageView;

/** 定时器 */
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation CFRefreshHeader
{
    NSInteger _count;
}

- (void)dealloc{
    //销毁定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (void)prepare
{
    [super prepare];
    //初始化数据
    _count = 0;
    
    [self addSubview:self.backgroundImageView];
    
    [self addSubview:self.gifImageView];
    
    _timer = [NSTimer timerWithTimeInterval:0.013 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self closeTimer];
    
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    self.mj_h = 45.5 + kPullRefreshBgHeight;
    self.backgroundColor = RGBCOLORX(248);
    
}

#pragma mark - 定时器事件
- (void)timerAction{
    
    if (_count >= 18) {
        _count = 0;
    }
    self.gifImageView.transform = CGAffineTransformMakeRotation(M_PI/18.*_count);
    _count++;
}

///开启
- (void)startTimer{
    
    //开启
    [_timer setFireDate:[NSDate distantPast]];
}

///关闭
- (void)closeTimer{
    //暂停
    [_timer setFireDate:[NSDate distantFuture]];
    //self.gifImageView.transform = CGAffineTransformMakeRotation(M_PI/18.*0);
}


#pragma mark -----setter and getter-----
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kPullRefreshBgHeight)];
        _backgroundImageView.image = [UIImage imageNamed:@"refreshTopImg"];
    }
    return _backgroundImageView;
}
- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 20)/2.0, kPullRefreshBgHeight+10, 20, 20)];
        _gifImageView.contentMode = UIViewContentModeScaleAspectFill;
        _gifImageView.image = [UIImage imageNamed:@"loading"];
    }
    return _gifImageView;
}


- (void)setState:(MJRefreshState)state{
    
    MJRefreshCheckState
    switch (state) {
        case MJRefreshStateIdle:
            //普通闲置状态
            [self closeTimer];//关闭旋转

            break;
        case MJRefreshStatePulling:
            //松开就可以进行刷新的状态

            break;
        case MJRefreshStateRefreshing:
            //正在刷新中的状态
            [self startTimer];//开启旋转
            
            break;
        case MJRefreshStateWillRefresh:
            //即将刷新的状态
            
            
            break;
        case MJRefreshStateNoMoreData:
            //所有数据加载完毕，没有更多的数据了
            break;
        default:
            break;
    }
    
}



#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    _count = (pullingPercent *18)/1;
    self.gifImageView.transform = CGAffineTransformMakeRotation(M_PI/18.*_count);
}







@end
