//
//  GFNotifyView.m
//  GFAPP
//
//  Created by XinKun on 2017/11/17.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFNotifyView.h"

NSString *imgNoNet = @"ic_no_net";
NSString *imgFaiul = @"ic_failure";
NSString *imgLoading = @"ic_loading";
NSString *imgSuccess = @"ic_success";
NSString *imgEmpty = @"img_empty";

@interface GFNotifyView ()
/** 中心视图 **/
@property (nonatomic, strong)UIView *centerView;

/** 提示imageView **/
@property (nonatomic, strong) UIImageView *promptImageView;

/** 提示label **/
@property (nonatomic, strong) UILabel *promptLabel;

/** 建议label **/
@property (nonatomic, strong) UILabel *suggestLabel;


/** 提示图片名 **/
@property (nonatomic, copy) NSString *promptImageName;

/** 提示文字 **/
@property (nonatomic, copy) NSString *promptText;

/** 建议文字 **/
@property (nonatomic, copy) NSString *suggestText;

@end

@implementation GFNotifyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //[self initViewWithFrame:frame];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

/**
 *  初始化界面
 */
- (void)createView{
    _centerView = [[UIView alloc] init];
    _centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_centerView];
    
    _promptImageView = [[UIImageView alloc] init];
    _promptImageView.backgroundColor = [UIColor clearColor];
    [_centerView addSubview:_promptImageView];
    
    _promptLabel = [[UILabel alloc] init];
    _promptLabel.backgroundColor = [UIColor clearColor];
    _promptLabel.font = [UIFont systemFontOfSize:15];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.textColor = UIColorFromSameRGB(153);
    [_centerView addSubview:_promptLabel];
    
    _suggestLabel = [[UILabel alloc] init];
    _suggestLabel.backgroundColor = [UIColor clearColor];
    _suggestLabel.font = [UIFont systemFontOfSize:13];
    _suggestLabel.textAlignment = NSTextAlignmentCenter;
    _suggestLabel.textColor = UIColorFromSameRGB(206);
    [_centerView addSubview:_suggestLabel];
    
    //设置约束
    [self makeConstraints];
}

- (void)makeConstraints {
    
    UIImage *image = ImageNamed(imgNoNet);
    [_promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_top);
        make.centerX.equalTo(_centerView.mas_centerX);
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
    }];
    
    CGFloat promptLabelHeight = 21.;
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerView);
        make.top.equalTo(_promptImageView.mas_bottom).offset(15);
        make.height.mas_equalTo(promptLabelHeight);
    }];
    
    CGFloat suggestLabelHeight = 37 / 2.;
    [_suggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerView);
        make.top.equalTo(_promptLabel.mas_bottom).offset(6);
        make.height.mas_equalTo(suggestLabelHeight);
    }];
    
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(image.size.height + promptLabelHeight + suggestLabelHeight+21);
    }];
}

///显示默认的无网提示图
- (void)showDefaultPromptViewForNoNet{
    
    _promptImageView.image = ImageNamed(imgNoNet);
    _promptLabel.text = @"网络连接失败";
    _suggestLabel.text = @"下拉重新加载数据";
    
}

///显示默认的空内容提示图
- (void)showDefaultPromptViewForNoContent{
    
    _promptImageView.image = ImageNamed(imgEmpty);
    _promptLabel.text = @"空空如也";
    _suggestLabel.text = @"";
    
}


- (void)setPromptImageName:(NSString *)promptImageName promptText:(NSString *)promptText suggestText:(NSString *)suggestText {
    
    self.promptImageName = promptImageName;
    self.promptText = promptText;
    self.suggestText = suggestText;
    
    _promptImageView.image = ImageNamed(self.promptImageName);
    _promptLabel.text = self.promptText;
    _suggestLabel.text = self.suggestText;
}



@end
