//
//  APPBaseViewController.h
//  GFAPP
//  多功能基视图 (任何数据都要进行判断是否登录)
//  Created by XinKun on 2017/11/16.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>
//导航条
#import "GFNavigationBarView.h"
//提示图
#import "GFNotifyView.h"

@interface APPBaseViewController : UIViewController <GFNavigationBarViewDelegate,UITableViewDelegate,UITableViewDataSource>

///tableView
@property (nonatomic,strong) UITableView *tableView;

///数据列表数组
@property (nonatomic,strong) NSMutableArray *arrayDataList;

///加载更多——页数
@property (nonatomic,assign) NSInteger page;

///导航条
@property (nonatomic, strong) GFNavigationBarView *naviBar;

///页面标题
@property (nonatomic, copy) NSString *naviBarTitle;

///无网提示图
@property (nonatomic,strong) GFNotifyView *promptNonetView;

///空空视图
@property (nonatomic,strong) GFNotifyView *promptEmptyView;

///系统等待视图
@property (nonatomic,strong) UIActivityIndicatorView *waitingView;




#pragma mark - 创建tableView

/**
 *  @brief 创建tableView
 *
 *
 */
- (void)createTableView;

/**
 *  @brief 添加上拉刷新，下拉加载功能
 *
 *
 */
- (void)addTableViewRefreshView;

#pragma mark - 网络数据请求（如果 搜索请求+分页请求 && 并且为第一页————>必须先清空数组 ）
/**
 *  @brief 分页请求数据
 *
 *  @param url 地址
 *  @param paramDic 参数
 *  @param modelClass [Model class]
 */
- (void)requestListDataWithUrl:(NSString *)url params:(NSMutableDictionary *)paramDic odelClass:(Class)modelClass;

/**
 *  @brief 获取一个model数据
 *
 *  @param url 地址
 *  @param paramDic 参数
 *  @param modelClass [Model class]
 */
- (void)requesModelDataWithUrl:(NSString *)url params:(NSMutableDictionary *)paramDic odelClass:(Class)modelClass;

#pragma mark - 提示框&警告框
/**
 *  @brief 消息提示框
 *
 *  @param message 消息
 *
 */
- (void)showMessage:(NSString *)message;

/**
 *  @brief 消息确认框
 *
 *  @param message 消息
 *  @param title 消息框标题
 *
 */
- (void)showAlertMessage:(NSString *)message title:(NSString *)title;

/**
 *  @brief 无网提示图
 *
 */
- (void)showPromptNonetView;

/**
 *  @brief 无内容提示图
 *
 */
- (void)showPromptEmptyView;

/**
 *  @brief 开启等待视图
 *
 */
- (void)startWaitingAnimating;

/**
 *  @brief 关闭等待视图
 *
 */
- (void)stopWaitingAnimating;

#pragma mark - 状态栏设置
/**
 *  @brief 设置状态栏是否隐藏
 *
 */
- (void)setStatusBarIsHide:(BOOL)isHide;

/**
 *  @brief 设置状态栏样式为默认
 *
 */
- (void)setStatusBarStyleDefault;

/**
 *  @brief 设置状态栏样式为白色
 *
 */
- (void)setStatusBarStyleLight;

#pragma mark - 屏幕设置
/**
 *  @brief 设置屏幕方向
 *
 */
- (void)setScreenInterfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 *  @brief 设置屏幕向左翻转
 *
 */
- (void)setScreenInterfaceOrientationLeft;

/**
 *  @brief 设置屏幕向右翻转
 *
 */
- (void)setScreenInterfaceOrientationRight;

/**
 *  @brief 设置屏幕竖屏（默认）
 *
 */
- (void)setScreenInterfaceOrientationDefault;

/**
 *  @brief 需要用到旋转的地方用此方法进行push视图
 *  @param VC push进去的视图
 */
- (void)pushViewControllerWithRotateVC:(UIViewController *)VC;

/**
 *  @brief 需要用到旋转的地方用此方法进行pop视图
 *
 */
- (void)popViewControllerWithRotateVC;




@end
