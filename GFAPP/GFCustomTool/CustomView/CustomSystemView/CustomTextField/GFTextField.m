//
//  GFTextField.m
//  GFAPP
//
//  Created by XinKun on 2018/1/3.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFTextField.h"

@implementation GFTextField
{
    NSMutableArray *_arrayView;
    
    NSInteger _oldtextLength;
    
    GFLineTF *_lineS;//自定义闪线
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    if ([super init]) {
        [self addObserverToLimitStringLength];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
       [self addObserverToLimitStringLength];
    }
    return self;
}

///限制输入文字长度
- (void)addObserverToLimitStringLength{
    
    _oldtextLength = 0;
    _isPhoneType = NO;
    _isShowMenuAction = YES;
    
    //设置默认属性
    [self setTextFieldType:GFTFType_Default];
    
    //这两种都可以进行输入框的监听
    //[_tfPhone addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self];
    
}

#pragma mark - 输入字数变化对输入做入限制
///文字输入调动方法
- (void)textFiledEditChanged:(NSNotification *)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    NSString *toBeString = textField.text;
    NSString *lang = textField.textInputMode.primaryLanguage;//[[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _limitStringLength) {
                textField.text = [toBeString substringToIndex:_limitStringLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    }else{
        if (toBeString.length > _limitStringLength) {
            textField.text = [toBeString substringToIndex:_limitStringLength];
        }
    }
    
    //电话类型
    if (_isPhoneType) {
        
        //判断在输入还是删除
        if (_oldtextLength < textField.text.length) {
            //输入字符
//            if (textField.text.length == 3 || _oldtextLength == 3) {
//                if (_oldtextLength == 3) {
//                    textField.text = [NSString stringWithFormat:@"%@ %@",[textField.text substringToIndex:3],[textField.text substringFromIndex:3]];
//                }else{
//                    textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
//                }
//            }else if (textField.text.length == 8 || _oldtextLength == 8){
//                if (_oldtextLength == 8) {
//                    textField.text = [NSString stringWithFormat:@"%@ %@",[textField.text substringToIndex:8],[textField.text substringFromIndex:8]];
//                }else{
//                    textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
//                }
//            }
            if (textField.text.length == 3 || textField.text.length == 8) {
                textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
            }else if (_oldtextLength == 3 || _oldtextLength == 8){
                textField.text = [NSString stringWithFormat:@"%@ %@",[textField.text substringToIndex:_oldtextLength],[textField.text substringFromIndex:_oldtextLength]];
            }
        }else if (_oldtextLength > textField.text.length){
            //删除字符
            if (textField.text.length == 4) {
                textField.text = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:3]];
            }else if (textField.text.length == 9){
                textField.text = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:8]];
            }
        }
        _oldtextLength = textField.text.length;
    }
    
    //处理密文显示
    if (_arrayView && _arrayView.count == _limitStringLength) {
        
        for (UIView *backView in _arrayView) {
            //控制显示与隐藏
            NSInteger index = backView.tag - 1000;
            if (index < textField.text.length) {
                //要显示的
                backView.hidden = NO;
                
                if (self.textFieldType == GFTFType_Clear) {
                    //明文要赋值
                    UILabel *label = (UILabel *)backView;
                    label.text = [textField.text substringWithRange:NSMakeRange(index, 1)];
                }else{
                    backView.hidden = NO;
                }
                
            }else{
                //backView.hidden = YES;
                if (self.textFieldType == GFTFType_Clear) {
                    UILabel *label = (UILabel *)backView;
                    label.text = @"";
                }else{
                    backView.hidden = YES;
                }
            }
        }
        
        //控制竖线闪烁
        if (_lineS) {
            if (textField.text.length >= _limitStringLength) {
                //填满
                [_lineS stopFlashAndHide];
            }else{
                UIView *backView = [_arrayView gf_getItemWithIndex:textField.text.length];
                _lineS.center = CGPointMake(backView.center.x, backView.center.y);
                
                [_lineS startFlash];
            }
        }
    }
    
}


