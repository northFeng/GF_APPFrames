//
//  APPBaseViewController.m
//  GFAPP
//
//  Created by XinKun on 2017/11/16.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "APPBaseViewController.h"
#import "AppDelegate.h"//代理
//提示框
#import "GFNotifyMessage.h"

//振动模式
//#import <AudioToolbox/AudioToolbox.h>
//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

@interface APPBaseViewController ()

@end

@implementation APPBaseViewController
{
    UIStatusBarStyle _statusStyle;
    BOOL _statusIsHide;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //...配置
    }
    return self;
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//tabBar的控制页面 在 点方法中设置标题
- (void)setNaviBarTitle:(NSString *)naviBarTitle{
    
    _naviBarTitle = naviBarTitle;
    self.naviBar.title = _naviBarTitle;
}

#pragma mark - 创建视图&&初始化数据
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /** 设置视图不自动压低tableview
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
     */
    
    //注册登录通知
    [APPNotificationCenter addObserver:self selector:@selector(loginStateChange) name:_kGlobal_LoginStateChange object:nil];
    
    //接收网络状态变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityNetStateChanged:) name:_kGlobal_NetworkingReachabilityChangeNotification object:nil];
    
    //统一视图背景颜色
    self.view.backgroundColor = kColor_BaseView_BackgroundColor;
    
    //设置状态栏状态数据初始状态(默认为黑色，不隐藏)
    _statusStyle = UIStatusBarStyleDefault;
    _statusIsHide = NO;
    
    //初始化一些数据
    self.page = 0;
    self.arrayDataList = [NSMutableArray array];//分页请求存储数据数组
    
    //创建导航条
    self.naviBar = [[GFNavigationBarView alloc] init];
    self.naviBar.title = self.naviBarTitle;
    self.naviBar.delegate = self;
    [self.view addSubview:self.naviBar];
    //导航条约束
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(APP_NaviBarHeight);
    }];
    
    if (self.navigationController.viewControllers.count > 1) {
        // 设置返回按钮
        [self.naviBar setLeftFirstButtonWithTitleName:@"返回"];
    }
    
    //设置导航条样式
    [self setNaviBarState];
    
    //请求数据
    [self initData];
    
    //创建界面  自己在子视图中自己定义加载位置
    //[self createTableView];
    //[self createView];
    
}

///创建tableView
- (void)createTableView{
    
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, APP_NaviBarHeight, kScreenWidth, kScreenHeight-APP_NaviBarHeight) style:UITableViewStyleGrouped];
    //背景颜色
    self.tableView.backgroundColor = kColor_BaseView_BackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //防止UITableView被状态栏压下20
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //self.tableView.adjustedContentInset = 
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    //创建提示图
    self.promptNonetView = [[GFNotifyView alloc] init];
    [self.tableView addSubview:self.promptNonetView];
    [self.promptNonetView showDefaultPromptViewForNoNet];
    
    self.promptEmptyView = [[GFNotifyView alloc] init];
    [self.tableView addSubview:self.promptEmptyView];
    [self.promptEmptyView showDefaultPromptViewForNoNet];
    //全部隐藏
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = YES;
    [self.promptNonetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.left.right.equalTo(self.tableView);
        make.height.mas_equalTo(200);
    }];
    [self.promptEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.left.right.equalTo(self.tableView);
        make.height.mas_equalTo(200);
    }];
    
    //创建等待视图
    //等待视图
    self.waitingView = [[UIActivityIndicatorView alloc] init];
    self.waitingView.hidesWhenStopped = YES;
    self.waitingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.waitingView.color = [UIColor redColor];
    [self.view addSubview:self.waitingView];
    [self.view bringSubviewToFront:self.waitingView];
    [self.waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.and.height.mas_equalTo(50);
    }];
    
}

///添加上拉刷新，下拉加载功能
- (void)addTableViewRefreshView{
    __weak typeof(self) weakSelf = self;

    //MJRefreshHeader && MJRefreshStateHeader && MJRefreshNormalHeader && MJRefreshGifHeader
    self.tableView.mj_header = [XKRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestNetData];
    }];

    //MJRefreshAutoFooter && MJRefreshAutoNormalFooter && MJRefreshAutoGifFooter && MJRefreshAutoStateFooter && MJRefreshBackFooter && MJRefreshBackGifFooter MJRefreshBackNormalFooter
    self.tableView.mj_footer = [XKRefreshFooter footerWithRefreshingBlock:^{
        ++weakSelf.page;
        [weakSelf requestNetData];
    }];

    self.tableView.mj_footer.hidden = YES;
    
}

