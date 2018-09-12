//
//  GFSearchBarView.m
//  Lawpress
//
//  Created by XinKun on 2017/6/7.
//  Copyright © 2017年 彬万. All rights reserved.
//

#import "GFSearchBarView.h"

@implementation GFSearchBarView

{

    UIScrollView *_scrollView;
    
    UIButton *_currentBtn;//当前的btn
    
    UIView *_line;//当前下划线
    
    CGFloat _maxX;

}


- (instancetype)initWithFrame:(CGRect)frame{

    if ([super initWithFrame:frame]) {
        
        [self createView];
    }
    
    return self;
}


///创建视图
- (void)createView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    //创建下划线
    _line = [[UIView alloc] init];
    _line.backgroundColor = UIColorFromRGB(60,130,211);
    _line.frame = CGRectMake(0, 0, 40, 2);
    [_scrollView addSubview:_line];
    
    UIView *linebottom = [[UIView alloc] init];
    linebottom.backgroundColor = UIColorFromSameRGB(228);
    [self addSubview:linebottom];
    [linebottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

///创建btn
- (void)setBtnArray:(NSArray *)arrayBtnString{

    for (int i=0; i<arrayBtnString.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 10000 + i;
        [btn setTitle:arrayBtnString[i] forState:0];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(60,130,211) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        btn.frame = CGRectMake(25+65*i, 0, 40, 38);
        
        [_scrollView addSubview:btn];
        
        btn.selected = NO;
        
        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame)+25, 40);
        
        //添加事件
        [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0) {
            //默认进来选择第一个按钮
            [self onClickBtn:btn];
        }
        
    }


    _maxX = 65*arrayBtnString.count + 25;
}


#pragma mark - 按钮点击事件
- (void)onClickBtn:(UIButton *)btn{
    
    
    //切换按钮
    _currentBtn.selected = NO;
    
    _currentBtn = btn;
    
    _currentBtn.selected = YES;
    
    NSInteger index = btn.tag - 10000;
    
    WS(weakSelf);
    
    //改变下划线位置
    [UIView animateWithDuration:0.3 animations:^{
        
        _line.center = CGPointMake(_currentBtn.center.x, 38);
        
    } completion:^(BOOL finished) {
        
        //回调刷新
        weakSelf.blockBtnIndex(index);
        
    }];
    
}

///滚动当前按钮
- (void)scrollerToCurrentBtn:(NSInteger)index{
    
    UIButton *btn = [self viewWithTag:10000 + index];
    
    [self changBtn:btn];
}


- (void)changBtn:(UIButton *)btn{
    
    //切换按钮
    _currentBtn.selected = NO;
    
    _currentBtn = btn;
    
    _currentBtn.selected = YES;
    
    //改变视角  161   455 最大视角
    CGFloat x = 0;

    if (_currentBtn.center.x >= kScreenWidth/2.) {
        x = _currentBtn.center.x - kScreenWidth/2.;
        x = x >= _maxX - kScreenWidth ? _maxX - kScreenWidth : x ;
    }else{
        x = 0;
    }
    
    //改变下划线位置
    [UIView animateWithDuration:0.3 animations:^{
        
        _line.center = CGPointMake(_currentBtn.center.x, 38);
        
        _scrollView.contentOffset = CGPointMake(x, 0);
        
    }];
    
}















@end
