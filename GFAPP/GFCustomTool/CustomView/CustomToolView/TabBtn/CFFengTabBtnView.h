//
//  CFFengTabBtnView.h
//  CurrencyFruit
//  交易tab切换按钮
//  Created by gaoyafeng on 2018/4/24.
//  Copyright © 2018年 斑马. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFFengTabBtnView : UIView

/** block回调 */
@property (nonatomic,copy) void(^blockIndex)(NSInteger index);

///创建视图
- (void)createViewBtnCount:(NSArray *)arrayData defaultSelectIndex:(NSInteger)selectIndex;

/** 设置视图Two
  * 添加label选择的颜色
  */
- (void)createViewBtnCount:(NSArray *)arrayData defaultSelectIndex:(NSInteger)selectIndex withLabelNormalColor:(UIColor *)normalColor labelSelectColor:(UIColor *)selectColor;

///外部切换按钮
- (void)switchButtonWithIndex:(NSInteger)index;

@end



@interface CFTradeBtn : UIButton

/** 正常颜色 */
@property (nonatomic,strong) UIColor *normalLabelColor;

/** 选中颜色 */
@property (nonatomic,strong) UIColor *selectLabelColor;

+ (instancetype)createTradeBtn;

///设置选中样式
- (void)setSelectStyle;

///设置选中样式
- (void)setDefaultStyle;

@end



/**
//VC 中的代码
#import "CFFengTabBtnView.h"//顶部tab条

#import "CFTradeViewController.h"//交易记录

#import "CFTradeViewController.h"//交易记录列表

@interface CFMyTradeViewController ()<UIScrollViewDelegate>

// 顶部tab条
@property (nonatomic,strong) CFFengTabBtnView *tabBtnView;

// 滑动视图
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation CFMyTradeViewController
{
    NSArray *_arrayTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self createView];
    
    
}

///初始化数据
- (void)initData{
    _arrayTitle = @[@"加入",@"转出"];
    
    
}

///创建视图
- (void)createView{
    
    _tabBtnView = [[CFFengTabBtnView alloc] initWithFrame:CGRectMake(0, KTopHeight, KScreenWidth, 44)];
    [_tabBtnView createViewBtnCount:@[@"加入",@"转出"] defaultSelectIndex:0];
    __weak typeof(self) weakSelf = self;
    _tabBtnView.blockIndex = ^(NSInteger index) {
        [weakSelf scrollViewSwitchView:index];
    };
    [self.view addSubview:_tabBtnView];
    
    //创建scrollerView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.frame = CGRectMake(0, KTopHeight + 44, KScreenWidth, KScreenHeight - KTopHeight - 44);
    [self.view addSubview:_scrollView];
    
    for (int i=0; i<_arrayTitle.count; i++) {
        
        CFTradeViewController *tradeVC = [[CFTradeViewController alloc] init];
        tradeVC.view.frame = CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - KTopHeight - 44);
        [self addChildViewController:tradeVC];
        [_scrollView addSubview:tradeVC.view];
    }
    
    _scrollView.contentSize = CGSizeMake(KScreenWidth * 2, KScreenHeight - KTopHeight - 44);
    
}

#pragma mark - tab切换条按钮  与  scrollerView 的联动处理


//// <UIScrollViewDelegate> scrollView滑动结束监听
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    //调用切换按钮
    [_tabBtnView switchButtonWithIndex:index];
    
}

///切换按钮控制scrollView切换
- (void)scrollViewSwitchView:(NSInteger)index{
    
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset = CGPointMake(KScreenWidth * index, 0);
    }];
}

*/









