//
//  XKRefreshHeader.m
//  Lawpress
//
//  Created by 彬万 on 16/9/27.
//  Copyright © 2016年 彬万. All rights reserved.
//

#import "XKRefreshHeader.h"
#import "UIImageView+Custom.h"

@interface XKRefreshHeader ()

@property (weak, nonatomic) UILabel *refreshLabel;
@property (weak, nonatomic) UIImageView *refreshImageView;

@property (weak, nonatomic) UIView *centerView;

@end

@implementation XKRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h =60;
    
    //添加中心视图
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    self.centerView = view;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:153 / 255. green:153 / 255. blue:153 / 255. alpha:1];
    [view addSubview:label];
    self.refreshLabel = label;
    
    // 图片
    UIImageView *s = [[UIImageView alloc] init];
    [view addSubview:s];
    self.refreshImageView = s;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    NSString *str = @"下拉即可刷新...";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(self.bounds.size.width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.centerView.frame = CGRectMake(0, 0, size.width + 8 + 56 / 2., self.bounds.size.height);
    self.centerView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2.);
    self.refreshImageView.frame = CGRectMake(0, 13, 56 / 2., 54 / 2.);
    self.refreshLabel.frame = CGRectMake(CGRectGetMaxX(self.refreshImageView.frame) + 8., 0,size.width, CGRectGetHeight(self.centerView.frame));
   
//    self.refreshLabel.frame = self.bounds;
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    // 状态检查【方法抽成宏】
    MJRefreshCheckState;
    
    //转成NSData
    NSArray *imageArray = [[APPLogisticsManager sharedInstance].imageOperation image_GetImageGroupFormImgGif:@"refresh.gif"];
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            [self.refreshImageView  stopAnimating];
            self.refreshLabel.text = @"下拉即可刷新...";
            self.refreshImageView.image = [imageArray firstObject];
            break;
        }
        case MJRefreshStatePulling:
        {
            self.refreshLabel.text = @"释放即可刷新...";
            self.refreshImageView.image = [imageArray lastObject];
            break;
        }
        case MJRefreshStateRefreshing:
        {
            self.refreshLabel.text = @"释放即可刷新...";
            
            self.refreshImageView.animationImages = imageArray;
            
            self.refreshImageView.animationDuration = 0.5;
            self.refreshImageView.animationRepeatCount = 0;
            [self.refreshImageView startAnimating];
            break;
        }
        default:
            break;
    }
}
-(void)getVersio{
    [self endRefreshing];
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}


@end
