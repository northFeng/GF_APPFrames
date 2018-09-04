//
//  APPLoadWaitView.h
//  GFAPP
//  加载等待视图
//  Created by gaoyafeng on 2018/9/4.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPLoadWaitView : UIView

///开启
- (void)startAnimation;

///关闭
- (void)stopAnimation;


///开启 && 显示文字
- (void)startAnimationWithTitle:(NSString *)title;

///关闭 && 显示文字
- (void)stopAnimationWithTitle:(NSString *)title;


@end

/**
///单独添加网络请求等待视图
- (void)addWaitingView{
    
    if (!self.waitingView) {
        //创建等待视图
        self.waitingView = [[FSLoadWaitView alloc] init];
        //    self.waitingView.frame = CGRectMake(0, 0, 121, 121);
        //    self.waitingView.center = CGPointMake(kScreenWidth/2., kScreenHeight/2.);
        [self.view addSubview:self.waitingView];
        [self.view bringSubviewToFront:self.waitingView];
        [self.waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.and.height.mas_equalTo(121);
        }];
        self.waitingView.layer.cornerRadius = 4;
        self.waitingView.layer.masksToBounds = YES;
    }
}
 */
