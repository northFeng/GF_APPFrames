//
//  APPBaseViewController.h
//  GFAPP
//  多功能基视图 (任何数据都要进行判断是否登录)
//  Created by XinKun on 2017/11/16.
//  Copyright © 2017年 North_feng. All rights reserved.
//

/**
 
   任何复杂的界面 ---> 都是由 数据作为设计稿 来控制  界面UI的展示
                1、首先开发出页面
                2、仔细设计model的数据模型：添加不同的字段来控制UI的类型
 */

#import <UIKit/UIKit.h>
//导航条
#import "GFNavigationBarView.h"
//提示图
#import "GFNotifyView.h"
//网络请求简版
#import "APPHttpTool.h"
//刷新视图
#import "XKRefreshHeader.h"
#import "XKRefreshFooter.h"
#import "CFRefreshHeader.h"
#import "CFRefreshFooter.h"


//刷新视图
typedef void (^Block) (void);

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

///处理占位图显示 && 刷新cell
- (void)refreshTableViewHandlePromptView;

/**
 *  @brief 滚动指定tableView的位置
 *
 *  @param section 组
 *  @param row 行
 *  @param position 上 中 下
 */
- (void)scrollTableViewToSection:(NSInteger)section row:(NSInteger)row position:(UITableViewScrollPosition)position;

/**
 *  @brief 获取指定的cell
 *
 *  @param section 组
 *  @param row 行
 */
- (UITableViewCell *)getOneCellWithSection:(NSInteger)section row:(NSInteger)row;

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

#pragma mark - 简版网络请求
///请求网络数据(分页请求)
- (void)requestNetDataUrl:(NSString *)url params:(NSDictionary *)params;

///tableView请求一个字典
- (void)requestNetTableViewDicDataUrl:(NSString *)url params:(NSDictionary *)params;

///请求一个字典
- (void)requestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params;


#pragma mark - 提示框&警告框
/**
 *  @brief 消息提示框
 *
 *  @param message 消息默认显示在Window视图上，全APP内显示位置一样（多个控制提示可能会重叠）
 *
 */
- (void)showMessage:(NSString *)message;

/**
 *  @brief 消息提示弹框 && 执行block
 *
 *  @param message 消息默认显示在Window视图上，全APP内显示位置一样（多个控制提示可能会重叠）
 *  @param block 消息弹框消失后执行block
 */
- (void)showMessage:(NSString *)message block:(GFBackBlock)block;

/**
 *  @brief 消息提示框（显示在本控制器上，多个提示框不会重叠）
 *
 *  @param message 消息默认显示在self.view上
 *
 */
- (void)showMessageToCurrentView:(NSString *)message;

/**
 *  @brief 消息确认框
 *
 *  @param message 消息
 *  @param title 消息框标题
 *
 */
- (void)showAlertMessage:(NSString *)message title:(NSString *)title;

/**
 *  @brief 消息提示框 && 带两个按钮执行事件
 *
 *  @param message 消息
 *  @param title 消息框标题
 *  @param leftTitle 左边按钮标题
 *  @param leftBlock 执行左边按钮事件block
 *  @param rightTitle 右边按钮标题
 *  @param rightBlock 执行右边按钮事件block
 */
- (void)showAlertMessage:(NSString *)message title:(NSString *)title btnLeftTitle:(NSString *)leftTitle leftBlock:(Block)leftBlock btnRightTitle:(NSString *)rightTitle rightBlock:(Block)rightBlock;

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
 *  @brief 隐藏无网&&无内容提示图
 *
 */
- (void)hidePromptView;

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


#pragma mark - 右滑返回手势的 开启  && 禁止
///禁止返回手势
- (void)removeBackGesture;

/**
 * 恢复返回手势
 */
- (void)resumeBackGesture;


#pragma mark - 视图推进封装

/**
 *  @brief 推进视图 && Xib
 *
 *  @param classString VC类的字符串
 *  @param title VC页面标题
 */
- (void)pushViewControllerWithNibClassString:(NSString *)classString pageTitle:(NSString *)title;

/**
 *  @brief 推进视图 && 无Xib
 *
 *  @param classString VC类的字符串
 *  @param title VC页面标题
 */
- (void)pushViewControllerWithClassString:(NSString *)classString pageTitle:(NSString *)title;

#pragma mark - 弹出模态视图

///弹出模态视图
- (void)presentViewController:(APPBaseViewController *)presentVC;

/**
 *  @brief 弹出模态视图
 *
 *  @param presentVC VC视图
 *  @param presentStyle 弹出动画风格
 *  @param completion 动画执行完毕回调
 */
- (void)presentViewController:(APPBaseViewController *)presentVC presentStyle:(UIModalTransitionStyle)presentStyle completionBlock:(void (^ __nullable)(void))completion;


#pragma mark - 系统方法自动添加

///给按钮添加事件
- (void)btnAddEventControlWithBtn:(UIButton *)button action:(SEL)action;

///给按钮添加显示(默认状态)
- (void)btnAddTitleWithBtn:(UIButton *)button title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color;

///给按钮添加显示——设置状态
- (void)btnAddTitleWithBtn:(UIButton *)button title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color state:(UIControlState)state;




@end
