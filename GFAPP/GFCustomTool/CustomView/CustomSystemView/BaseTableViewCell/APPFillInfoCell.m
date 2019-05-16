//
//  APPFillInfoCell.m
//  FlashSend
//
//  Created by gaoyafeng on 2019/4/1.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPFillInfoCell.h"

@implementation APPFillInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
        [self updateMasony];
    }
    
    return self;
}

///默认模式
- (void)setNormalStyle{
    
    //设置默认样式
    _tfInfo.userInteractionEnabled = YES;
    _lineBottom.hidden = NO;
}

///更新约束 重写该方法
- (void)updateMasony{
    
    
    
}

///赋值 重写该方法 进行数据的流向 && 样式的改变
- (void)setCellModel:(APPFillCellModel *)model{
    
    _model = model;
    
    if (model.leftImg.length) {
        _imgLeft.hidden = NO;
        _imgLeft.image = [UIImage imageNamed:model.leftImg];
    }else{
        _imgLeft.hidden = YES;
    }
    
    _labelLeft.text = model.leftTitle;
    
    _tfInfo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:model.rightPlaceholderStr attributes:_dicTextAttr];
    
    _tfInfo.text = model.rightTitle;
    
    if (model.rightImg.length) {
        _imgRight.hidden = NO;
        _imgRight.image = [UIImage imageNamed:model.rightImg];
    }else{
        _imgRight.hidden = YES;
    }
    
    _tfInfo.userInteractionEnabled = model.isEdit;//能否编写
    
    if (model.isEdit) {
        //能编写
        _tfInfo.keyboardType = model.keyboardType;
        _tfInfo.limitStringLength = model.limitStringLength;
    }
    
    //设置样式
    if (model.hideRightImg) {
        //隐藏箭头
        _imgRight.hidden = YES;
        [_tfInfo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView).offset(-16);
        }];
    }else{
        //显示箭头
        _imgRight.hidden = NO;
        [_tfInfo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView).offset(-28);
        }];
    }
    
    //设置圆角
    _backView.layer.cornerRadius = 0;//清空圆角
    
    //添加圆角
    [GFFunctionMethod view_addRoundedCornersOnView:_backView viewFrame:CGRectMake(0, 0, kScreenWidth - 24, 56) cornersPosition:model.cornerIndex cornersWidth:5];
    
    _lineBottom.hidden = model.hideLineBottom;
}

#pragma mark - 输入框代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_tfInfo resignFirstResponder];
    
    return YES;
}

 - (void)textFiledEditChanged:(UITextField *)textField{
 
     _model.rightTitle = _tfInfo.text;
 }

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _model.rightTitle = _tfInfo.text;
}

///创建视图
- (void)createView{
    
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    
    ///backView
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    
    _imgLeft = [[UIImageView alloc] init];
    [_backView addSubview:_imgLeft];
    
    ///左边标题
    _labelLeft = [GFFunctionMethod view_createLabelWith:@"" textFont:kFontOfSystem(14) textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [_backView addSubview:_labelLeft];
    
    ///输入框
    _tfInfo = [[GFTextField alloc] init];
    _tfInfo.delegate = self;
    _tfInfo.limitStringLength = 200;
    _tfInfo.textAlignment = NSTextAlignmentRight;
    _tfInfo.font = kFontOfSystem(14);
    _tfInfo.textColor = [UIColor blackColor];
    _tfInfo.borderStyle = UITextBorderStyleNone;
    _tfInfo.keyboardType = UIKeyboardTypeDefault;
    _tfInfo.returnKeyType = UIReturnKeyDone;
    [_tfInfo addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [_backView addSubview:_tfInfo];
    
    _dicTextAttr = @{NSFontAttributeName:kFontOfSystem(14),NSForegroundColorAttributeName:RGBS(204)};
    
    ///右边箭头
    _imgRight = [[UIImageView alloc] initWithImage:ImageNamed(@"go_cell")];
    [_backView addSubview:_imgRight];
    
    ///下划线
    _lineBottom = [[UIView alloc] init];
    _lineBottom.backgroundColor = [UIColor lightGrayColor];
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
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(10);
    }];
    
    [_tfInfo mas_makeConstraints:^(MASConstraintMaker *make) {
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
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


#pragma mark - ************************ Model ************************
@implementation APPFillCellModel

///创建model
+ (APPFillCellModel *)createOneModelWithLeftImg:(NSString *)leftImg leftTitle:(NSString *)leftTitle rightplaceStr:(NSString *)rightPlaceStr rightTitle:(NSString *)rightTitle hideLeftImg:(BOOL)hideLeftImg canEdit:(BOOL)canEdit hideRightImg:(BOOL)hideRightImg cornerIndex:(UIRectCorner)cornerIndex hideLineBottom:(BOOL)hideLineH{
    
    APPFillCellModel *model = [[APPFillCellModel alloc] init];
    model.leftImg = leftImg;
    model.leftTitle = leftTitle;
    model.rightPlaceholderStr = rightPlaceStr;
    model.rightTitle = rightTitle;
    model.rightImg = @"go_cell";
    model.hideLeftImg = hideLeftImg;
    model.isEdit = canEdit;
    model.hideRightImg = hideRightImg;
    model.cornerIndex = cornerIndex;
    model.hideLineBottom = hideLineH;
    
    return model;
}


@end
