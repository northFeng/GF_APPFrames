//
//  XKRefreshFooter.m
//  Lawpress
//
//  Created by XinKun on 2017/8/9.
//  Copyright © 2017年 彬万. All rights reserved.
//

#import "XKRefreshFooter.h"

@implementation XKRefreshFooter

- (void)prepare
{
    [super prepare];
    
    // 设置文字
    [self setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
}

@end