///添加上拉刷新，下拉占位图
- (void)addTableViewRefreshViewTwo{
    
    __weak typeof(self) weakSelf = self;
    
    //下拉刷新
    self.tableView.mj_header = [CFRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf requestNetData];
    }];
    
    //占位图（没有刷新加载更多）
    self.tableView.mj_footer = [CFRefreshFooter footerWithRefreshingBlock:nil];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    
}

#pragma mark - Network Request  网络请求
- (void)requestNetData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //可使用的
    [params setObject:[NSNumber numberWithInteger:self.page]  forKey:@"pageNo"];
    //一次拉取10条
    [params setObject:[NSNumber numberWithInt:10]  forKey:@"pageSize"];
    
    //[self requestDataWithUrl:@"url" params:params odelClass:[Class class]];
    
    //简版
    //[self requestNetDataUrl:@"" params:params];
}

//处理modelData（这个方法一定要重写！！！！！数据请求完就会回调这个方法）
- (void)handleModelData:(id)object{
    
    //处理业务逻辑  (一个是列表数组 && 一个是model类数据)
    
    //刷新tableView
    [self.tableView reloadData];
    
}


#pragma mark - 简版网络请求
//************************* 简版网络请求 *************************
///请求网络数据(分页请求)
- (void)requestNetDataUrl:(NSString *)url params:(NSDictionary *)params{

    __weak typeof(self) weakSelf = self;
    [self startWaitingAnimating];
    self.tableView.userInteractionEnabled = NO;
    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.userInteractionEnabled = YES;
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        NSDictionary *messageDic = [response objectForKey:@"message"];
        NSDictionary *dataDic = [response objectForKey:@"data"];
        
        if ([[messageDic objectForKey:@"code"] intValue] == 200) {
            //请求成功
            
            //隐藏无网占位图
            [weakSelf hidePromptView];
            
            //处理数组数据
            [weakSelf requestNetDataSuccess:dataDic];
            
        }else{
            weakSelf.page --;
            // 错误处理
            [weakSelf showMessage:messageDic[@"error_msg"]];
            [weakSelf requestNetDataFail];
        }
        
    } fail:^(NSError *error) {
        
        weakSelf.page --;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.userInteractionEnabled = YES;
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            [weakSelf showMessage:@"网络连接失败，请稍后再试"];
            
            //weakSelf.placeholderView.hidden = YES;
            if (weakSelf.arrayDataList.count > 0) {
                //隐藏无网占位图
                [weakSelf hidePromptView];
            }else{
                //显示无网占位图
                [weakSelf showPromptNonetView];
            }
        }else{
            [weakSelf showMessage:@"网络不给力... ..."];
        }
        
        [weakSelf requestNetDataFail];
        
    }];
    
}

///请求成功数据处理  (这个方法要重写！！！)
- (void)requestNetDataSuccess:(NSDictionary *)dicData{
    
    NSArray *arrayList = [dicData objectForKey:@"list"];
    
    
    if(dicData.count>0){
        
        if (self.page == 0) {
            //上拉刷新
            [self.arrayDataList removeAllObjects];
        }
        
        for (NSDictionary *itemModel in arrayList) {
            
            if (itemModel == nil || [itemModel isKindOfClass:[NSNull class]]) {
                
                continue;
            }
            //            CFDiscoverHomeModel *model = [[CFDiscoverHomeModel alloc] init];
            //            [model yy_modelSetWithDictionary:itemModel];
            
            //[self.arrayDataList addObject:model];
        }
        
        if (arrayList.count >= 10) {
            self.tableView.mj_footer.hidden = NO;
        }else{
            self.tableView.mj_footer.hidden = YES;
        }
        
    }else{
        self.tableView.mj_footer.hidden = YES;
    }
    
    ///数据为空展示无数据占位图
    if (self.arrayDataList.count == 0) {
        //数据为空展示占位图
        [self showPromptEmptyView];
    }else{
        [self hidePromptView];
    }
    //刷新数据&&处理页面
    [self.tableView reloadData];
}

