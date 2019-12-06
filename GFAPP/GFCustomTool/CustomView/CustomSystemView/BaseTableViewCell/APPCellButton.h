//
//  APPCellButton.h
//  GFAPP
//
//  Created by 峰 on 2019/12/6.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///CellModel
@interface CellModel : NSObject

///index
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy) NSString *leftImgName;

@property (nonatomic,copy) NSString *leftLabText;

@property (nonatomic,copy) NSString *rightImgName;

@property (nonatomic,copy) NSString *rightLabText;

///获取一个model
+ (CellModel *)getCellModelWithLeftImg:(NSString *)leftImg leftText:(NSString *)leftText rightImg:(NSString *)rightImg rightText:(NSString *)rightText index:(NSInteger)index;

@end

@interface APPCellButton : UIButton

///左边image
@property (nonatomic,strong) UIImageView *leftImgview;

///左边文字
@property (nonatomic,strong) UILabel *leftLabel;

///右边image
@property (nonatomic,strong) UIImageView *rightImgview;

///右边文字
@property (nonatomic,strong) UILabel *rightLabel;

///model
@property (nonatomic,strong) CellModel *model;


- (void)setCellModel:(CellModel *)model;


+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
