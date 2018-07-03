//
//  GFTextField.m
//  GFAPP
//
//  Created by XinKun on 2018/1/3.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFTextField.h"

@implementation GFTextField
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
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > _limitStringLength) {
            textField.text = [toBeString substringToIndex:_limitStringLength];
        }
    }
    
}


#pragma mark - 设置占位文字的颜色
- (void)setPlaceholderTextColor:(UIColor *)placeholderColor{
    
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
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
 */


//禁止复制粘帖
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if(menuController){
        menuController.menuVisible = NO;
    }
    return NO;
}





@end
