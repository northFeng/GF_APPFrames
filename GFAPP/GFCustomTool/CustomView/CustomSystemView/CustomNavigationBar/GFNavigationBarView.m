//
//  GFNavigationBarView.m
//  GFAPP
//
//  Created by XinKun on 2017/11/13.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFNavigationBarView.h"

#import "GFNavigationBarView.h"

///常量命名规则（驼峰式命名规则），所有的单词首字母大写和加上与类名有关的前缀:
//导航条颜色设置
#define ColorNaviBar [UIColor whiteColor]
#define ColorNaviBar_ItemText [UIColor grayColor]
#define FontNaviBar_ItemText [UIFont systemFontOfSize:15]

@interface GFNavigationBarView ()

///按钮条
@property (nonatomic, strong)UIView *naviBarView;

///导航条底部分割线
@property (nonatomic, strong) UIView *segmentationLine; //底部分割线

/** 导航栏标题 */
@property (nonatomic, strong) UILabel *titleLabel;


/** 左侧第一个按钮 */
@property (nonatomic,strong) UIButton *leftFirstBtn;

/** 右侧第一个按钮 */
@property (nonatomic, strong)UIButton *rightFirstBtn;

/** 右侧第二个按钮 */
@property (nonatomic, strong)UIButton *rightSecondBtn;

///** 右侧倒数第三个按钮 */
//@property (nonatomic, strong)UIButton *rightThreeBtn;

@end


@implementation GFNavigationBarView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createNaviBarView];
    }
    return self;
}

///创建导航条布局
- (void)createNaviBarView{
    
    ///导航条背景颜色
    self.backgroundColor = ColorNaviBar;
    
    //itemBar视图
    _naviBarView = [[UIView alloc] init];
    _naviBarView.backgroundColor = [UIColor clearColor];
    [self addSubview:_naviBarView];
    [_naviBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self);
        make.height.mas_equalTo(APP_NaviBar_ItemBarHeight);
    }];
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"标题";
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_naviBarView addSubview:_titleLabel];
    
    //左侧按钮(创建自定义按钮)
    _leftFirstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftFirstBtn.tag = 2001;
    _leftFirstBtn.titleLabel.font = FontNaviBar_ItemText;
    [_leftFirstBtn setTitleColor:ColorNaviBar_ItemText forState:0];
    [_leftFirstBtn setBackgroundColor:[UIColor clearColor]];
    [_leftFirstBtn addTarget:self action:@selector(leftFirstButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_naviBarView addSubview:_leftFirstBtn];
    
    //右侧第一个按钮_rightFirstBtn
    _rightFirstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightFirstBtn.tag = 2002;
    _rightFirstBtn.titleLabel.font = FontNaviBar_ItemText;
    [_rightFirstBtn setTitleColor:ColorNaviBar_ItemText forState:0];
    [_rightFirstBtn setBackgroundColor:[UIColor clearColor]];
    [_rightFirstBtn addTarget:self action:@selector(rightFirstButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_naviBarView addSubview:_rightFirstBtn];
    
    //右侧第二个按钮_rightSecondBtn
    _rightSecondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightSecondBtn.tag = 2003;
    _rightSecondBtn.titleLabel.font = FontNaviBar_ItemText;
    [_rightSecondBtn setTitleColor:ColorNaviBar_ItemText forState:0];
    [_rightSecondBtn setBackgroundColor:[UIColor clearColor]];
    [_rightSecondBtn addTarget:self action:@selector(rightSecondButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_naviBarView addSubview:_rightSecondBtn];
    
    //分割线
    _segmentationLine = [[UIView alloc] init];
    _segmentationLine.backgroundColor = [UIColor blueColor];
    [self addSubview:_segmentationLine];
    
    
    //********建立约束************
    //左边第一按钮
    [_leftFirstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_naviBarView);
        make.left.equalTo(_naviBarView);
        make.width.and.height.equalTo(_naviBarView.mas_height);
    }];
    
    //右边第一个按钮
    [_rightFirstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftFirstBtn);
        make.right.equalTo(_naviBarView.mas_right).with.offset(-10.);
        make.width.and.height.equalTo(_naviBarView.mas_height);
    }];
    
    //右边第二个按钮
    [_rightSecondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftFirstBtn);
        make.right.equalTo(_rightFirstBtn.mas_left).with.offset(-15.);
        make.width.and.height.equalTo(_naviBarView.mas_height);
    }];
    
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_naviBarView);
        make.height.mas_equalTo(_naviBarView.mas_height);
        make.width.mas_equalTo(150.);
    }];
    
    //分割线
    [_segmentationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(_naviBarView);
        make.height.mas_equalTo(0.5);
    }];
    
    //默认全部隐藏
    _leftFirstBtn.hidden = YES;
    _rightFirstBtn.hidden = YES;
    _rightSecondBtn.hidden = YES;
    _segmentationLine.hidden = YES;//默认隐藏分割线
    
}

