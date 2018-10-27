//
//  VariableRoundedBorderLabel.h
//  kkkk
//
//  Created by gaoyafeng on 2018/10/24.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VariableRoundedBorderView.h"


NS_ASSUME_NONNULL_BEGIN

@interface VariableRoundedBorderLabel : UILabel

@property(nonatomic,unsafe_unretained)IBInspectable BorderDirection BD;//需要显示边框的方向  等于0时，什么方向都不画
@property(nonatomic,unsafe_unretained)IBInspectable UIRectCorner corners;//需要设置圆角的方向 等于0时，什么方向都不画
@property(nonatomic,unsafe_unretained)IBInspectable CGFloat radius;//圆角角度
@property(nonatomic,unsafe_unretained)IBInspectable CGFloat borderWidth;//边框宽度
@property(nonatomic,strong)IBInspectable UIColor *borderColor;//边框颜色



@end

NS_ASSUME_NONNULL_END

/**

//UIView *backView = [[UIView alloc] init];
UILabel *backView = [[UILabel alloc] init];
backView.text = @"哈哈哈哈哈";

backView.frame = CGRectMake(50, 100, 100, 50);
//1.
//backView.layer.cornerRadius = 10;

backView.backgroundColor = [UIColor redColor];

[self.view addSubview:backView];

//2.
//设置所需的圆角位置以及大小
UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
maskPath.lineWidth = 10;

CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
maskLayer.frame = backView.bounds;
maskLayer.path = maskPath.CGPath;
backView.layer.mask = maskLayer;

//3.设置边框
//    backView.layer.cornerRadius = 10;
//    backView.layer.borderWidth = 3;
//    backView.layer.borderColor = [UIColor blueColor].CGColor;

//4.不适合全边框
//    backView.borderWidth = 3;
//    backView.radius = 10;
//    backView.BD = BorderDirectionTop | BorderDirectionLeft | BorderDirectionBottom | BorderDirectionRight;
//    backView.corners = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;


*/
