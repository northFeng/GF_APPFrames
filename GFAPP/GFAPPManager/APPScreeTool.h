//
//  APPScreeTool.h
//  GFAPP
//  屏幕信息获取工具
//  Created by 峰 on 2019/8/21.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPScreeTool : NSObject

/**
 屏幕类别
 
 @return 代表列表的字符串
 */
+ (NSString *)screenType;

/**
 是否有安全区域
 */
+ (BOOL)hasSafeArea;

/**
 根据不同屏幕换算相应的数据
 
 @param number 375宽（iPhone X）对应的数
 @return 转换后的数
 */
+ (CGFloat)fit:(CGFloat)number;

/**
 根据不同型号适配字体
 
 @param number 375宽（iPhone X）对应的字体数
 @return 转换后的数
 */
+ (UIFont *)font:(CGFloat)number;

/**
 根据不同屏幕换算相应的高度 适配间距
 
 @param number 375宽（iPhone X）对应的数
 @return 转换后的数
 */
+ (CGFloat)fitH:(CGFloat)number;


/**
 push移除当前view
 
 @param vc 需要移除的viewController
 */
+ (void)removeInViewControllers:(UIViewController *)vc;

/**
 手机型号
 
 @return 字符串
 */
+ (NSString*)iphoneType;


/**
 上传设备信息
 */
+ (void)uploadSystemInfo;

@end

NS_ASSUME_NONNULL_END
