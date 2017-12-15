//
//  GFButton.m
//  GFAPP
//
//  Created by XinKun on 2017/11/27.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFButton.h"

@implementation GFButton
{
    UIView *_backView;
    
    ///文字label
    UILabel *_label;
    
    ///图片
    UIImageView *_imgeView;

}


- (void)setTitle:(NSString *)title labelSize:(CGSize)labelSize labelFont:(CGFloat)textFont textColor:(UIColor *)textColor imageName:(NSString *)imgStr imgSize:(CGSize)imgSize viewDirection:(GFButtonType)buttonType spacing:(CGFloat)spacing{
    
    _backView = [[UIView alloc] init];
    _backView.userInteractionEnabled = NO;
    _backView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backView];
    
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = textColor;
    _label.font = [UIFont systemFontOfSize:textFont];
    _label.text = title;
    [_backView addSubview:_label];
    
    _imgeView = [[UIImageView alloc] init];
    _imgeView.backgroundColor = [UIColor clearColor];
    _imgeView.image = [UIImage imageNamed:imgStr];
    [_backView addSubview:_imgeView];
    
    CGFloat totalWidht = 0;
    CGFloat totalHeight = 0;
    switch (buttonType) {
        case GFButtonType_Horizontal_TextImg:{
            //文字+图片
            _label.textAlignment = NSTextAlignmentRight;
            totalWidht = labelSize.width + imgSize.width + spacing;
            totalHeight = labelSize.height > imgSize.height ? labelSize.height : imgSize.height;
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.centerY.equalTo(_backView);
                make.size.mas_equalTo(labelSize);
            }];
            [_imgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.and.centerY.equalTo(_backView);
                make.size.mas_equalTo(imgSize);
            }];
        }
            break;
        case GFButtonType_Horizontal_ImgText:{
            //图片+文字
            _label.textAlignment = NSTextAlignmentLeft;
            totalWidht = labelSize.width + imgSize.width + spacing;
            totalHeight = labelSize.height > imgSize.height ? labelSize.height : imgSize.height;
            [_imgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.centerY.equalTo(_backView);
                make.size.mas_equalTo(imgSize);
            }];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.and.centerY.equalTo(_backView);
                make.size.mas_equalTo(labelSize);
            }];
        }
            break;
        case GFButtonType_Vertical_TextImg:{
            //文字+图片
            _label.textAlignment = NSTextAlignmentCenter;
            totalWidht = labelSize.width > imgSize.width ? labelSize.width : imgSize.width;
            totalHeight = labelSize.height + imgSize.height + spacing;
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.centerX.equalTo(_backView);
                make.size.mas_equalTo(imgSize);
            }];
            [_imgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.centerX.equalTo(_backView);
                make.size.mas_equalTo(labelSize);
            }];
        }
            break;
        case GFButtonType_Vertical_ImgText:{
            //图片+文字
            _label.textAlignment = NSTextAlignmentCenter;
            totalWidht = labelSize.width > imgSize.width ? labelSize.width : imgSize.width;
            totalHeight = labelSize.height + imgSize.height + spacing;
            [_imgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.centerX.equalTo(_backView);
                make.size.mas_equalTo(imgSize);
            }];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.centerX.equalTo(_backView);
                make.size.mas_equalTo(labelSize);
            }];
        }
            break;
        default:
            break;
    }
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(totalWidht);
        make.height.mas_equalTo(totalHeight);
    }];
        
}


//更新文字
- (void)setNewTitle:(NSString *)title{
    
    _label.text = title;
    
}

//更新文字和图片
- (void)setTextColor:(UIColor *)textColor newImg:(NSString *)imgStr{
    
    _label.textColor = textColor;
    
    _imgeView.image = [UIImage imageNamed:imgStr];
    
}


//更新文字和图片
- (void)setNewTitle:(NSString *)title textColor:(UIColor *)textColor newImg:(NSString *)imgStr{
    
    if (title != nil) {
        _label.text = title;
    }
    _label.textColor = textColor;
    
    _imgeView.image = [UIImage imageNamed:imgStr];
    
}

//设置默认
- (void)setDefaultStyle{
    
    if (self.defaultColor!=nil) {
        _label.textColor = self.defaultColor;
    }
    if (self.defaultImage!=nil) {
        _imgeView.image = self.defaultImage;
    }
}

//设置选中
- (void)setSelectStyle{
    
    if (self.selectColor!=nil) {
        _label.textColor = self.selectColor;
    }
    if (self.selectImage!=nil) {
        _imgeView.image = self.selectImage;
    }
}



@end
