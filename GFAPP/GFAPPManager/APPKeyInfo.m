//
//  APPKeyInfo.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/10.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPKeyInfo.h"


#pragma mark - 主机URL
///测试服务器1
static NSString *const debugHostUrl = @"http://110.254.198.165:8081/lpdp/";

///测试服务器2
static NSString *const debugHostUr2 = @"http://110.254.198.165:8081/lpdp/";

///测试服务器3
static NSString *const debugHostUr3 = @"http://110.254.198.165:8081/lpdp/";

///测试服务器4
static NSString *const debugHostUr4 = @"http://110.254.198.165:8081/lpdp/";

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
    
/** 第一种方式，通过项目里设置 不同环境进行开发
    
#if DEBUG
    hostUrl = debugHostUrl;
#elif TEXT
    hostUrl = vipHostUrl;
#else
    hostUrl = releaseHostUrl;
#endif
 
 */

    
#if DEBUG
    //在设置中添加环境切换
    switch (APPManagerObject.testType) {
        case APPEnumTestType_test:
            hostUrl = debugHostUrl;
            break;
        case APPEnumTestType_local:
            hostUrl = debugHostUr2;
            break;
        case APPEnumTestType_yongchao:
            hostUrl = debugHostUr3;
            break;
        case APPEnumTestType_zizhao:
            hostUrl = debugHostUr4;
            break;
        case APPEnumTestType_release:
            hostUrl = releaseHostUrl;
            break;
        default:
            hostUrl = debugHostUrl;
            break;
    }
    
#else
    
    //release环境
    hostUrl = releaseHostUrl;
#endif
 
    return hostUrl;
}

///获取App Store商店地址
+ (NSString *)getAppStoreUrlString{
    ///浏览器就换成  https://itunes.apple.com/app/id1438700286
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APPId];
    return urlString;
}


///获取百度地图秘钥
+ (NSString *)getBaiDuAK{
    
    return @"baiduAK";
}



@end
