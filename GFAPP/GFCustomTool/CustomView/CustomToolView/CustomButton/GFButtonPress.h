//
//  GFButtonPress.h
//  FlashSend
//
//  Created by gaoyafeng on 2018/10/27.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GFButtonPress : UIButton

///长按事件回调
@property (nonatomic,copy) void(^blockPress)(BOOL result);

///点击事件
@property (nonatomic,copy) void(^blockTap)(BOOL result);

///长按事件触发时间间隔 默认为0.2秒
@property (nonatomic,assign) CGFloat timeSpace;

@end

NS_ASSUME_NONNULL_END
