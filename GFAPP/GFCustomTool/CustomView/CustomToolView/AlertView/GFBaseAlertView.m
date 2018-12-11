//
//  GFBaseAlertView.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/17.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFBaseAlertView.h"

@implementation GFBaseAlertView
{
    //添加自视图
}


+ (GFBaseAlertView *)initWithBackViewWidth:(CGFloat)bvWidth bvHeight:(CGFloat)bvHeight selfWidth:(CGFloat)width selfHeight:(CGFloat)height{
    
    GFBaseAlertView *alertView = [[GFBaseAlertView alloc] init];
    
    alertView.bvWidth = bvWidth;
    alertView.bvHeight = bvHeight;
    alertView.sWidth = width;
    alertView.sHeight = height;
    
    return alertView;
}


#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if ([super init]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.backView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.frame = CGRectMake(0, _sHeight, _bvWidth, _bvHeight);
        [self addSubview:self.backView];
        [self createView];
    }
    return self;
}


//创建视图 && 必须都贴在backView上
- (void)createView{
    
    //添加其他的视图
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideAlertView];
}


#pragma mark - 赋值 && 处理数据
///展示弹框
+ (void)showTipAlertViewWithArray:(NSArray *)arrayModel tipFrame:(CGRect)frame block:(APPBackBlock)block{
    
    //小费视图
    GFBaseAlertView *alertView = [[GFBaseAlertView alloc] init];
    alertView.frame = frame;
    alertView.clipsToBounds = YES;
    alertView.blockHandle = block;
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
    
    [alertView setModelData:arrayModel];
}

///赋值数据
- (void)setModelData:(NSArray *)modelArray{
    
    
    [self showAlertView];
}


#pragma mark - 点击确定按钮
- (void)onClickBtnOk{
    
    if (self.blockHandle) {
        self.blockHandle(YES, nil);
    }
}

#pragma mark - 弹出 && 隐藏
///弹出
- (void)showAlertView{
    
    self.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.frame = CGRectMake(0, self.sHeight - self.bvHeight, self.bvWidth, self.bvHeight);
    } completion:^(BOOL finished) {
        
    }];
}

///隐藏
- (void)hideAlertView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.frame = CGRectMake(0, self.sHeight, self.bvWidth, self.bvHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
}






@end
