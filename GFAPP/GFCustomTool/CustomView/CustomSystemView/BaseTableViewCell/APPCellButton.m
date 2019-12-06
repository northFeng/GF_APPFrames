//
//  APPCellButton.m
//  GFAPP
//
//  Created by 峰 on 2019/12/6.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "APPCellButton.h"

@implementation CellModel


///获取一个model
+ (CellModel *)getCellModelWithLeftImg:(NSString *)leftImg leftText:(NSString *)leftText rightImg:(NSString *)rightImg rightText:(NSString *)rightText index:(NSInteger)index {
    
    CellModel *model = [[CellModel alloc] init];
    model.leftImgName = leftImg;
    model.leftLabText = leftText;
    model.rightImgName = rightImg;
    model.rightLabText = rightText;
    model.index = index;
    
    return model;
}

@end

@implementation APPCellButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    
    APPCellButton *cell = [super buttonWithType:buttonType];
    
    [cell createView];
    
    return cell;
}

///创建view
- (void)createView {
    /**
    ///左边image
    _leftImgview = [APPViewTool view_createImageViewWithImageName:@""];
    [self addSubview:_leftImgview];

    ///左边文字
    _leftLabel = [APPViewTool view_createLabelWithText:@"" font:kFontOfSystem(15*kIpadScale) textColor:DynamicColor(APPColorFunction.textBlackColor, APPColorFunction.lightTextColor) textAlignment:NSTextAlignmentLeft];
    [self addSubview:_leftLabel];

    ///右边image
    _rightImgview = [APPViewTool view_createImageViewWithImageName:@""];
    [self addSubview:_rightImgview];

    ///右边文字
    _rightLabel = [APPViewTool view_createLabelWithText:@"" font:kFontOfSystem(11*kIpadScale) textColor:DynamicColor(APPColorFunction.textGrayDrakColor, APPColorFunction.lightTextColor) textAlignment:NSTextAlignmentRight];
    [self addSubview:_rightLabel];
    
    [_leftImgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15*kScaleW);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(23*kIpadScale);
    }];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15*kScaleW + 23*kIpadScale + 12*kScaleW);
        make.centerY.equalTo(self.leftImgview);
        make.width.mas_equalTo((kScreenWidth - 24*kScaleW)/2.);
        make.height.mas_equalTo(21*kIpadScale);
    }];
    [_rightImgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15*kScaleW);
        make.centerY.equalTo(self.leftImgview);
        make.width.height.mas_equalTo(14*kIpadScale);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-(15*kScaleW + 14*kIpadScale +11*kScaleW));
        make.centerY.equalTo(self.rightImgview);
        make.width.mas_equalTo((kScreenWidth - 24*kScaleW)/3.);
        make.height.mas_equalTo(15*kIpadScale);
    }];

     */
}


- (void)setCellModel:(CellModel *)model {
    
    _model = model;
    
    if (model.leftImgName.length) {
        _leftImgview.hidden = NO;
        _leftImgview.image = ImageNamed(model.leftImgName);
        
        [_leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15*kScaleW + 23 + 12*kScaleW);
        }];
    }else{
        _leftImgview.hidden = YES;
        [_leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15*kScaleW);
        }];
    }
    
    if (model.leftLabText.length) {
        _leftLabel.text = model.leftLabText;
    }else{
        _leftLabel.text = @"";
    }
    
    if (model.rightImgName.length) {
        _rightImgview.hidden = NO;
        _rightImgview.image = ImageNamed(model.rightImgName);
        [_rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-(15*kScaleW + 14 +11*kScaleW));
        }];
    }else{
        _rightImgview.hidden = YES;
        [_rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-(15*kScaleW));
        }];
    }
    
    if (model.rightLabText.length) {
        _rightLabel.text = model.rightLabText;
    }else{
        _rightLabel.text = @"";
    }
    
}


+ (CGFloat)cellHeight {
    return 45.;
}


@end
