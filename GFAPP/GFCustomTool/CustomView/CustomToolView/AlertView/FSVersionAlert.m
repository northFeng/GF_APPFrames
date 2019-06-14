//
//  FSVersionAlert.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/9/28.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSVersionAlert.h"

@implementation FSVersionAlert
{
    UIView *_backView;
    
    UILabel *_labelTitle;
    
    UILabel *_labelDetail;//跟新描述
    
    UIButton *_btnLeft;
    
    UIButton *_btnRight;
    
    CGFloat _width;
    
    BOOL _isMustUpdate;//是否强制更新
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if (self = [super init]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    _isMustUpdate = NO;
    
    _backView = [[UIView alloc] init];
    _backView.frame = CGRectMake(50, -180, kScreenWidth - 100, 180);
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 8;
    _backView.layer.masksToBounds = YES;
    [self addSubview:_backView];
    
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.font = [UIFont boldSystemFontOfSize:20];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_labelTitle];
    
    _labelDetail = [[UILabel alloc] init];
    _labelDetail.numberOfLines = 3;
    _labelDetail.font = [UIFont systemFontOfSize:16];
    _labelDetail.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_labelDetail];
    
    _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnLeft setTitle:@"取消" forState:UIControlStateNormal];
    [_btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnLeft.layer.cornerRadius = 3;
    _btnLeft.layer.masksToBounds = YES;
    _btnLeft.layer.borderWidth = 1;
    _btnLeft.layer.borderColor = [UIColor blueColor].CGColor;
    [_backView addSubview:_btnLeft];
    
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRight setTitle:@"确定" forState:UIControlStateNormal];
    [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnRight.backgroundColor = [UIColor blueColor];
    _btnRight.layer.cornerRadius = 3;
    _btnRight.layer.masksToBounds = YES;
    [_backView addSubview:_btnRight];
    
    //约束
    _labelTitle.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).topSpaceToView(_backView, 10).heightIs(33);
    
    //_labelDetail.sd_layout.leftSpaceToView(_backView, 30).rightSpaceToView(_backView, 20).topSpaceToView(_labelTitle, 15);
    [_labelDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_backView).offset(20);
        make.right.equalTo(self->_backView).offset(-20);
        make.top.equalTo(self->_labelTitle.mas_bottom).offset(15);
    }];
    
    _width = (kScreenWidth - 120 - 60)/2.;
    _btnLeft.sd_layout.leftSpaceToView(_backView, 20).bottomSpaceToView(_backView, 15).widthIs(_width).heightIs(40);
    _btnRight.sd_layout.rightSpaceToView(_backView, 20).bottomSpaceToView(_backView, 15).widthIs(_width).heightIs(40);
    
    [_btnLeft addTarget:self action:@selector(onClickBtnLeft) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnRight addTarget:self action:@selector(onClickBtnRight) forControlEvents:UIControlEventTouchUpInside];
}



///赋值
- (void)setDicModel:(NSDictionary *)dicModel{
    
    _labelTitle.text = [NSString stringWithFormat:@"版本更新提示:%@",dicModel[@"versionName"]];
    
    _labelDetail.text = dicModel[@"describe"];
    
    
    //0:非强制；1：强制更新
    if ([dicModel[@"mustUpdate"] integerValue] == 1) {
        
        _isMustUpdate = YES;
    }
    
    if (_isMustUpdate) {
        
        _btnLeft.hidden = YES;
        
        _btnRight.sd_resetLayout.bottomSpaceToView(_backView, 15).widthIs(_width).heightIs(40).centerXEqualToView(_backView);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self->_backView.frame = CGRectMake(50, (kScreenHeight - 180)/2., kScreenWidth - 100, 180);
    }];
}


///取消
- (void)onClickBtnLeft{
    
    if (!_isMustUpdate) {
        //非强制更新
        [UIView animateWithDuration:0.2 animations:^{
            self->_backView.frame = CGRectMake(50, kScreenHeight, kScreenWidth - 100, 180);
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
        
    }
}

///跳转苹果商店
- (void)onClickBtnRight{
    
    NSString *appStoreUrl = [APPKeyInfo getAppStoreUrlString];
    [[UIApplication sharedApplication] openURL:kURLString(appStoreUrl)];
    
    if (!_isMustUpdate) {
        //非强制更新
        
        [self onClickBtnLeft];
    }
}

///弹出更新弹框
+ (void)showVersonUpdateAlertViewWithVersonInfo:(NSDictionary *)versonDic{
    
    //有新版本 && 进行提示
    FSVersionAlert *alertView = [[FSVersionAlert alloc] init];
    alertView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [alertView setDicModel:versonDic];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:alertView];
}




@end