#pragma mark - 密码输入
- (void)switchToPasswordStyleWithBorderColor:(UIColor *)borderColor passwordType:(GFTFType)type{
    
    [self setTextFieldType:type];
    
    if (type == GFTFType_Default) return ;
    
    //初始化数据
    _arrayView = [NSMutableArray array];
    
    //设置外边框的样式
    self.borderStyle = UITextBorderStyleNone;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1;
    self.tintColor = [UIColor clearColor];
    self.textColor = [UIColor clearColor];
    
    CGFloat widthSpace = self.frame.size.width / _limitStringLength;
    CGFloat height = self.frame.size.height;

    for (int i = 0; i < _limitStringLength ; i++) {
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = borderColor;
        //改变竖条的大小
        line.frame = CGRectMake((widthSpace - 1) + (widthSpace + 1)*i, 1.5, 1, height - 3);
        if (i != _limitStringLength - 1) {
            //最后一条线不加
            [self addSubview:line];
        }
        
        if (type == GFTFType_Cipher) {
            //密文
            UIView *backView = [[UIView alloc] init];
            backView.backgroundColor = [UIColor blackColor];
            backView.frame = CGRectMake(0, 0, 10, 10);
            backView.center = CGPointMake(widthSpace/2.+widthSpace*i, height/2.);
            //设置小圆点大小
            backView.layer.cornerRadius = 5;
            backView.layer.masksToBounds = YES;
            [self addSubview:backView];
            backView.hidden = YES;//隐藏
            backView.tag = 1000 + i;
            [_arrayView addObject:backView];
        }else if (type == GFTFType_Clear){
            //明文
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            //改变label的frame
            label.frame = CGRectMake(0, 0, widthSpace - 4, height - 4);
            label.center = CGPointMake(widthSpace/2. + widthSpace*i, height/2.);
            [self addSubview:label];
            label.hidden = YES;
            label.tag = 1000 + i;
            [_arrayView addObject:label];
        }
        
    }
    
}

///转换成密码框输入 ——方法2 带闪动竖线
- (void)switchToPasswordStyleWithBorderColor:(UIColor *)borderColor squareSize:(CGSize)squareSize squareSpace:(CGFloat)squareSpace lineColor:(UIColor *)lineColor passwordType:(GFTFType)type{
    
    [self setTextFieldType:type];
    
    if (type == GFTFType_Default) return ;
    
    //初始化数据
    _arrayView = [NSMutableArray array];
    
    //设置外边框的样式
    self.borderStyle = UITextBorderStyleNone;
    //    self.layer.borderColor = borderColor.CGColor;
    //    self.layer.borderWidth = 1;
    self.tintColor = [UIColor clearColor];
    self.textColor = [UIColor clearColor];
    
    CGFloat widthSpace = squareSize.width;
    CGFloat height = squareSize.height;
    
    for (int i = 0; i < _limitStringLength ; i++) {
        
        if (type == GFTFType_Cipher) {
            //密文
            UIView *backView = [[UIView alloc] init];
            backView.backgroundColor = [UIColor blackColor];
            backView.frame = CGRectMake(0, 0, 10, 10);
            backView.center = CGPointMake(widthSpace/2.+(widthSpace + squareSpace)*i, height/2.);
            //设置小圆点大小
            backView.layer.cornerRadius = 5;
            backView.layer.masksToBounds = YES;
            [self addSubview:backView];
            backView.hidden = YES;//隐藏
            backView.tag = 1000 + i;
            [_arrayView addObject:backView];
        }else if (type == GFTFType_Clear){
            //明文
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:36];
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            //改变label的frame
            label.frame = CGRectMake(0, 0, widthSpace, height);
            label.center = CGPointMake(widthSpace/2. + (widthSpace + squareSpace)*i, height/2.);
            [self addSubview:label];
            //label.hidden = YES;
            label.tag = 1000 + i;
            label.layer.cornerRadius = 2;
            label.layer.masksToBounds = YES;
            label.layer.borderWidth = 1;
            label.layer.borderColor = borderColor.CGColor;
            [_arrayView addObject:label];
        }
    }
    
    //添加闪烁线
    _lineS = [[GFLineTF alloc] init];
    _lineS.backgroundColor = lineColor;
    _lineS.frame = CGRectMake(0, 0, 2, 24);
    _lineS.center = CGPointMake(widthSpace/2., height/2.);
    [self addSubview:_lineS];
}