///请求数据失败处理
- (void)requestNetDataFail{
    
    
}

///tableView请求一个字典
- (void)requestNetTableViewDicDataUrl:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [self startWaitingAnimating];
    self.tableView.userInteractionEnabled = NO;
    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.userInteractionEnabled = YES;
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        NSDictionary *messageDic = [response objectForKey:@"message"];
        NSDictionary *dataDic = [response objectForKey:@"data"];
        
        if ([[messageDic objectForKey:@"code"] intValue] == 200) {
            //请求成功
            //隐藏无网占位图
            
            [weakSelf requestNetDataSuccess:dataDic];
        }else{
            // 错误处理
            [weakSelf showMessage:messageDic[@"error_msg"]];
            [weakSelf requestNetDataFail];
        }
        
    } fail:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.userInteractionEnabled = YES;
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            [weakSelf showMessage:@"网络连接失败，请稍后再试"];

            //显示无网占位图
            [weakSelf showPromptNonetView];
        }else{
            [weakSelf showMessage:@"网络不给力... ..."];
        }
        
        [weakSelf requestNetDataFail];
        
    }];
}

///请求一个字典
- (void)requestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [self startWaitingAnimating];
    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        NSDictionary *messageDic = [response objectForKey:@"message"];
        NSDictionary *dataDic = [response objectForKey:@"data"];
        
        if ([[messageDic objectForKey:@"code"] intValue] == 200) {
            //请求成功
            [weakSelf requestNetDataSuccess:dataDic];
            
        }else{
            // 错误处理
            [weakSelf showMessage:messageDic[@"error_msg"]];
            [weakSelf requestNetDataFail];
        }
        
    } fail:^(NSError *error) {
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            [weakSelf showMessage:@"网络连接失败，请稍后再试"];
        }else{
            [weakSelf showMessage:@"网络不给力... ..."];
        }
        [weakSelf requestNetDataFail];
        
    }];
}


//************************* 简版网络请求 *************************


///设置导航栏样式
- (void)setNaviBarState{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.naviBar setLeftFirstButtonWithTitleName:@"返回"];
    }
}

#pragma mark - 初始化界面基础数据
- (void)initData {
    
    
}

#pragma mark - 特别设置tableView和提示图
- (void)setTableViewAndPromptView{
    //对tableView和提示图以及等待视图做一些特殊设置
    
}

#pragma mark - Init View  初始化一些视图之类的
- (void)createView{

    
}



#pragma mark - 消息提示弹框
///消息提示弹框
- (void)showMessage:(NSString *)message{
    
    [[GFNotifyMessage sharedInstance] showMessage:message];
}

///消息提示框（显示在本控制器上，多个提示框不会重叠）
- (void)showMessageToCurrentView:(NSString *)message{
    
    [[GFNotifyMessage sharedInstance] showMessage:message inView:self.view duration:0.5];
}

///消息确定框
- (void)showAlertMessage:(NSString *)message title:(NSString *)title{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

///提示无网
- (void)showPromptNonetView{
    self.promptNonetView.hidden = NO;
    self.promptEmptyView.hidden = YES;
}

///提示无内容
- (void)showPromptEmptyView{
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = NO;
}

//隐藏无网&&无内容提示图
- (void)hidePromptView{
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = YES;
}

///开启等待视图
- (void)startWaitingAnimating{
    
    [self.waitingView startAnimating];
}
///关闭等待视图
- (void)stopWaitingAnimating{
    
    [self.waitingView stopAnimating];
}


#pragma mark - UITableView&&代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NULL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - 导航条&&协议方法
///左侧第一个按钮
- (void)leftFirstButtonClick:(UIButton *)button{
    
    //默认这个为返回按钮
    [self.navigationController popViewControllerAnimated:YES];
}

///右侧第一个按钮
- (void)rightFirstButtonClick:(UIButton *)button{
    
}

///右侧第二个按钮
- (void)rightSecondButtonClick:(UIButton *)button{
    
    
}

#pragma mark - 设置状态栏
///设置状态栏是否隐藏
- (void)setStatusBarIsHide:(BOOL)isHide{
    _statusIsHide = isHide;
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}
///设置状态栏样式为默认
- (void)setStatusBarStyleDefault{
    _statusStyle = UIStatusBarStyleDefault;
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}
///设置状态栏样式为白色
- (void)setStatusBarStyleLight{
    _statusStyle = UIStatusBarStyleLightContent;
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}

//是否隐藏
- (BOOL)prefersStatusBarHidden{
    return _statusIsHide;
}
//状态栏样式
/**
 typedef NS_ENUM(NSInteger, UIStatusBarStyle) {
 UIStatusBarStyleDefault                                     = 0, // Dark content, for use on light backgrounds
 UIStatusBarStyleLightContent     NS_ENUM_AVAILABLE_IOS(7_0) = 1, // Light content, for use on dark backgrounds
 
 UIStatusBarStyleBlackTranslucent NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 1,
 UIStatusBarStyleBlackOpaque      NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 2,
 } __TVOS_PROHIBITED;
 */
//状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusStyle;
}
/**
 typedef NS_ENUM(NSInteger, UIStatusBarAnimation) {
 UIStatusBarAnimationNone,
 UIStatusBarAnimationFade NS_ENUM_AVAILABLE_IOS(3_2),
 UIStatusBarAnimationSlide NS_ENUM_AVAILABLE_IOS(3_2),
 }
 */
