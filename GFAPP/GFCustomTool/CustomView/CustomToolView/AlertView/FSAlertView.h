//
//  FSAlertView.h
//  FlashSend
//  APP内自定义确定提示框
//  Created by gaoyafeng on 2018/9/7.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSAlertView : UIView

@property (nonatomic,strong) UIView *backView;


///样式一（默认标题和按钮演示）
- (void)showAlertWithTitle:(NSString *)title withBlock:(GFBackBlock)block;

///样式二（自定义标题）
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif withBlock:(GFBackBlock)block;

///样式三（自定义标题，按钮显示）
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif leftBtnTitle:(NSString *)cancleTitle rightBtnTitle:(NSString *)okTitle withBlock:(GFBackBlock)block;


///隐藏
- (void)hideAlert;



@end
