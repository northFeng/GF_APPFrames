//
//  GFSegmentedControl.m
//  GFAPP
//
//  Created by gaoyafeng on 2019/5/7.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "GFSegmentedControl.h"

@implementation GFSegmentedControl

{
    NSMutableArray *_arrayBtns;//按钮
    
    NSMutableArray *_arrayLines;//分割线
    
    UIButton *_btnSelect;//选中的按钮
    
    NSDictionary *_dicNormalAtr;//默认字体属性
    NSDictionary *_dicSelectAtr;//选中字体属性
    
    UIView *_backView;//滑块
}


- (instancetype)initWithItems:(nullable NSArray *)items{
    self = [super init];
    
    [self createButtonsWithItems:items];
    
    return self;
}


///创建按钮
- (void)createButtonsWithItems:(NSArray *)items{
    
    _tintColor = [UIColor blueColor];
    
    _selectedSegmentIndex = 0;
    
    _arrayBtns = [NSMutableArray array];
    
    _arrayLines = [NSMutableArray array];
    
    if (items.count) {
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = _tintColor;
        
        [self addSubview:_backView];
    }
    
    for (id item in items) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        if ([item isKindOfClass:[NSString class]]) {
            //文字
            [button setTitle:(NSString *)item forState:UIControlStateNormal];
            
            [_arrayBtns addObject:button];
            [self addSubview:button];
            
        }else if ([item isKindOfClass:[UIImage class]]){
            //图片
            [button setImage:(UIImage *)item forState:UIControlStateNormal];
            
            [_arrayBtns addObject:button];
            [self addSubview:button];
        }
        
        [button addTarget:self action:@selector(onClickBtutton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //布局等宽约束
    for (int i = 0; i < _arrayBtns.count ; i++) {
        
        UIButton *buttonFirst = _arrayBtns[0];//第一个
        UIButton *button = _arrayBtns[i];//当前
        button.tag = 1000 + i;//设置tag
        
        [button setTitleColor:_tintColor forState:UIControlStateNormal];
        
        if (i == 0) {
            //默认选中第一个
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnSelect = button;
            
            //约束
            if (_arrayBtns.count == 1) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self);
                    make.top.and.bottom.equalTo(self);
                    make.right.equalTo(self);
                }];
            }else{
                UIButton *buttonTwo = _arrayBtns[1];//第二个
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self);
                    make.top.and.bottom.equalTo(self);
                    make.width.equalTo(buttonTwo.mas_width);
                }];
            }
            
            //设置滑块约束
            [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self);
                make.left.and.right.equalTo(button);
            }];
            
        }else{
            //约束
            UIButton *buttonUp = _arrayBtns[i - 1];//上一个
            
            if (i == _arrayBtns.count - 1) {
                //最后一个
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(buttonUp.mas_right);
                    make.top.bottom.and.width.equalTo(buttonFirst);
                    make.right.equalTo(self);
                }];
            }else{
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(buttonUp.mas_right);
                    make.top.bottom.and.width.equalTo(buttonFirst);
                }];
            }
        }
        
        //添加分割线
        if (i != _arrayBtns.count -1) {
            //不是最后一个 添加分割线
            UIView *lineSe = [[UIView alloc] init];
            lineSe.backgroundColor = _tintColor;
            [button addSubview:lineSe];
            [lineSe mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.and.bottom.equalTo(button);
                make.width.mas_equalTo(1);
            }];
            
            [_arrayLines addObject:lineSe];
        }
    }
}

#pragma mark - 点击按钮事件
- (void)onClickBtutton:(UIButton *)button{
    
    [self setNormalButtonStyle:_btnSelect];
    
    _btnSelect = button;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self->_backView.frame = CGRectMake(button.gf_X, button.gf_Y, button.gf_Width, button.gf_Height);
        
    } completion:^(BOOL finished) {
        
        [self setSelectButtonStyle:self->_btnSelect];//设置选中样式
    }];
    
    //进行回调
    if (self.delegate) {
        [self.delegate segmentControlDidChangeValue:button.tag - 1000];
    }
}

