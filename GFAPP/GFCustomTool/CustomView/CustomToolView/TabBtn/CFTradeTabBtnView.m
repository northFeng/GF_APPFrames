//
//  CFFengTabBtnView.m
//  CurrencyFruit
//
//  Created by gaoyafeng on 2018/4/24.
//  Copyright © 2018年 斑马. All rights reserved.
//

#import "CFFengTabBtnView.h"

@implementation CFFengTabBtnView

{
    UIView *_bottomLine;
    
    CFTradeBtn *_btnSelect;
    
    UIColor *_normalLabelColor;
    
    UIColor *_selectLabelColor;
}


///创建视图
- (void)createViewBtnCount:(NSArray *)arrayData defaultSelectIndex:(NSInteger)selectIndex{
   
    if (arrayData.count > 0) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.frame = CGRectMake(0, 0, 30, 2);
        _bottomLine.backgroundColor = [UIColor colorWithRed:(253)/255.0f green:(117)/255.0f blue:(53)/255.0f alpha:(1)];
        [self addSubview:_bottomLine];
        
        CGFloat btnWidth = self.frame.size.width / arrayData.count;
        NSInteger index = 0;
        for (NSString *title in arrayData) {
            
            CFTradeBtn *btn = [CFTradeBtn createTradeBtn];
            btn.normalLabelColor = _normalLabelColor!=nil ? _normalLabelColor : [UIColor blackColor];
            btn.selectLabelColor = _selectLabelColor!=nil ? _selectLabelColor : [UIColor colorWithRed:(253)/255.0f green:(117)/255.0f blue:(53)/255.0f alpha:(1)];
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.tag = 1000 + index;
            [btn setTitle:title forState:0];
            //默认不选中样式
            [btn setDefaultStyle];
            //设置约束
            btn.frame = CGRectMake(btnWidth * index, 0, btnWidth, 44);
            [self addSubview:btn];
            
            //设置选中样式
            if (index == selectIndex) {
                [btn setSelectStyle];
                _btnSelect = btn;//选中按钮
                _bottomLine.center = CGPointMake(btn.center.y, 43);
            }
            [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            index ++;
        }
        
        //把下划线置于最上层
        [self bringSubviewToFront:_bottomLine];
    }
    
}



///设置视图Two
- (void)createViewBtnCount:(NSArray *)arrayData defaultSelectIndex:(NSInteger)selectIndex withLabelNormalColor:(UIColor *)normalColor labelSelectColor:(UIColor *)selectColor{
    
    _normalLabelColor = normalColor;
    _selectLabelColor = selectColor;
    
    [self createViewBtnCount:arrayData defaultSelectIndex:selectIndex];
}


#pragma mark - 按钮切换业务逻辑处理
///按钮点击事件
- (void)onClickBtn:(CFTradeBtn *)btnSlect{
    
    //旧的按钮改变样式
    [_btnSelect setDefaultStyle];
    //触发回调
    if (self.blockIndex) {
        self.blockIndex(btnSlect.tag - 1000);
    }
    _btnSelect = btnSlect;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomLine.center = CGPointMake(btnSlect.center.x, 43);
    } completion:^(BOOL finished) {
        [btnSlect setSelectStyle];
    }];
    
}


///外部切换按钮
- (void)switchButtonWithIndex:(NSInteger)index{
    
    CFTradeBtn *btnWillSwitch = [self viewWithTag:1000 + index];
    
    //切换按钮
    [self onClickBtn:btnWillSwitch];
}



@end




#pragma mark - 自定义按钮
@implementation CFTradeBtn


+ (instancetype)createTradeBtn{
    
    CFTradeBtn *btn = [CFTradeBtn buttonWithType:UIButtonTypeCustom];
    [btn setBtnStyle];
    return btn;
}

- (void)setBtnStyle{
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self setTitleColor:_normalLabelColor forState:UIControlStateNormal];
    //253,117,53
}

///设置选中样式
- (void)setSelectStyle{
    
    [self setTitleColor:_selectLabelColor forState:UIControlStateNormal];
    
}

///设置选中样式
- (void)setDefaultStyle{
    
    [self setTitleColor:_normalLabelColor forState:UIControlStateNormal];
}



@end
