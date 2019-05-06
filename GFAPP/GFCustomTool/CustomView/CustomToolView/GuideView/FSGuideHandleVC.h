//
//  FSGuideHandleVC.h
//  FlashSend
//  APP操作引导视图
//  Created by gaoyafeng on 2019/4/18.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSGuideHandleVC : UIViewController

///引导类型 0:首页   1:个人中心   2:提交订单   3:填写订单
@property (nonatomic,assign) NSInteger guideType;

///创建&&显示 操作指引
+ (void)showGuideHandleOnVC:(UIViewController *)superVC showType:(NSInteger)guideType;

@end

NS_ASSUME_NONNULL_END
