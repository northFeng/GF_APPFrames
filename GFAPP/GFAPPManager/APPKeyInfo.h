//
//  APPKeyInfo.h
//  GFAPP
//  各种key的信息获取
//  Created by gaoyafeng on 2018/5/10.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  环境类型
 */
typedef NS_ENUM(NSInteger,APPEnumTestType) {
    /**
     *  测试环境
     */
    APPEnumTestType_test = 0,
    /**
     *  log环境
     */
    APPEnumTestType_local = 1,
    /**
     *  永超
     */
    APPEnumTestType_yongchao = 2,
    /**
     *  子招
     */
    APPEnumTestType_zizhao = 3,
    /**
     *  线上环境
     */
    APPEnumTestType_release = 4,
};


@interface APPKeyInfo : NSObject


///获取APPID
+ (NSString *)getAppId;

///主机域名
+ (NSString *)hostURL;

///获取App Store商店地址
+ (NSString *)getAppStoreUrlString;

///获取百度地图秘钥
+ (NSString *)getBaiDuAK;


@end
