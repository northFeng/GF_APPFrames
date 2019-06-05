//
//  FSAlertView.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/9/7.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSAlertView.h"

@implementation FSAlertView

{
    
    UILabel *_labelTitle;
    
    UILabel *_labelBrif;
    
    UIButton *_btnCancle;
    
    UIButton *_btnOk;
    
    APPBackBlock _blockLeft;
    
    APPBackBlock _blockRight;
    
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if (self = [super init]) {
        
        self.backgroundColor = [RGBS(28) colorWithAlphaComponent:0.5];
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 280)/2., kScreenHeight*0.35, 280, 154)];
    _backView.backgroundColor = APPColor_White;
    _backView.layer.cornerRadius = 5;
    _backView.alpha = 0.;
    [self addSubview:_backView];
    
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.tintColor = APPColor_BlackDeep;
    _labelTitle.font = kFontOfCustom(kMediumFont, 20);
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.text = @"提示";
    [_backView addSubview:_labelTitle];
    
    _labelBrif = [[UILabel alloc] init];
    _labelBrif.textColor = APPColor_BlackDeep;
    _labelBrif.font = kFontOfSystem(14);
    _labelBrif.textAlignment = NSTextAlignmentCenter;
    _labelBrif.numberOfLines = 0;
    [_labelBrif sizeToFit];
    [_backView addSubview:_labelBrif];
    
    _btnCancle = [UIButton buttonWithType:UIButtonTypeSystem];
    //[_btnCancle setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancle setTitleColor:APPColor_BlackDeep forState:UIControlStateNormal];
    _btnCancle.titleLabel.font = kFontOfCustom(kSemibold, 16);
    [_backView addSubview:_btnCancle];
    [_btnCancle addTarget:self action:@selector(onClickBtnCancle) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btnOk = [UIButton buttonWithType:UIButtonTypeSystem];
    //[_btnOk setTitle:@"确定" forState:UIControlStateNormal];
    [_btnOk setTitleColor:APPColor_Blue forState:UIControlStateNormal];
    _btnOk.titleLabel.font = kFontOfCustom(kSemibold, 16);
    [_backView addSubview:_btnOk];
    [_btnOk addTarget:self action:@selector(onClickBtnOk) forControlEvents:UIControlEventTouchUpInside];
    
    //添加横线
    UIView *lineH = [[UIView alloc] init];
    lineH.backgroundColor = APPColor_two_Line;
    [_backView addSubview:lineH];
    
    UIView *lineS = [[UIView alloc] init];
    lineS.backgroundColor = APPColor_two_Line;
    [_backView addSubview:lineS];
    
    
    //添加约束
    //_labelTitle.sd_layout.leftSpaceToView(_backView, 28).topSpaceToView(_backView, 22).rightSpaceToView(_backView, 28).heightIs(28);
    //_labelBrif.sd_layout.leftSpaceToView(_backView, 35).rightSpaceToView(_backView, 35).topSpaceToView(_labelTitle, 4).heightIs(40);
    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(28);
        make.right.equalTo(self.backView).offset(-28);
        make.top.equalTo(self.backView).offset(22);
        make.height.mas_equalTo(28);
    }];
    [_labelBrif mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(20);
        make.right.equalTo(self.backView).offset(-20);
        make.top.equalTo(self->_labelTitle.mas_bottom).offset(10);
    }];
    
    lineH.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).bottomSpaceToView(_backView, 46).heightIs(1);
    lineS.sd_layout.centerXEqualToView(_backView).topSpaceToView(lineH, 0).bottomEqualToView(_backView).widthIs(1);
    _btnCancle.sd_layout.leftEqualToView(_backView).bottomEqualToView(_backView).heightIs(46).rightSpaceToView(lineS, 0);
    _btnOk.sd_layout.rightEqualToView(_backView).bottomEqualToView(_backView).heightIs(46).leftSpaceToView(lineS, 0);
}


#pragma mark - 点击事件

///取消
- (void)onClickBtnCancle{
    NSLog(@"点击取消");
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.backView.alpha = 0.;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        [self removeFromSuperview];//移除
        
        if (self->_blockLeft) {
            self->_blockLeft(YES,nil);
        }
    }];
}

///确定
- (void)onClickBtnOk{
    NSLog(@"点击确定");
    
    /**
     [self hideAlert];
     if (_blockRight) {
     _blockRight(YES,nil);
     }
     */
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.backView.alpha = 0.;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        [self removeFromSuperview];//移除
        
        if (self->_blockRight) {
            self->_blockRight(YES,nil);
        }
    }];
}


#pragma mark - 动画逻辑

///弹出来

///样式一
- (void)showAlertWithTitle:(NSString *)title withBlock:(APPBackBlock)block{
    
    _labelBrif.text = title;
    
    [_btnCancle setTitle:@"取消" forState:UIControlStateNormal];
    [_btnOk setTitle:@"确定" forState:UIControlStateNormal];
    
    _blockRight = block;
    
    [self showAlert];
}

///样式二
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif withBlock:(APPBackBlock)block{
    
    _labelTitle.text = title;
    
    _labelBrif.text = brif;
    
    [_btnCancle setTitle:@"取消" forState:UIControlStateNormal];
    [_btnOk setTitle:@"确定" forState:UIControlStateNormal];
    
    _blockRight = block;
    
    [self showAlert];
}

///样式三
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif leftBtnTitle:(NSString *)cancleTitle rightBtnTitle:(NSString *)okTitle withBlock:(APPBackBlock)block{
    
    _labelTitle.text = title;
    
    _labelBrif.text = brif;
    
    [_btnCancle setTitle:cancleTitle forState:UIControlStateNormal];
    
    [_btnOk setTitle:okTitle forState:UIControlStateNormal];
    
    _blockRight = block;
    
    [self showAlert];
}

///样式四
- (void)showAlertWithTitle:(NSString *)title brif:(NSString *)brif leftBtnTitle:(NSString *)cancleTitle rightBtnTitle:(NSString *)okTitle blockleft:(APPBackBlock)blockleft blockRight:(APPBackBlock)blockRight{
    
    _labelTitle.text = title;
    
    _labelBrif.text = brif;
    
    [_btnCancle setTitle:cancleTitle forState:UIControlStateNormal];
    
    [_btnOk setTitle:okTitle forState:UIControlStateNormal];
    
    _blockLeft = blockleft;
    
    _blockRight = blockRight;
    
    [self showAlert];
}



///显示处理啊
- (void)showAlert{
    
    CGFloat height = [GFFunctionMethod string_getTextHeight:_labelBrif.text textFont:kFontOfSystem(14) lineSpacing:2 textWidth:280 - 20*2];
    
    //一行17
    if (height < 37) {
        //两行 文字居中
        _labelBrif.textAlignment = NSTextAlignmentCenter;
    }else{
        //三行以上 文字两端对齐
        _labelBrif.textAlignment = NSTextAlignmentJustified;
    }
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backView.transform = CGAffineTransformMakeScale(1, 1);
        self.backView.alpha = 1.;
    }];
}



///隐藏
- (void)hideAlert{
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.backView.alpha = 0.;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];//移除
    }];
}






@end