#pragma mark - 设置按钮 样式 ——> 选中 && 未选中默认
///设置选中按钮样式
- (void)setSelectButtonStyle:(UIButton *)button{
    
    if (_dicSelectAtr) {
        
        button.titleLabel.font = _dicSelectAtr[NSFontAttributeName];
        
        [button setTitleColor:_dicSelectAtr[NSForegroundColorAttributeName] forState:UIControlStateNormal];
    }else{
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

///设置未选中按钮样式
- (void)setNormalButtonStyle:(UIButton *)button{
    
    if (_dicNormalAtr) {
        //@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}
        
        button.titleLabel.font = _dicNormalAtr[NSFontAttributeName];
        
        [button setTitleColor:_dicNormalAtr[NSForegroundColorAttributeName] forState:UIControlStateNormal];
    }else{
        
        [button setTitleColor:_tintColor forState:UIControlStateNormal];
    }
}

///设置tintColor方法重写
- (void)setTintColor:(UIColor *)tintColor{
    
    _tintColor = tintColor;
    
    //默认按钮
    if (!_dicNormalAtr) {
        for (UIButton *button in _arrayBtns) {
            if (_btnSelect != button) {
                [self setNormalButtonStyle:button];
            }
        }
    }
    
    //分割线
    for (UIView *lineS in _arrayLines) {
        lineS.backgroundColor = _tintColor;
    }
    
    //滑动颜色块
    _backView.backgroundColor = _tintColor;
}

///设置选中位置
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex{
    if (_arrayBtns.count > 0 && selectedSegmentIndex < _arrayBtns.count) {
        
        [self setNormalButtonStyle:_btnSelect];//之前选中恢复原样
        
        UIButton *button = _arrayBtns[selectedSegmentIndex];
        
        _btnSelect = button;
        
        if (self.frame.size.width) {
            //页面已显示出来
            [UIView animateWithDuration:0.2 animations:^{
                
                self->_backView.frame = CGRectMake(button.gf_X, button.gf_Y, button.gf_Width, button.gf_Height);
                
            } completion:^(BOOL finished) {
                
                [self setSelectButtonStyle:self->_btnSelect];//设置选中样式
            }];
            
        }else{
            [self setSelectButtonStyle:_btnSelect];//设置选中样式
            
            [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self);
                make.left.and.right.equalTo(button);
            }];
        }
        
    }
    
    _selectedSegmentIndex = selectedSegmentIndex;
}

///选中某个按钮
- (void)selectedSegmentAtIndex:(NSUInteger)segment animation:(BOOL)animation{
    
    if (_arrayBtns.count > 0 && segment < _arrayBtns.count) {
        
        if (self.frame.size.width && animation) {
            
            //页面已出来
            [self setNormalButtonStyle:_btnSelect];//之前选中恢复原样
            
            UIButton *button = _arrayBtns[segment];
            
            _btnSelect = button;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self->_backView.frame = CGRectMake(button.gf_X, button.gf_Y, button.gf_Width, button.gf_Height);
                
            } completion:^(BOOL finished) {
                
                [self setSelectButtonStyle:self->_btnSelect];//设置选中样式
            }];
            
        }else{
            
            self.selectedSegmentIndex = segment;
        }
    }
}

#pragma mark - 设置某个按钮 文字标题 && 图片

///更新设置第某个标题
- (void)setTitle:(nullable NSString *)title forSegmentAtIndex:(NSUInteger)segment{
    
    if (_arrayBtns.count > 0 && segment < _arrayBtns.count) {
        
        UIButton *button = _arrayBtns[segment];
        [button setTitle:title forState:UIControlStateNormal];
    }
}

///获取第某个按钮标题
- (nullable NSString *)titleForSegmentAtIndex:(NSUInteger)segment{
    NSString *title;
    
    if (_arrayBtns.count > 0 && segment < _arrayBtns.count) {
        
        UIButton *button = _arrayBtns[segment];
        
        title =  button.currentTitle;
    }
    
    return title;
}

///更新设置第某个按钮图片
- (void)setImage:(nullable UIImage *)image forSegmentAtIndex:(NSUInteger)segment{
    
    if (_arrayBtns.count > 0 && segment < _arrayBtns.count) {
        
        UIButton *button = _arrayBtns[segment];
        [button setImage:image forState:UIControlStateNormal];
    }
}

///获取第某个按钮图片
- (nullable UIImage *)imageForSegmentAtIndex:(NSUInteger)segment{
    UIImage *image;
    
    if (_arrayBtns.count > 0 && segment < _arrayBtns.count) {
        
        UIButton *button = _arrayBtns[segment];
        
        image =  button.currentImage;
    }
    
    return image;
}

///设置按钮不同状态的文字显示样式
- (void)setTitleTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes forState:(UIControlState)state{
    
    if (state == UIControlStateNormal) {
        
        //默认 @{NSFontAttributeName:font,NSForegroundColorAttributeName:color}
        _dicNormalAtr = attributes;
        
        for (UIButton *button in _arrayBtns) {
            
            if (_btnSelect != button) {
                [self setNormalButtonStyle:button];
            }
        }
    }else{
        
        _dicSelectAtr = attributes;
        
        [self setSelectButtonStyle:_btnSelect];
    }
}


@end
