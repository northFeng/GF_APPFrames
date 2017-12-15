//
//  GFGlobalVariable.h
//  GFAPP
//  自定义全局关键字
//  Created by XinKun on 2017/5/7.
//  Copyright © 2017年 North_feng. All rights reserved.
//

/**
 *
 *  常量命名规则（驼峰式命名规则），所有的单词首字母大写和加上与类名有关的前缀:
 *
 */

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#define GFKIT_EXTERN        extern "C" __attribute__((visibility ("default")))
#else
#define GFKIT_EXTERN        extern __attribute__((visibility ("default")))
#endif

/** 宏文件 */
#import "APPEnum.h"
/** 定义系统方法宏 */
#import "APPSystemDefine.h"
/** 定义常用方法宏 */
#import "APPCustomDefine.h"

/**
 * 通知网络变化：name值
 */
GFKIT_EXTERN NSString * const Global_NetworkingReachabilityChangeNotification;

/**
 * SDWebImage框架缓存Cache文件下路径
 */
GFKIT_EXTERN NSString * const Global_SDWebImagePath;

/** 首页标题 */
GFKIT_EXTERN NSString * const Global_home_title;

