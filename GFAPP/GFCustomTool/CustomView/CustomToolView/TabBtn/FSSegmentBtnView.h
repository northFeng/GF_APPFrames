//
//  FSSegmentBtnView.h
//  FlashSend
//  切换按钮
//  Created by gaoyafeng on 2018/9/8.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSegmentBtnView : UIView

///按钮高度与宽度比例
@property (nonatomic,assign) CGFloat hwScale;

///下划线的size
@property (nonatomic,assign) CGSize lineSize;

///下划线中心点y距离按钮的距离
@property (nonatomic,assign) CGFloat lineToBtnHeight;

///下划线
@property (nonatomic,strong) UIView *bottomLine;


/** block回调 */
@property (nonatomic,copy) void(^blockIndex)(NSInteger index);

///创建视图第一版
- (void)createViewBtnCount:(NSArray *)arrayData defaultSelectIndex:(NSInteger)selectIndex;

/** 设置视图第二版
 * 添加label选择的颜色
 */
- (void)createViewBtnCount:(NSArray *)arrayData defaultSelectIndex:(NSInteger)selectIndex withLabelNormalColor:(UIColor *)normalColor labelSelectColor:(UIColor *)selectColor;

/** 设置视图第三版
 * 添加label选择的颜色
 */
- (void)createViewBtnCount:(NSArray *)arrayData defaultSelectIndex:(NSInteger)selectIndex withLabelNormalColor:(UIColor *)normalColor textFontDefault:(UIFont *)defaultFont labelSelectColor:(UIColor *)selectColor textSelectFont:(UIFont *)selectFont lineColor:(UIColor *)lineColor btnWidth:(CGFloat)btnWidth;

///外部切换按钮
- (void)switchButtonWithIndex:(NSInteger)index;

///更新按钮文字
- (void)refreshButtonTitleWithArrayData:(NSArray *)arrayTitle;


@end


@interface GFTradeBtn : UIButton

///默认显示文字font
@property (nonatomic,strong) UIFont *textFontDefault;

///选中文字font
@property (nonatomic,strong) UIFont *textFontSelect;

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
_tabBtnView = [[FSSegmentBtnView alloc] initWithFrame:CGRectMake(11, 15, kScreenWidth - 22, 30)];
_tabBtnView.hwScale = 20/45.;
_tabBtnView.lineSize = CGSizeMake(18, 4);
_tabBtnView.lineToBtnHeight = 8;
[_tabBtnView createViewBtnCount:_arrayTitle defaultSelectIndex:0 withLabelNormalColor:APPColor_Gray textFontDefault:kFontOfSystem(14) labelSelectColor:APPColor_Blue textSelectFont:kFontOfCustom(kMediumFont, 14) lineColor:APPColor_Blue btnWidth:45];
 _tabBtnView.bottomLine.layer.cornerRadius = 2;//必须放到这步（因为这步才创建出来）
_indexVC = 0;

__weak typeof(self) weakSelf = self;
_tabBtnView.blockIndex = ^(NSInteger index) {
    [weakSelf scrollViewSwitchView:index];
};
[self.headView addSubview:_tabBtnView];
 */
