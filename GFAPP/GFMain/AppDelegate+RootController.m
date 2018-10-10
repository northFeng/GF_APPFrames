//
//  AppDelegate+RootController.m
//  GFAPP
//
//  Created by XinKun on 2017/11/11.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "AppDelegate+RootController.h"

#import "GFNavigationController.h"

#import "GFTabBarController.h"

#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThrViewController.h"
#import "ForViewController.h"

#import "FSVersionAlert.h"

@implementation AppDelegate (RootController)

/**
 *  根视图
 */
- (void)setRootViewController{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 让当前UIWindow变成keyWindow，并显示出来
    [self.window makeKeyAndVisible];
        
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isOne"])
    {
        //不是第一次安装
        [self setRoot];

    }else{
        //引导视图
        UIViewController *guideVC = [[ UIViewController alloc ]init ];
        self.window.rootViewController = guideVC;
        [self createLoadingScrollView];
    }
    
}

#pragma mark - 设置根视图
///设置根视图
- (void)setRoot
{
    OneViewController *one = [[OneViewController alloc] init];
    TwoViewController *two = [[TwoViewController alloc] init];
    ThrViewController *thr = [[ThrViewController alloc] init];
    ForViewController *four = [[ForViewController alloc] init];
    
    GFTabBarController *gfTabBar = [GFTabBarController sharedInstance];
    gfTabBar.viewControllers = @[one,two,thr,four];//添加子视图
    //默认图片
    NSArray *arrayNomal = @[@"ic_1_2",@"ic_2_2",@"ic_3_2",@"ic_4_2"];
    //选中按钮的图片
    NSArray *arraySelect = @[@"ic_1_1",@"ic_2_1",@"ic_3_1",@"ic_4_1",];
    //item的标题
    NSArray *arrayTitle = @[@"首页",@"案例",@"搜索",@"我的"];

    [gfTabBar creatItemsWithDefaultIndex:0 normalImageNameArray:arrayNomal selectImageArray:arraySelect itemsTitleArray:arrayTitle];//设置items并设置第一个显示位置
    
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:gfTabBar];
//    navi.navigationBarHidden = NO;//隐藏系统导航条
//    //设置根视图
//    self.window.rootViewController = navi;
    
    GFNavigationController *navi = [[GFNavigationController alloc] initWithRootViewController:gfTabBar];
    //navi.navigationBarHidden = YES; //设置这个属性 ，左滑返回功能就失效了(整个NavigationController都会隐藏，因此返回手势也没有了)
    navi.navigationBar.hidden = YES;//隐藏系统导航条（只是隐藏的NavigationController上的naviBar，因此返回手势存在）
    //设置根视图
    self.window.rootViewController = navi;
    
}


#pragma mark - 设置引导页
///设置引导页
- (void)createLoadingScrollView{
    
    self.scrollerView = [[UIScrollView alloc]initWithFrame:self.window.bounds];
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.bounces = NO;
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    self.scrollerView.showsVerticalScrollIndicator = NO;
    [self.window.rootViewController.view addSubview:self.scrollerView];
    
    //引导图
    NSArray *arr = @[@"guidePage1",@"guidePage2",@"guidePage3",@"guidePage4"];
    
    for (int i = 0; i<arr.count; i++){
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
        img.image = [UIImage imageNamed:arr[i]];
        [self.scrollerView addSubview:img];
        img.userInteractionEnabled = YES;
        if (i == arr.count - 1){
            
            [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMain)]];
            
        }else {
            [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goNextImg)]];
        }
        
    }
    self.scrollerView.contentSize = CGSizeMake(kScreenWidth*arr.count, kScreenHeight);
}

///去主根视图
- (void)goToMain{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"isOne" forKey:@"isOne"];
    [user synchronize];
    [self setRoot];
}

///下一张
- (void)goNextImg{
    
    [self.scrollerView setContentOffset:CGPointMake(self.scrollerView.contentOffset.x + kScreenWidth, self.scrollerView.contentOffset.y) animated:YES];
    
}



#pragma mark - 版本检测是否有更新（从App store查询）
- (void)checkTheLatestVersion{
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",[APPKeyInfo getAppId]];
        
        NSString *appInfoString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        
        NSData *appInfoData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        if (!appInfoData) {
            return ;
        }
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:appInfoData options:NSJSONReadingMutableLeaves error:&error];
        
        if (!error && appInfoDic) {
            
            NSArray *arrayInfo = appInfoDic[@"results"];
            
            NSDictionary *resultDic = arrayInfo.firstObject;
            
            //版本号
            NSString *versionStore = resultDic[@"version"];
            
            NSString *versionLocal = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
//            CGFloat numStore = [versionStore floatValue] ;
//            CGFloat numLocal = [versionLocal floatValue];
            if (![versionStore isEqualToString:versionLocal]) {
                //版本不一致 提示更新
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"发现新版本，请及时更新" preferredStyle:UIAlertControllerStyleAlert];
                    
                    /**
                     强制更新  UIAlertActionStyleDefault
                     非强制更新 UIAlertActionStyleCancel
                     */
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *appStoreUrl = [APPKeyInfo getAppStoreUrlString];
                        [[UIApplication sharedApplication] openURL:kURLString(appStoreUrl)];
                    }];
                    [alertController addAction:cancleAction];
                    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
                });
            }
        }
        
    });
    
}


#pragma mark - 版本检测是否有更新(从后台查询)
- (void)checkTheLatestVersionWithNet{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *url = @"https:ffff.fffdddd";
        
        NSString *appInfoString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        
        if (kObjectIsEmptyEntity(appInfoString)) {
            return ;
        }
        
        NSData *appInfoData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:appInfoData options:NSJSONReadingMutableLeaves error:&error];
        
        //新版本信息
        NSDictionary *newVersionInfo = appInfoDic[@"data"];
        
        //与本地版本进行判断
        //NSDictionary *oldVersionInfo = [APPUserDefault objectForKey:_kGlobal_versionInfo];
        
        if (!error && kObjectEntity(appInfoDic) && [appInfoDic[@"status"] integerValue] == 200 && kObjectEntity(newVersionInfo)) {
            
            //判断本地版本号
            NSString *versionLocal = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
            //判断版本号一致 && 本地存储的版本信息与新版本信息不一致  ————> 进行存储新的信息  && [oldVersionInfo[@"versionCode"] integerValue] != [newVersionInfo[@"versionCode"] integerValue]
            if (![versionLocal isEqualToString:newVersionInfo[@"versionName"]]) {
                
                //版本号不一致 && 提示更新
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //有新版本 && 进行提示
                    FSVersionAlert *alertView = [[FSVersionAlert alloc] init];
                    alertView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                    [alertView setDicModel:newVersionInfo];

                    [self.window.rootViewController.view addSubview:alertView];
                });
                
            }
        }
    });
    
}






@end
