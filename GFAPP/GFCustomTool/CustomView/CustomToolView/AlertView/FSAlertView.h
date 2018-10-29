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


///弹出来
- (void)showAlertWithTitle:(NSString *)title withBlock:(GFBackBlock)block;


///隐藏
- (void)hideAlert;



@end
