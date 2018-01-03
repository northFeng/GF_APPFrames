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





@end
