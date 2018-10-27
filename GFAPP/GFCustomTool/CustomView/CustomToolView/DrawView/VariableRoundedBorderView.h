//
//  VariableRoundedBorderView.h
//  kkkk
//
//  Created by gaoyafeng on 2018/10/24.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_OPTIONS(NSUInteger, BorderDirection) {//需要显示的边框方向
    BorderDirectionLeft     = 1 << 0,
    BorderDirectionRight    = 1 << 1,
    BorderDirectionBottom  = 1 << 2,
    BorderDirectionTop = 1 << 3,
    BorderDirectionAllCorners  = ~0UL
};


@interface VariableRoundedBorderView : UIView

@property(nonatomic,unsafe_unretained)IBInspectable BorderDirection BD;//需要显示边框的方向  等于0时，什么方向都不画
@property(nonatomic,unsafe_unretained)IBInspectable UIRectCorner corners;//需要设置圆角的方向 等于0时，什么方向都不画
@property(nonatomic,unsafe_unretained)IBInspectable CGFloat radius;//圆角角度
@property(nonatomic,unsafe_unretained)IBInspectable CGFloat borderWidth;//边框宽度
@property(nonatomic,strong)IBInspectable UIColor *borderColor;//边框颜色

+(void)setVariableRoundedBorder:(CGRect)rect view:(UIView *)view  BD:(BorderDirection)BD corners:(UIRectCorner)corners radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end

NS_ASSUME_NONNULL_END