- (void)setTitle:(NSString *)title {
    if (title == _title) {
        _title = title;
    }
    _titleLabel.text = title;
}


#pragma mark - 专为iPhone X设置的方法
///设置按钮条背景颜色
- (void)setItemsBtnBarColor:(UIColor *)btnBarColor{
    
    _naviBarView.backgroundColor = btnBarColor;
}


#pragma mark - 常规设置按钮
///设置左侧第一个按钮为返回按钮
- (void)setLeftFirstButtonWithImageName:(NSString *)imageName{
    
    _leftFirstBtn.hidden = NO;
    UIImage *image = [UIImage imageNamed:imageName];
    [_leftFirstBtn setImage:image forState:UIControlStateNormal];
}

///设置左侧第一个按钮为非返回按钮
- (void)setLeftFirstButtonWithTitleName:(NSString *)titleName{
    
    _leftFirstBtn.hidden = NO;
    //_leftFirstBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_leftFirstBtn setTitle:titleName forState:UIControlStateNormal];
}

///设置右侧第一个按钮显示图片
- (void)setRightFirstButtonWithImageName:(NSString *)imageName{
    
    _rightFirstBtn.hidden = NO;
    UIImage *image = [UIImage imageNamed:imageName];
    [_rightFirstBtn setImage:image forState:UIControlStateNormal];
}

///设置右侧第一个按钮显示文字
- (void)setRightFirstButtonWithTitleName:(NSString *)titleName{
    
    _rightFirstBtn.hidden = NO;
    //_rightFirstBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_rightFirstBtn setTitle:titleName forState:UIControlStateNormal];
}

///设置右侧第二个按钮显示图片
- (void)setRightSecondButtonWithImageName:(NSString *)imageName{
    
    _rightSecondBtn.hidden = NO;
    UIImage *image = [UIImage imageNamed:imageName];
    [_rightSecondBtn setImage:image forState:UIControlStateNormal];
}

///设置右侧第二个按钮显示文字
- (void)setRightSecondButtonWithTitleName:(NSString *)titleName{
    
    _rightSecondBtn.hidden = NO;
    //_rightSecondBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_rightSecondBtn setTitle:titleName forState:UIControlStateNormal];
}

#pragma mark - 代理调用的方法
///左侧第一个按钮事件
- (void)leftFirstButtonClick:(UIButton *)button{
    
    if([_delegate respondsToSelector:@selector(leftFirstButtonClick:)]) {
        [_delegate leftFirstButtonClick:button];
    }
    
}

///左侧第二个按钮事件
- (void)rightFirstButtonClick:(UIButton *)button{
    
    if([_delegate respondsToSelector:@selector(rightFirstButtonClick:)]) {
        [_delegate rightFirstButtonClick:button];
    }
    
}

///左侧第三个按钮事件
- (void)rightSecondButtonClick:(UIButton *)button{
    
    if([_delegate respondsToSelector:@selector(rightSecondButtonClick:)]) {
        [_delegate rightSecondButtonClick:button];
    }
    
}


@end
