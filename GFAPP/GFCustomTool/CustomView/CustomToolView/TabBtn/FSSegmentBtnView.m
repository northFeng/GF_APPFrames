//
//  FSSegmentBtnView.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/9/8.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSSegmentBtnView.h"

@implementation FSSegmentBtnView


{
    
    GFTradeBtn *_btnSelect;
    
    UIColor *_normalLabelColor;
    
    UIColor *_selectLabelColor;
    
    CGFloat _lineCenterY;
    
    NSMutableArray *_btnArray;
}

- (instancetype)init{
    if ([super init]) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

///初始化数据
- (void)initData{
    
    _btnArray = [NSMutableArray array];
    
}


///创建视图
- (void)createViewBtnCount:(NSArray *)arrayData defaultSelectIndex:(NSInteger)selectIndex{
    
    if (arrayData.count > 0) {
        
        _lineCenterY = 26*KSCALE;
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.frame = CGRectMake(0, 0, 12, 3);
        _bottomLine.backgroundColor = [UIColor blueColor];
        [self addSubview:_bottomLine];
        
        CGFloat btnWidth = self.frame.size.width / arrayData.count;
        NSInteger index = 0;
        for (NSString *title in arrayData) {
            
            GFTradeBtn *btn = [GFTradeBtn createTradeBtn];
            btn.normalLabelColor = _normalLabelColor!=nil ? _normalLabelColor : [UIColor blackColor];
            btn.selectLabelColor = _selectLabelColor!=nil ? _selectLabelColor : [UIColor colorWithRed:(253)/255.0f green:(117)/255.0f blue:(53)/255.0f alpha:(1)];
            [btn setBackgroundColor:[UIColor clearColor]];
            btn.tag = 1000 + index;
            [btn setTitle:title forState:0];
            //默认不选中样式
            [btn setDefaultStyle];
            //设置约束
            btn.frame = CGRectMake(btnWidth * index, 0, btnWidth, 20*KSCALE);
            [self addSubview:btn];
            
            //设置选中样式
            if (index == selectIndex) {
                [btn setSelectStyle];
                _btnSelect = btn;//选中按钮
                _bottomLine.center = CGPointMake(btn.center.x, _lineCenterY);
            }
            [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            index ++;
            
            [_btnArray gf_addObject:btn];
        }
        
        //把下划线置于最上层
        [self bringSubviewToFront:_bottomLine];
    }
    
}


#pragma mark - 第二版
///设置视图Two
- (void)createViewBtnCount:(NSArray *)arrayData defaultSelectIndex:(NSInteger)selectIndex withLabelNormalColor:(UIColor *)normalColor labelSelectColor:(UIColor *)selectColor{
    
    _normalLabelColor = normalColor;
    _selectLabelColor = selectColor;
    
    [self createViewBtnCount:arrayData defaultSelectIndex:selectIndex];
}

#pragma mark - 第三版
/** 设置视图Thr
 * 添加label选择的颜色
 */
- (void)createViewBtnCount:(NSArray *)arrayData defaultSelectIndex:(NSInteger)selectIndex withLabelNormalColor:(UIColor *)normalColor textFontDefault:(UIFont *)defaultFont labelSelectColor:(UIColor *)selectColor textSelectFont:(UIFont *)selectFont lineColor:(UIColor *)lineColor btnWidth:(CGFloat)btnWidth{
    
    _normalLabelColor = normalColor;
    _selectLabelColor = selectColor;
    
    if (arrayData.count > 0) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.frame = CGRectMake(0, 0, _lineSize.width, _lineSize.height);
        _bottomLine.backgroundColor = lineColor;
        [self addSubview:_bottomLine];
        
        CGFloat btnSpace = (self.frame.size.width - (btnWidth * arrayData.count))/(arrayData.count - 1);
        NSInteger index = 0;
        for (NSString *title in arrayData) {
            
            GFTradeBtn *btn = [GFTradeBtn createTradeBtn];
            //按钮属性
            btn.textFontDefault = defaultFont;
            btn.textFontSelect = selectFont;
            btn.normalLabelColor = _normalLabelColor!=nil ? _normalLabelColor : [UIColor blackColor];
            btn.selectLabelColor = _selectLabelColor!=nil ? _selectLabelColor : [UIColor colorWithRed:(253)/255.0f green:(117)/255.0f blue:(53)/255.0f alpha:(1)];
            
            [btn setBackgroundColor:[UIColor clearColor]];
            btn.tag = 1000 + index;
            [btn setTitle:title forState:0];
            //默认不选中样式
            [btn setDefaultStyle];
            //设置约束
            btn.frame = CGRectMake((btnWidth + btnSpace) * index, 0, btnWidth, btnWidth*_hwScale);
            [self addSubview:btn];
            
            //设置选中样式
            if (index == selectIndex) {
                [btn setSelectStyle];
                _btnSelect = btn;//选中按钮
                _bottomLine.center = CGPointMake(btn.center.x, btnWidth*_hwScale + _lineToBtnHeight);
                //计算下划线的中点点Y坐标
                _lineCenterY = btnWidth*_hwScale + _lineToBtnHeight;
            }
            [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            index ++;
            
            [_btnArray gf_addObject:btn];
        }
        
        //把下划线置于最上层
        [self bringSubviewToFront:_bottomLine];
    }
}


#pragma mark - 按钮切换业务逻辑处理
///按钮点击事件
- (void)onClickBtn:(GFTradeBtn *)btnSlect{
    
    //旧的按钮改变样式
    [_btnSelect setDefaultStyle];
    //触发回调
    if (self.blockIndex) {
        self.blockIndex(btnSlect.tag - 1000);
    }
    _btnSelect = btnSlect;
    [btnSlect setSelectStyle];
    
    [UIView animateWithDuration:0.3 animations:^{
        self->_bottomLine.center = CGPointMake(btnSlect.center.x, self->_lineCenterY);
    } completion:^(BOOL finished) {
        
    }];
    
}


///外部切换按钮
- (void)switchButtonWithIndex:(NSInteger)index{
    
    GFTradeBtn *btnWillSwitch = [self viewWithTag:1000 + index];
    
    //切换按钮
    [self onClickBtn:btnWillSwitch];
}


///更新按钮文字
- (void)refreshButtonTitleWithArrayData:(NSArray *)arrayTitle{
    
    for (int i = 0; i < arrayTitle.count ; i++) {
        
        NSString *title = [arrayTitle gf_getItemWithIndex:i];
        
        
        if ([title isKindOfClass:[NSString class]]) {
            
            GFTradeBtn *button = [_btnArray gf_getItemWithIndex:i];
            
            [button setTitle:title forState:UIControlStateNormal];
        }
    }
}




@end



#pragma mark - 自定义按钮
@implementation GFTradeBtn


+ (instancetype)createTradeBtn{
    
    GFTradeBtn *btn = [GFTradeBtn buttonWithType:UIButtonTypeCustom];
    btn.textFontDefault = [UIFont systemFontOfSize:14*KSCALE];
    btn.textFontSelect = [UIFont boldSystemFontOfSize:14*KSCALE];
    [btn setBtnStyle];
    return btn;
}

- (void)setBtnStyle{
    
    self.titleLabel.font = _textFontDefault;
    [self setTitleColor:_normalLabelColor forState:UIControlStateNormal];
    //253,117,53
}

///设置选中样式
- (void)setSelectStyle{
    
    self.titleLabel.font = _textFontSelect;
    [self setTitleColor:_selectLabelColor forState:UIControlStateNormal];
    
}

///设置选中样式
- (void)setDefaultStyle{
    
    self.titleLabel.font = _textFontDefault;
    [self setTitleColor:_normalLabelColor forState:UIControlStateNormal];
}



@end














