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
    
    GFBackBlock _block;
    
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if ([super init]) {
        
        self.backgroundColor = [RGBS(28) colorWithAlphaComponent:0.5];
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 280)/2., kScreenHeight*0.35, 280, 154)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 5;
    _backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    _backView.alpha = 0.;
    [self addSubview:_backView];
    
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.tintColor = [UIColor blackColor];
    _labelTitle.font = kFontOfCustom(kMediumFont, 20);
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.text = @"提示";
    [_backView addSubview:_labelTitle];
    
    _labelBrif = [[UILabel alloc] init];
    _labelBrif.textColor = [UIColor blackColor];
    _labelBrif.font = kFontOfSystem(14);
    _labelBrif.textAlignment = NSTextAlignmentCenter;
    _labelBrif.numberOfLines = 2;
    [_backView addSubview:_labelBrif];
    
    _btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancle setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnCancle.titleLabel.font = kFontOfCustom(kSemibold, 16);
    [_backView addSubview:_btnCancle];
    [_btnCancle addTarget:self action:@selector(onClickBtnCancle) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnOk setTitle:@"确定" forState:UIControlStateNormal];
    [_btnOk setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _btnOk.titleLabel.font = kFontOfCustom(kSemibold, 16);
    [_backView addSubview:_btnOk];
    [_btnOk addTarget:self action:@selector(onClickBtnOk) forControlEvents:UIControlEventTouchUpInside];
    
    //添加横线
    UIView *lineH = [[UIView alloc] init];
    lineH.backgroundColor = [UIColor lightGrayColor];
    [_backView addSubview:lineH];
    
    UIView *lineS = [[UIView alloc] init];
    lineS.backgroundColor = [UIColor lightGrayColor];
    [_backView addSubview:lineS];
    
    
    //添加约束
    _labelTitle.sd_layout.centerXEqualToView(_backView).topSpaceToView(_backView, 20).widthIs(40).heightIs(28);
    _labelBrif.sd_layout.leftSpaceToView(_backView, 35).rightSpaceToView(_backView, 35).topSpaceToView(_labelTitle, 4).heightIs(40);
    lineH.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).bottomSpaceToView(_backView, 46).heightIs(1);
    lineS.sd_layout.centerXEqualToView(_backView).topSpaceToView(lineH, 0).bottomEqualToView(_backView).widthIs(1);
    _btnCancle.sd_layout.leftEqualToView(_backView).bottomEqualToView(_backView).heightIs(46).rightSpaceToView(lineS, 0);
    _btnOk.sd_layout.rightEqualToView(_backView).bottomEqualToView(_backView).heightIs(46).leftSpaceToView(lineS, 0);
}



#pragma mark - 点击事件

///取消
- (void)onClickBtnCancle{
    NSLog(@"点击取消");
    
    [self hideAlert];
}

///确定
- (void)onClickBtnOk{
    NSLog(@"点击确定");
    
    [self hideAlert];
    if (_block) {
        _block(YES,nil);
    }
}


#pragma mark - 动画逻辑

///弹出来
- (void)showAlertWithTitle:(NSString *)title withBlock:(GFBackBlock)block{
    
    _labelBrif.text = title;
    
    _block = block;
    
    [UIView animateWithDuration:0.2 animations:^{

        self.backView.transform = CGAffineTransformMakeScale(1, 1);
        self.backView.alpha = 1.;
    }];
}

///隐藏
- (void)hideAlert{
    
    APPWeakSelf;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.backView.alpha = 0.;
        
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];//移除
    }];
}








@end
