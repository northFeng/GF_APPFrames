//
//  APPManager.m
//  GFAPP
//
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPManager.h"

#import "GFTabBarController.h"

#define Current_Login_User @"current_login_user"

@implementation APPManager

///获取APP管理者
+ (APPManager *)sharedInstance
{
    static APPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APPManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        //初始化数据
        [self initializeData];
    }
    return self;
}

- (void)initializeData{
    
    //从本地沙盒获取用户数据
    // 初始化本地用户信息(也可以指定到某个沙盒文件中去)
    NSDictionary * dic = (NSDictionary *)[APPUserDefault objectForKey:Current_Login_User];
    //用户信息
    self.userInfo = [APPUserInfoModel mj_objectWithKeyValues:dic];
    //判断是否登录
    self.isLogined = self.userInfo ? YES : NO;

#if DEBUG
    NSString *typeStr = [APPUserDefault objectForKey:@"testEnumType"];
    self.testType = typeStr.length ? [typeStr integerValue] : 0;
#endif
}

///存储用户信息
- (void)storUserInfo{
    //存储用户信息
    [APPUserDefault setObject:[self.userInfo mj_keyValues] forKey:Current_Login_User];
}

///清楚用户信息
- (void)clearUserInfo{
    
    [APPUserDefault removeObjectForKey:Current_Login_User];
}

///主动退出
- (void)forcedExitUserWithShowControllerItemIndex:(NSInteger)index{
    
    //提示用户登录异常
    
    //清楚本地账户数据
    
    //退出 && 回到指定页面
    UIWindow *mainWindow = ([UIApplication sharedApplication].delegate).window;
    UINavigationController *rootNavi = (UINavigationController *)mainWindow.rootViewController;
    //tabBar进行切换到我的页面让用户进行登录
    [[GFTabBarController sharedInstance] setSelectItemBtnIndex:index];//设置切换的位置
    //最后弹出
    [rootNavi popToRootViewControllerAnimated:YES];//直接弹到最上层
    
    //进行发送通知刷新所有的界面（利用通知进行刷新根VC）
    [APPNotificationCenter postNotificationName:_kGlobal_LoginStateChange object:nil];
}

///清楚URL缓存和web中产生的cookie
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    
}



#pragma mark - 环境切换 -> DEBUG环境下执行的
///环境选择
+ (void)testEnvironmentChoseFormVC:(UIViewController *)superVC block:(APPBackBlock)blockResult{
    
#if DEBUG
    
    UIAlertController *alertTellController = [UIAlertController alertControllerWithTitle:@"请选择环境" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"测试环境test" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTestEnvironmentWithTypeStr:@"0" block:blockResult];
    }];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"local环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTestEnvironmentWithTypeStr:@"1" block:blockResult];
    }];
    
    UIAlertAction *actionThr = [UIAlertAction actionWithTitle:@"永超服务器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTestEnvironmentWithTypeStr:@"2" block:blockResult];
    }];
    
    UIAlertAction *actionFor = [UIAlertAction actionWithTitle:@"子昭服务器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTestEnvironmentWithTypeStr:@"3" block:blockResult];
    }];
    
    UIAlertAction *actionFiv = [UIAlertAction actionWithTitle:@"线上环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTestEnvironmentWithTypeStr:@"4" block:blockResult];
    }];
    
    [alertTellController addAction:actionOne];
    [alertTellController addAction:actionTwo];
    [alertTellController addAction:actionThr];
    [alertTellController addAction:actionFor];
    [alertTellController addAction:actionFiv];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertTellController addAction:cancleAction];
    
    [superVC presentViewController:alertTellController animated:YES completion:nil];
    
#endif
    
}

///切换环境
+ (void)saveTestEnvironmentWithTypeStr:(NSString *)typeStr block:(APPBackBlock)blockResult{
    
    if (typeStr.length) {
        
        [APPUserDefault setObject:typeStr forKey:@"testEnumType"];
        
        APPManagerObject.testType = [typeStr integerValue];
        
        if (blockResult) {
            blockResult(YES,nil);
        }
    }
    
}

///获取项目目前环境
+ (NSString *)getTestEnvironment{
    
#if DEBUG
    NSString *testStr = @"测试环境";
    switch (APPManagerObject.testType) {
        case APPEnumTestType_test:
            testStr = @"测试环境";
            break;
        case APPEnumTestType_local:
            testStr = @"local环境";
            break;
        case APPEnumTestType_yongchao:
            testStr = @"永超环境";
            break;
        case APPEnumTestType_zizhao:
            testStr = @"子昭环境";
            break;
        case APPEnumTestType_release:
            testStr = @"线上环境";
            break;
        default:
            testStr = @"测试环境";
            break;
    }
    
    return testStr;
#else
    
    return nil;
#endif
    
}




@end
