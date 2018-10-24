//
//  GFButton.h
//  GFAPP
//  自定义按钮（图片和文字）
//  Created by XinKun on 2017/11/27.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  按钮布局类型
 */
typedef NS_ENUM(NSInteger,GFButtonType) {
    /**
     * 文字和图片是水平方向(左边文字，右边图片)
     */
    GFButtonType_Horizontal_TextImg = 0,
    /**
     * 文字和图片是水平方向(左边图片，右边文字)
     */
    GFButtonType_Horizontal_ImgText,
    /**
     * 文字和图片是竖直方向(上边文字，下边图片)
     */
    GFButtonType_Vertical_TextImg,
    /**
     * 文字和图片是竖直方向(上边图片，下边文字)
     */
    GFButtonType_Vertical_ImgText,
};

@interface GFButton : UIButton

///默认文字颜色
@property (nonatomic,strong) UIColor *defaultColor;

///选中颜色
@property (nonatomic,strong) UIColor *selectColor;

///默认图片
@property (nonatomic,strong) UIImage *defaultImage;

///选中图片
@property (nonatomic,strong) UIImage *selectImage;


/**
 *  @brief 创建图文按钮
 *
 *  @param title 按钮文字
 *  @param labelSize 文字label显示尺寸大小
 *  @param textFont  字体大小
 *  @param textColor 文字颜色
 *
 *  @param imgStr 图片文字
 *  @param imgSize 图片显示尺寸大小
 *
 *  @param buttonType 按钮类型
 *  @param spacing 文字和图片之间的间隔
 */
- (void)setTitle:(NSString *)title labelSize:(CGSize)labelSize labelFont:(UIFont *)textFont textColor:(UIColor *)textColor imageName:(NSString *)imgStr imgSize:(CGSize)imgSize viewDirection:(GFButtonType)buttonType spacing:(CGFloat)spacing;


///更新文字
- (void)setNewTitle:(NSString *)title;

//更新文字2
- (void)setNewTitle:(NSString *)title textAlignment:(NSTextAlignment)textAlignment;


///更新文字和图片
- (void)setTextColor:(UIColor *)textColor newImg:(NSString *)imgStr;


///更新文字和图片
- (void)setNewTitle:(NSString *)title textColor:(UIColor *)textColor newImg:(NSString *)imgStr;


///设置默认
- (void)setDefaultStyle;

///设置选中
- (void)setSelectStyle;


@end


/*
GFButton *btn = [GFButton buttonWithType:0];
[btn setTitle:@"你好" labelSize:CGSizeMake(40, 16) labelFont:15 textColor:[UIColor redColor] imageName:@"ic_1_1" imgSize:CGSizeMake(40, 40) viewDirection:GFButtonType_Vertical_ImgText spacing:4];
btn.backgroundColor = [UIColor grayColor];
[self.view addSubview:btn];

[btn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.equalTo(self.view).offset(200);
    make.width.and.height.mas_equalTo(100);
}];
 
 */
