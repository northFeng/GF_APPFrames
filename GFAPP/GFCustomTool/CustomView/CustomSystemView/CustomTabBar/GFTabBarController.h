//
//  GFTabBarController.h
//  GFAPP
//  自定义tabBar
//  Created by XinKun on 2017/11/10.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFTabBarController : UITabBarController


/** 一个项目里唯一tababr */
+ (GFTabBarController *)sharedInstance;


/**
 *  创建Items
 *
 *  @param defaultIndex 默认第一个显示位置
 *  @param arrayNomal 默认图片name数组
 *
 *  @param arraySelect 选中图片name数组
 *
 *  @param titleArray 标题名字数组
 *
 */

-(void)creatItemsWithDefaultIndex:(NSInteger)defaultIndex normalImageNameArray:(NSArray *)arrayNomal selectImageArray:(NSArray *)arraySelect itemsTitleArray:(NSArray *)titleArray;

///设置TabBar颜色 && 按钮条背景颜色
- (void)setTabBarColor:(UIColor *)tabBarColor itemsBtnBarColor:(UIColor *)itemsBarColor;

///切换TabBar上的VC && 切换按钮样式(外部控制)
- (void)setSelectItemBtnIndex:(NSInteger)indexItem;


///获取tabBar当前栏的最底层视图
- (UIViewController *)getCurrentBorromVC;


@end

/*
 ///设置根视图
 - (void)setRoot
 {
 OneViewController *one = [[OneViewController alloc] init];
 TwoViewController *two = [[TwoViewController alloc] init];
 ThrViewController *thr = [[ThrViewController alloc] init];
 ForViewController *four = [[ForViewController alloc] init];
 
 GFTabBarController *gfTabBar = [[GFTabBarController alloc] init];
 gfTabBar.viewControllers = @[one,two,thr,four];//添加子视图
 //默认图片
 NSArray *arrayNomal = @[@"ic_1_2",@"ic_2_2",@"ic_3_2",@"ic_4_2"];
 //选中按钮的图片
 NSArray *arraySelect = @[@"ic_1_1",@"ic_2_1",@"ic_3_1",@"ic_4_1",];
 //item的标题
 NSArray *arrayTitle = @[@"首页",@"案例",@"搜索",@"我的"];
 
 [gfTabBar creatItemsWithDefaultIndex:0 normalImageNameArray:arrayNomal selectImageArray:arraySelect itemsTitleArray:arrayTitle];//设置items并设置第一个显示位置
 
 UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:gfTabBar];
 navi.navigationBarHidden = YES;//隐藏系统导航条
 navi.navigationBar.hidden = YES;//这个不行。改变不了状态栏样式
 //设置根视图
 self.window.rootViewController = navi;
 
 }
 
 */
