//
//  CFRefreshFooter.m
//  CurrencyFruit
//
//  Created by gaoyafeng on 2018/5/16.
//  Copyright © 2018年 斑马. All rights reserved.
//

#import "CFRefreshFooter.h"

@interface CFRefreshFooter()

/** 图片 */
@property (nonatomic,strong) UIImageView *backImageView;

@end

@implementation CFRefreshFooter


- (void)prepare
{
    [super prepare];
    
    self.backgroundColor = RGBCOLORX(248);
    // 设置控件的高度
    self.mj_h = 65/375.0 * KScreenWidth;
    
    self.backImageView = [[UIImageView alloc] init];
    self.backImageView.image = [UIImage imageNamed:@"refreshTopImg"];
    [self addSubview:self.backImageView];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.backImageView.frame = CGRectMake(0, (65/375.0 * KScreenWidth - 45)/2., KScreenWidth, 45);
}


@end
