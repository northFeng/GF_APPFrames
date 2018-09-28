//
//  APPKeyInfo.h
//  GFAPP
//  各种key的信息获取
//  Created by gaoyafeng on 2018/5/10.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface APPKeyInfo : NSObject


///获取APPID
+ (NSString *)getAppId;

///主机域名
+ (NSString *)hostURL;

///获取App Store商店地址
+ (NSString *)getAppStoreUrlString;



@end