//状态栏隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationSlide;
}

#pragma mark - 设置屏幕方向
//开发接口
- (void)setScreenInterfaceOrientation:(UIInterfaceOrientation)orientation{
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;//横屏
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
//设置屏幕向左翻转
- (void)setScreenInterfaceOrientationLeft{
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationLandscapeLeft;//横屏向左
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
}
//设置屏幕向右翻转
- (void)setScreenInterfaceOrientationRight{
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationLandscapeRight;//横屏向右
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
    
}
//设置屏幕竖屏（默认）
- (void)setScreenInterfaceOrientationDefault{
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationPortrait;//竖屏（默认）
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
}

/*iOS8以上，旋转控制器后会调用*/
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    //屏幕发生旋转后在这里进行重写布局
}


//监听横竖屏代理（iOS8以下）
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // do something before rotation
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            NSLog(@"向左横屏");
            break;
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"向右横屏");
            break;
        case UIInterfaceOrientationPortrait:
            NSLog(@"回到竖屏");
            break;
        default:
            break;
    }
}
//监听横竖屏代理
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    // do something after rotation
    NSLog(@"发生了屏幕旋转");
}
//设置屏幕是否旋转
- (BOOL)shouldAutorotate{
    
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
//需要用到旋转的地方用此方法进行push视图
- (void)pushViewControllerWithRotateVC:(UIViewController *)VC{
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotate = YES;
    
    [self.navigationController pushViewController:VC animated:YES];
}
//需要用到旋转的地方用此方法进行pop视图
- (void)popViewControllerWithRotateVC{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotate = NO;
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"*************内存警告*************");
}

#pragma mark - 网络数据请求
///分页请求
- (void)requestListDataWithUrl:(NSString *)url params:(NSMutableDictionary *)paramDic odelClass:(Class)modelClass{
    
    WS(weakSelf);
    
    if ([APPNetRequestManager sharedInstance].networkStatus != GF_NETWORK_STATUS_NONE) {
        //开启等待视图
        [self startWaitingAnimating];
        self.tableView.userInteractionEnabled = NO;
        [[APPNetRequestManager sharedInstance].baseNetRequest getItemListWithUrl:url Params:paramDic modelClass:modelClass resultBack:^(GFCommonResult *result, NSArray *items) {
            
            if (result.resultCode == GF_RESULT_CODE_SUCCESS) {
                
                if (weakSelf.page == 1) {
                    [weakSelf.arrayDataList removeAllObjects];
                }
                //添加类
                for (int i=0; i<items.count; i++) {
                    if (items[i]!=nil && ![items[i] isKindOfClass:[NSNull class]]) {
                        [weakSelf.arrayDataList addObject:items[i]];
                    }
                }
                
                //处理footer 默认请求个数为10
                if (items.count == 10) {
                    weakSelf.tableView.mj_footer.hidden = NO;
                }else{
                    if (weakSelf.page != 1) {
                        [self showMessage:@"已无更多数据"];
                    }
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
                
            }else{
                weakSelf.page--;
                [weakSelf showMessage:result.resultDesc];
            }
            //处理提示图
            [weakSelf promptImageHandle:result];
            
            //处理数据
            [weakSelf handleModelData:nil];
            
            //停止菊花
            [weakSelf stopWaitingAnimating];
        }];
        
        
    }else{
        
        //结束等待视图
        self.page--;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.arrayDataList.count){
            //有数据全隐藏
            self.promptNonetView.hidden = YES;
            self.promptEmptyView.hidden = YES;
        }else{
            //无数据 显示无网视图
            self.promptNonetView.hidden = NO;
            self.promptEmptyView.hidden = YES;
        }
        [self showMessage:@"网络不给力..."];
    }
    
}

