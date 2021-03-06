//
//  GFBaseAlertView.h
//  GFAPP
//  弹框基类视图
//  Created by gaoyafeng on 2018/9/17.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFBaseAlertView : UIView

///底部视图
@property (nonatomic,strong) UIButton *backView;

///bvWidth
@property (nonatomic,assign) CGFloat bvWidth;

///bvHeight
@property (nonatomic,assign) CGFloat bvHeight;

///width
@property (nonatomic,assign) CGFloat sWidth;

///height
@property (nonatomic,assign) CGFloat sHeight;

///回调
@property (nonatomic,copy,nullable) APPBackBlock blockHandle;


/**
 *  @brief 创建视图
 *
 *  @param bvWidth backView的宽
 *  @param bvHeight backView的高
 *  @param width self的宽
 *  @param height self的高
 *  @return GFBaseAlertView
 */
+ (GFBaseAlertView *)initWithBackViewWidth:(CGFloat)bvWidth bvHeight:(CGFloat)bvHeight selfWidth:(CGFloat)width selfHeight:(CGFloat)height;



///展示弹框
+ (void)showTipAlertViewWithArray:(NSArray *)arrayModel tipFrame:(CGRect)frame block:(APPBackBlock)block;


///赋值数据
- (void)setModelData:(NSArray *)modelArray;


///弹出
- (void)showAlertView;


///隐藏
- (void)hideAlertView;



@end
