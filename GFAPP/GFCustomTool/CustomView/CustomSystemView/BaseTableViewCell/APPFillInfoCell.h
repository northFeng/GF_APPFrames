//
//  APPFillInfoCell.h
//  FlashSend
//  带输入框cell
//  Created by gaoyafeng on 2019/4/1.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GFTextField.h"

@class APPFillCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface APPFillInfoCell : UITableViewCell <UITextFieldDelegate>

///model
@property (nonatomic,strong,nullable) APPFillCellModel *model;

///backView
@property (nonatomic,strong,nullable) UIView *backView;

///左边icon
@property (nonatomic,strong,nullable) UIImageView *imgLeft;

///左边标题
@property (nonatomic,strong,nullable) UILabel *labelLeft;

///输入框
@property (nonatomic,strong,nullable) GFTextField *tfInfo;

///右边箭头
@property (nonatomic,strong,nullable) UIImageView *imgRight;

///下划线
@property (nonatomic,strong,nullable) UIView *lineBottom;

///赋值
- (void)setCellModel:(APPFillCellModel *)model;


@end

@interface APPFillCellModel : NSObject

///左图标
@property (nonatomic,copy,nullable) NSString *leftImg;

///左标题
@property (nonatomic,copy,nullable) NSString *leftTitle;

///右占位文字
@property (nonatomic,copy,nullable) NSString *rightPlaceholderStr;

///右数据文字
@property (nonatomic,copy,nullable) NSString *rightTitle;

///键盘类型 UIKeyboardTypeNumberPad & UIKeyboardTypeDefault
@property (nonatomic,assign) UIKeyboardType keyboardType;

///输入框限制长度
@property (nonatomic,assign) NSInteger limitStringLength;

///右边按钮
@property (nonatomic,copy,nullable) NSString *rightImg;

///是否隐藏左边图标
@property (nonatomic,assign) BOOL hideLeftImg;

///输入框是否可以编辑
@property (nonatomic,assign) BOOL isEdit;

///是否隐藏右边按钮
@property (nonatomic,assign) BOOL hideRightImg;

///圆角位置 (UIRectCornerTopLeft | UIRectCornerTopRight)上圆角 (UIRectCornerBottomLeft | UIRectCornerBottomRight)下圆角
@property (nonatomic,assign) UIRectCorner cornerIndex;

///是否显示下划线你
@property (nonatomic,assign) BOOL hideLineBottom;

///创建model
+ (APPFillCellModel *)createOneModelWithLeftImg:(NSString *)leftImg leftTitle:(NSString *)leftTitle rightplaceStr:(NSString *)rightPlaceStr rightTitle:(NSString *)rightTitle hideLeftImg:(BOOL)hideLeftImg canEdit:(BOOL)canEdit hideRightImg:(BOOL)hideRightImg cornerIndex:(UIRectCorner)cornerIndex hideLineBottom:(BOOL)hideLineH;


@end

NS_ASSUME_NONNULL_END
