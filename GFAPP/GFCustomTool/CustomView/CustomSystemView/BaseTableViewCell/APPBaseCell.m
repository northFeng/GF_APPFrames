//
//  APPBaseCell.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/22.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "APPBaseCell.h"

@implementation APPBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
        
        [self setStyleAddMasory];
    }
    return self;
}

///添加view
- (void)createView{
    
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    
    _imgLeft = [[UIImageView alloc] init];
    [_backView addSubview:_imgLeft];
    
    _labelLeft = [[UILabel alloc] init];
    _labelLeft.textColor = RGBS(51);
    _labelLeft.textAlignment = NSTextAlignmentLeft;
    _labelLeft.font = kFontOfSystem(14);
    [_backView addSubview:_labelLeft];
    
    _labelRight = [[UILabel alloc] init];
    _labelRight.textColor = RGBS(153);
    _labelRight.textAlignment = NSTextAlignmentRight;
    _labelRight.font = kFontOfSystem(14);
    [_backView addSubview:_labelRight];
    
    _imgRight = [[UIImageView alloc] init];
    _imgRight.image = ImageNamed(@"go_cell");
    [_backView addSubview:_imgRight];
    
    _lineBottom = [[UIView alloc] init];
    _lineBottom.backgroundColor = RGBS(241);
    [_backView addSubview:_lineBottom];
    
    
    //约束
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.top.and.bottom.equalTo(self.contentView);
    }];
    
    [_imgLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(15);
        make.centerY.equalTo(self.backView);
        make.width.and.height.mas_equalTo(14);
    }];
    
    [_labelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(39);
        make.centerY.equalTo(self.backView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(22);
    }];
    
    [_imgRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-16);
        make.centerY.equalTo(self.backView);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(10);
    }];
    
    [_labelRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelLeft.mas_right).offset(10);
        make.centerY.equalTo(self.backView);
        make.right.equalTo(self.backView).offset(-28);
        make.height.mas_equalTo(22);
    }];
    
    [_lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(0);
        make.right.equalTo(self.backView).offset(0);
        make.bottom.equalTo(self.backView);
        make.height.mas_equalTo(1);
    }];
    
    _dicTextAttrPlace = @{NSFontAttributeName:kFontOfSystem(14),NSForegroundColorAttributeName:RGBS(201)};
    _dicTextAttr = @{NSFontAttributeName:kFontOfSystem(14),NSForegroundColorAttributeName:RGBS(51)};
}

///重写该方法
- (void)setStyleAddMasory{
    
    [self.imgLeft mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(14);
        make.width.and.height.mas_equalTo(18);
    }];
    
    [self.labelLeft mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(42);
    }];
    
    [self.labelRight mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-28);
    }];
    
    [self.imgRight mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-17);
    }];
    
    self.dicTextAttrPlace = @{NSFontAttributeName:kFontOfSystem(14),NSForegroundColorAttributeName:RGBS(201)};
    self.dicTextAttr = @{NSFontAttributeName:kFontOfSystem(14),NSForegroundColorAttributeName:RGBS(51)};
}

///赋值
- (void)setCellModel:(APPBaseCellModel *)model{
    
    if (model.leftImg.length) {
        self.imgLeft.image = [UIImage imageNamed:model.leftImg];
    }
    
    self.labelLeft.text = model.leftTitle;
    
    if (model.rightTitle.length > 0) {
        self.labelRight.attributedText = [[NSAttributedString alloc] initWithString:model.rightTitle attributes:self.dicTextAttr];
    }else{
        self.labelRight.attributedText = [[NSAttributedString alloc] initWithString:model.rightPlaceholderStr attributes:self.dicTextAttrPlace];
    }
    
    if (model.rightImg.length) {
        self.imgRight.image = [UIImage imageNamed:model.rightImg];
    }
    
    
    //设置样式
    if (model.hideRightImg) {
        //隐藏箭头
        self.imgRight.hidden = YES;
        [self.labelRight mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView).offset(-16);
        }];
    }else{
        //显示箭头
        self.imgRight.hidden = NO;
        [self.labelRight mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView).offset(-28);
        }];
    }
    
    if (model.cornerIndex != -1) {
        
        //设置圆角
        self.backView.layer.cornerRadius = 0;//清空圆角
        
        //添加圆角
        [GFFunctionMethod view_addRoundedCornersOnView:self.backView viewFrame:CGRectMake(0, 0, kScreenWidth - 24, 56) cornersPosition:model.cornerIndex cornersWidth:5];
    }
    
    self.lineBottom.hidden = model.hideLineBottom;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

#pragma mark - **************** APPBaseCellModel ****************

@implementation APPBaseCellModel


///创建model
+ (APPBaseCellModel *)createOneModelWithLeftImg:(NSString *)leftImg leftTitle:(NSString *)leftTitle rightplaceStr:(NSString *)rightPlaceStr rightTitle:(NSString *)rightTitle hideLeftImg:(BOOL)hideLeftImg hideRightImg:(BOOL)hideRightImg cornerIndex:(UIRectCorner)cornerIndex hideLineBottom:(BOOL)hideLineH{
    
    APPBaseCellModel *model = [[APPBaseCellModel alloc] init];
    model.leftImg = leftImg;
    model.leftTitle = leftTitle;
    model.rightPlaceholderStr = rightPlaceStr;
    model.rightTitle = rightTitle;
    model.rightImg = @"go_cell";
    model.hideLeftImg = hideLeftImg;
    model.hideRightImg = hideRightImg;
    model.cornerIndex = cornerIndex;
    model.hideLineBottom = hideLineH;
    
    return model;
}

@end
