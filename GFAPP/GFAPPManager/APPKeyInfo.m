//
//  APPKeyInfo.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/10.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPKeyInfo.h"


#pragma mark - 主机URL
///测试服务器
static NSString *const debugHostUrl = @"http://110.254.198.165:8081/lpdp/";

///VIP服务器
static NSString *const vipHostUrl = @"http://120.254.198.165:8081/lpdp/";

///release服务器
static NSString *const releaseHostUrl = @"119://119.254.198.161/api/";


#pragma mark - key设置
///APPId
static NSString *const APPId = @"1111111111";


@implementation APPKeyInfo

///获取APPID
+ (NSString *)getAppId{
    return APPId;
}

///主机域名
+ (NSString *)hostURL{
    NSString *hostUrl;
    
#if DEBUG
    hostUrl = debugHostUrl;
#elif TEXT
    hostUrl = vipHostUrl;
#else
    hostUrl = releaseHostUrl;
#endif
 
    return hostUrl;
}

///获取App Store商店地址
+ (NSString *)getAppStoreUrlString{
    
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APPId];
    return urlString;
}




@end
