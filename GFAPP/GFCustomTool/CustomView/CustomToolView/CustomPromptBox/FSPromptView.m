//
//  FSPromptView.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/9/7.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSPromptView.h"

@implementation FSPromptView
{
    UIView *_backView;
    
    UIImageView *_imgPicture;
    
    UILabel *_labelTitle;
}


#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if ([super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backView];
    
    _imgPicture = [[UIImageView alloc] init];
    _imgPicture.contentMode = UIViewContentModeScaleAspectFit;
    [_backView addSubview:_imgPicture];
    
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.font = kFontOfSystem(16*KSCALE);
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.textColor = [UIColor grayColor];
    _labelTitle.backgroundColor = [UIColor clearColor];
    [_backView addSubview:_labelTitle];
    
    //约束
    _backView.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(kScreenWidth).heightIs(132*KSCALE);
    
    //_imgPicture.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).topEqualToView(_backView).heightIs(108*KSCALE);
    _imgPicture.sd_layout.centerXEqualToView(_backView).topEqualToView(_backView).widthIs(94*KSCALE).heightIs(61*KSCALE);
    
    _labelTitle.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).bottomEqualToView(_backView).heightIs(22*KSCALE);
    
}


///显示默认的无网提示图
- (void)showDefaultPromptViewForNoNet{
    
    _imgPicture.image = ImageNamed(@"ic_no_net");
    
    _labelTitle.text = @"网络不给力,请检查网络";
    
}

/**
 *  设置提示页面元素内容
 *
 *  @param promptImageName 提示图片名称
 *  @param promptText      提示文字
 */
- (void)showPromptImageName:(NSString *)promptImageName promptText:(NSString *)promptText{
    
    
    _imgPicture.image = ImageNamed(promptImageName);
    
    _labelTitle.text = promptText;
}


///自定义显示内容
- (void)addCoustomBackView:(UIView *)newBackView{
    
    _imgPicture = nil;
    _labelTitle = nil;
    [_backView removeFromSuperview];
    _backView = nil;
    
    [self addSubview:newBackView];
    
    newBackView.center = CGPointMake(self.center.x, self.center.y);
}





@end