#pragma mark - ************************ 设置输入框各个属性 ********************
#pragma mark - 设置占位文字的颜色
- (void)setPlaceholderTextColor:(UIColor *)placeholderColor{
    
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

///设置占位文字属性
- (void)setPlaceholderTextColor:(UIColor *)placeholderColor textFont:(UIFont *)placeholderFont{
    
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

#pragma mark - 设置清楚按钮的图片
- (void)setCleatBtnImageWith:(UIImage *)image{
    
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    //[clearButton setImage:[UIImage imageNamed:@"delDefault"] forState:UIControlStateNormal];
    [clearButton setImage:image forState:UIControlStateNormal];
    //self.clearButtonMode = UITextFieldViewModeWhileEditing;
}


/**
 // 重写这个方法是为了使Placeholder居中，如果不写会出现类似于下图中的效果，文字稍微偏上了一些
 - (void)drawPlaceholderInRect:(CGRect)rect {
 [super drawPlaceholderInRect:CGRectMake(0, self.frame.size.height * 0.5 + 1, 0, 0)];
 }
 // 更改placeHolder的位置
 - (CGRect)placeholderRectForBounds:(CGRect)bounds
 {
 // textSize:placeholder字符串size
 CGRect inset = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
 return inset;
 }
 */

/** 重写这些方法可以修改输入框上的显示的样式
 // drawing and positioning overrides
 
 - (CGRect)borderRectForBounds:(CGRect)bounds;
 - (CGRect)textRectForBounds:(CGRect)bounds;
 - (CGRect)placeholderRectForBounds:(CGRect)bounds;
 - (CGRect)editingRectForBounds:(CGRect)bounds;
 - (CGRect)clearButtonRectForBounds:(CGRect)bounds;
 - (CGRect)leftViewRectForBounds:(CGRect)bounds;
 - (CGRect)rightViewRectForBounds:(CGRect)bounds;
 
 - (void)drawTextInRect:(CGRect)rect;
 - (void)drawPlaceholderInRect:(CGRect)rect;


// 未输入时文本的位置，向右缩进10
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}
// 输入后文本的位置，向右缩进10
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}
 
 */


//禁止复制粘帖
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (_isShowMenuAction) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if(menuController){
            menuController.menuVisible = NO;
        }
        //控制显示的菜单
        if (action == @selector(copy:) || action == @selector(paste:)) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

///粘贴代理
- (void)paste:(nullable id)sender{
    [super paste:sender];
    
    [self performSelector:@selector(posted) withObject:nil afterDelay:0.05];
}

///菜单弹框隐藏触发
- (void)posted{
    
    if (self.isPhoneType) {
        //电话类型
        if (self.text.length >= 11) {
            
            NSMutableString *phoneStr = [[NSMutableString alloc] init];
            [phoneStr appendFormat:@"%@",[self.text substringWithRange:NSMakeRange(0, 3)]];
            [phoneStr appendFormat:@" %@",[self.text substringWithRange:NSMakeRange(3, 4)]];
            [phoneStr appendFormat:@" %@",[self.text substringWithRange:NSMakeRange(7, 4)]];
            
            self.text = phoneStr;
        }
    }
}

- (void)setTextFieldType:(GFTFType)textFieldType{
    _textFieldType = textFieldType;
}



@end


#pragma mark - *************** 自定义输入框闪动竖线 ********************
@implementation GFLineTF
{
    BOOL _isHide;
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if ([super init]) {
        
        self.backgroundColor = [UIColor blueColor];//默认蓝色
        
        self->_isHide = NO;
        
        self.hidden = NO;
        
        [self constantlyFlashing];
    }
    return self;
}


///不停闪烁
- (void)constantlyFlashing{
    
    if (!_isHide) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.hidden = !self.hidden;
            
        } completion:^(BOOL finished) {
            
            [self performSelector:@selector(constantlyFlashing) withObject:nil afterDelay:0.5];
        }];
    }
}


///隐藏 && 停止闪烁
- (void)stopFlashAndHide{
    
    if (!_isHide) {
        
        _isHide = YES;
        self.hidden = YES;
    }
}

///开始闪烁
- (void)startFlash{
    
    if (_isHide) {
        _isHide = NO;
        self.hidden = NO;
        [self constantlyFlashing];
    }
}



@end

