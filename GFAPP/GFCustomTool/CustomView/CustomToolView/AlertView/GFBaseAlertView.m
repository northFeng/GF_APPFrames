//
//  GFBaseAlertView.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/17.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFBaseAlertView.h"

@implementation GFBaseAlertView


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
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sHeight, _bvWidth, _bvHeight)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backView];
        [self createView];
    }
    return self;
}


//创建视图 && 必须都贴在backView上
- (void)createView{
    
    
    
}



///弹出
- (void)showAlertViewOnWindow:(UIViewController *)superVC{
    
    self.hidden = NO;
    [superVC.view.window addSubview:self];
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
