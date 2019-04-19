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


#pragma mark - DEBUG环境下执行的
///环境选择
- (void)testEnvironmentChose{
    
#if DEBUG
    
    UIAlertController *alertTellController = [UIAlertController alertControllerWithTitle:@"请选择环境" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"测试环境test" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTestEnvironmentWithTypeStr:@"0"];
    }];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"local环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTestEnvironmentWithTypeStr:@"1"];
    }];
    
    UIAlertAction *actionThr = [UIAlertAction actionWithTitle:@"永超服务器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTestEnvironmentWithTypeStr:@"2"];
    }];
    
    UIAlertAction *actionFor = [UIAlertAction actionWithTitle:@"子昭服务器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTestEnvironmentWithTypeStr:@"3"];
    }];
    
    UIAlertAction *actionFiv = [UIAlertAction actionWithTitle:@"线上环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTestEnvironmentWithTypeStr:@"4"];
    }];
    
    [alertTellController addAction:actionOne];
    [alertTellController addAction:actionTwo];
    [alertTellController addAction:actionThr];
    [alertTellController addAction:actionFor];
    [alertTellController addAction:actionFiv];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertTellController addAction:cancleAction];
    
    //[self presentViewController:alertTellController animated:YES completion:nil];
    
#endif
    
}

///切换环境
- (void)saveTestEnvironmentWithTypeStr:(NSString *)typeStr{
    
    if (typeStr.length) {
        
        [APPUserDefault setObject:typeStr forKey:@"testEnumType"];
        
        APPManagerObject.testType = [typeStr integerValue];
        
        /**
        [self initData];
        [self.tableView reloadData];
        
        [self showMessage:@"已切换,请退出重新登录"];
         */
    }
    
}


///获取百度地图秘钥
+ (NSString *)getBaiDuAK{
    
    return @"baiduAK";
}



@end
