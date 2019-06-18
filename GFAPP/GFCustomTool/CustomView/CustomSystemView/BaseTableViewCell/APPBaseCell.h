//
//  APPBaseCell.h
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/22.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APPBaseCellModel;

//BaseCell代理
@protocol APPBaseCellDelegate <NSObject>

- (void)actionCellButtonName:(NSString *_Nullable)buttonName cellIndex:(NSIndexPath *_Nullable)indexPath withObject:(id _Nullable )object;

@end

NS_ASSUME_NONNULL_BEGIN

@interface APPBaseCell : UITableViewCell

///代理指针
@property (nonatomic,weak,nullable) id <GFNavigationBarViewDelegate> delegate;

///backView
@property (nonatomic,strong,nullable) UIView *backView;

///左边图片
@property (nonatomic,strong,nullable) UIImageView *imgLeft;

///左边label
@property (nonatomic,strong,nullable) UILabel *labelLeft;

///右边图片
@property (nonatomic,strong,nullable) UIImageView *imgRight;

///右边label
@property (nonatomic,strong,nullable) UILabel *labelRight;

///分割线
@property (nonatomic,strong,nullable) UIView *lineBottom;

///占位文字属性
@property (nonatomic,copy,nullable) NSDictionary *dicTextAttrPlace;

///显示文字属性
@property (nonatomic,copy,nullable) NSDictionary *dicTextAttr;

///赋值
- (void)setCellModel:(APPBaseCellModel *)model;


@end


///model
@interface APPBaseCellModel : NSObject

///左图标
@property (nonatomic,copy,nullable) NSString *leftImg;

///左标题
@property (nonatomic,copy,nullable) NSString *leftTitle;

///右占位文字
@property (nonatomic,copy,nullable) NSString *rightPlaceholderStr;

///右数据文字
@property (nonatomic,copy,nullable) NSString *rightTitle;

///右边按钮
@property (nonatomic,copy,nullable) NSString *rightImg;

///是否隐藏左边图标
@property (nonatomic,assign) BOOL hideLeftImg;

///是否隐藏右边按钮
@property (nonatomic,assign) BOOL hideRightImg;

///圆角位置 (UIRectCornerTopLeft | UIRectCornerTopRight)上圆角 (UIRectCornerBottomLeft | UIRectCornerBottomRight)下圆角
@property (nonatomic,assign) UIRectCorner cornerIndex;

///是否显示下划线你
@property (nonatomic,assign) BOOL hideLineBottom;

///创建model
+ (APPBaseCellModel *)createOneModelWithLeftImg:(NSString *)leftImg leftTitle:(NSString *)leftTitle rightplaceStr:(NSString *)rightPlaceStr rightTitle:(NSString *)rightTitle hideLeftImg:(BOOL)hideLeftImg hideRightImg:(BOOL)hideRightImg cornerIndex:(UIRectCorner)cornerIndex hideLineBottom:(BOOL)hideLineH;


@end


NS_ASSUME_NONNULL_END