//提示图的处理
- (void)promptImageHandle:(GFCommonResult *)result{
    
    //统一处理
    self.tableView.userInteractionEnabled = YES;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    //数据判断
    if (self.arrayDataList.count) {
        //有数据
        self.promptNonetView.hidden = YES;
        self.promptEmptyView.hidden = YES;
    }else{
        //无数据
        if (result.resultCode == GF_RESULT_CODE_SUCCESS) {
            //请求成功
            self.promptNonetView.hidden = YES;
            self.promptEmptyView.hidden = NO;
        }else{
            //请求失败
            self.promptNonetView.hidden = NO;
            self.promptEmptyView.hidden = YES;
        }
    }
    
}

///获取一个model数据
- (void)requesModelDataWithUrl:(NSString *)url params:(NSMutableDictionary *)paramDic odelClass:(Class)modelClass{
    
    WS(weakSelf);
    
    if ([APPNetRequestManager sharedInstance].networkStatus != GF_NETWORK_STATUS_NONE) {
        //开启等待视图
        [self startWaitingAnimating];
        self.promptNonetView.hidden = YES;
        [[APPNetRequestManager sharedInstance].baseNetRequest getModelDataWithUrl:url Params:paramDic modelClass:modelClass resultBack:^(GFCommonResult *result, id object) {
           
            if (result.resultCode == GF_RESULT_CODE_SUCCESS) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //把数据返出去进行业务处理
                    [weakSelf handleModelData:object];
                });
                
            }else{
                weakSelf.promptNonetView.hidden = NO;
                
                [weakSelf showMessage:result.resultDesc];
            }
            
            [weakSelf stopWaitingAnimating];
        }];
        
    }else{
        
        self.promptNonetView.hidden = NO;
        
        [self showMessage:@"网络连接失败"];
    }
    
}
////处理modelData
//- (void)handleModelData:(id)object{
//
//    //处理业务逻辑
//
//    //刷新tableView
//    [self.tableView reloadData];
//
//}

#pragma mark - 登录状态变化发生处理事件
- (void)loginStateChange{
    
    NSLog(@"登录状态发生变化");
    
}

#pragma mark - 网络状态发生变化触发事件
- (void)reachabilityNetStateChanged:(NSNotification *)noti{
    
    //NSNumber *state = noti.object;
    /**
    NSInteger stateNum = [state integerValue];
    switch (stateNum) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"蜂窝网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"WIFI");
            break;
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"没有网络");
            break;
        case AFNetworkReachabilityStatusUnknown:
            NSLog(@"未知");
            break;
        default:
            break;
    }
     */
}



#pragma mark - 右滑返回手势的 开启  && 禁止
///禁止返回手势
- (void)removeBackGesture{
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/**
 * 恢复返回手势
 */
- (void)resumeBackGesture{
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}



#pragma mark - 视图推进封装
///推进视图 && Xib
- (void)pushViewControllerWithNibClassString:(NSString *)classString pageTitle:(NSString *)title{
    
    Class ClassViewController = NSClassFromString(classString);
    
    APPBaseViewController *pushVC = [[ClassViewController alloc] initWithNibName:classString bundle:nil];
    
    if (title) {
        pushVC.naviBarTitle = title;
    }
    
    [self.navigationController pushViewController:pushVC animated:YES];
}

///推进视图
- (void)pushViewControllerWithClassString:(NSString *)classString pageTitle:(NSString *)title{
    
    Class ClassViewController = NSClassFromString(classString);
    
    APPBaseViewController *pushVC = [[ClassViewController alloc] initWithNibName:classString bundle:nil];
    
    if (title) {
        pushVC.naviBarTitle = title;
    }
    
    [self.navigationController pushViewController:pushVC animated:YES];
}


@end
