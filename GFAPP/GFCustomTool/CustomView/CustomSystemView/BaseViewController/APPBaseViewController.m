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

#import "FSAlertView.h"//提示弹框 自定义系统中间提示按钮弹框

//振动模式
//#import <AudioToolbox/AudioToolbox.h>
//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

@interface APPBaseViewController ()

///执行blcok
@property (nonatomic,copy) APPBackBlock blockSEL;

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
        [self initBaseParams];
    }
    return self;
}

///初始化最基本数据
- (void)initBaseParams{
    
    
    
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
    
    [self initNavibarStyle];//初始化导航条样式
    
    //初始化一些数据
    self.page = 0;
    self.arrayDataList = [NSMutableArray array];//分页请求存储数据数组
    
    //请求数据
    [self initData];
    
    //设置导航条样式
    [self setNaviBarStyle];
    
    //创建界面  自己在子视图中自己定义加载位置
    //[self createTableView];
    //[self createView];
}

///初始化导航条样式
- (void)initNavibarStyle{
    
    //设置状态栏状态数据初始状态(默认为黑色，不隐藏)
    _statusStyle = UIStatusBarStyleDefault;
    _statusIsHide = NO;
    
    //创建导航条 (导航条底部添加阴影时，下面的tableView会挡住导航条的阴影，解决方法[self.view sendSubviewToBack:self.tableView];//把tableView置于导航条视图后面)
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
}

- (void)initData {
    
    
}


///设置导航栏样式
- (void)setNaviBarStyle{
    
   
}

#pragma mark - 公共方法
- (void)publicMethod{
    
}

- (void)publicMethodParam:(id)param{
    
}

- (void)publicMethodParam:(id)param sucess:(BOOL)sucess{
    
}


#pragma mark - Init View  初始化一些视图之类的
- (void)createView{
    
    
}



///创建tableView
- (void)createTableView{
    
    //创建tableView  UITableViewStyleGrouped:cell的组头视图不会吸顶（会被压）  UITableViewStylePlain:组头视图会吸顶（不会被压）
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //self.tableView.adjustedContentInset = 
    }
    /**
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    self.headView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.headView;
     */
    
    //添加占位图 && 等待视图
    [self createPrompyViewOnTableView];
    [self addWaitingView];
    
}

///添加等待视图
- (void)addWaitingView{
    
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
    
    /** 自定义等待视图
    if (!self.waitingView) {
        //创建等待视图
        self.waitingView = [[FSLoadWaitView alloc] init];
        self.waitingView.frame = CGRectMake(0, 0, 121, 121);
        self.waitingView.center = CGPointMake(kScreenWidth/2., kScreenHeight/2.);
        self.waitingView.layer.cornerRadius = 4;
        self.waitingView.layer.masksToBounds = YES;
        [self.view addSubview:self.waitingView];
    }
     */
}

///创建tableView无HeadView
- (void)createTableViewNoHeadView{
    
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopNaviBarHeight, kScreenWidth, kScreenHeight - kTopNaviBarHeight) style:UITableViewStyleGrouped];
    //背景颜色
    self.tableView.backgroundColor = [UIColor whiteColor];
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //self.tableView.adjustedContentInset =
    }
    
    
    //添加占位图 && 等待视图
    [self createPrompyViewOnTableView];
    [self addWaitingView];
}

///创建tableView无headView无占位图
- (void)createOneTableView{
    
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopNaviBarHeight, kScreenWidth, kScreenHeight - kTopNaviBarHeight) style:UITableViewStyleGrouped];
    //背景颜色
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //防止UITableView被状态栏压下20
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //self.tableView.adjustedContentInset =
    }
    
    [self.view addSubview:self.tableView];
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

///创建提示图
- (void)createPrompyViewOnTableView{
    
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
    //在tableView没有内容时！SDLayout没有Masony好用
    [self.promptNonetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(200);
    }];
    [self.promptEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(200);
    }];
}


///创建提示图到控制器视图上
- (void)createPrompyView{
    
    //创建提示图
    self.promptNonetView = [[GFNotifyView alloc] init];
    [self.view addSubview:self.promptNonetView];
    [self.promptNonetView showDefaultPromptViewForNoNet];
    
    self.promptEmptyView = [[GFNotifyView alloc] init];
    [self.view addSubview:self.promptEmptyView];
    [self.promptEmptyView showDefaultPromptViewForNoNet];
    //全部隐藏
    self.promptNonetView.hidden = YES;
    self.promptEmptyView.hidden = YES;
    //在tableView没有内容时！SDLayout没有Masony好用
    [self.promptNonetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(200);
    }];
    [self.promptEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(200);
    }];
}



#pragma mark - Network Request  简版网络请求
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


///请求成功数据处理  (这个方法要重写！！！)
- (void)requestNetDataSuccess:(id)dicData{
    
    NSArray *arrayList = [(NSDictionary *)dicData objectForKey:@"list"];
    
    if(arrayList.count>0){
        
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

///处理占位图显示 && 刷新cell
- (void)refreshTableViewHandlePromptView{
    
    ///数据为空展示无数据占位图
    if (self.arrayDataList.count) {
        [self hidePromptView];
    }else{
        //数据为空展示占位图
        [self showPromptEmptyView];
    }
    
    //刷新数据&&处理页面
    [self.tableView reloadData];
}

///请求数据失败处理
- (void)requestNetDataFail{
    
    
}

///处理错误状态
- (void)requestNetDataFailWithCode:(NSInteger)code{
    
    
    
}

//************************* 简版网络请求 *************************
///请求网络数据(分页请求)
- (void)requestTableViewPageData:(NSString *)url params:(NSDictionary *)params{

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
        id dataDic = [response objectForKey:@"data"];
        
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
            
        }else{
            [weakSelf showMessage:@"网络不给力... ..."];
        }
        
        [weakSelf requestNetDataFail];
        
        //weakSelf.placeholderView.hidden = YES;
        if (weakSelf.arrayDataList.count > 0) {
            //隐藏无网占位图
            [weakSelf hidePromptView];
        }else{
            //显示无网占位图
            [weakSelf showPromptNonetView];
        }
        
    }];
    
}


///tableView请求一个字典
- (void)requestTableViewData:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [self startWaitingAnimating];
    self.tableView.userInteractionEnabled = NO;
    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.userInteractionEnabled = YES;
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        NSDictionary *messageDic = [response objectForKey:@"message"];
        id dataDic = [response objectForKey:@"data"];
        
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

///post请求一个字典
- (void)requestDicData:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [self startWaitingAnimating];
    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        NSDictionary *messageDic = [response objectForKey:@"message"];
        id dataDic = [response objectForKey:@"data"];
        
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

///get请求一个字典
- (void)requestGetDicData:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [self startWaitingAnimating];
    [APPHttpTool getWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        
        ///隐藏加载动画
        [weakSelf stopWaitingAnimating];
        
        NSDictionary *messageDic = [response objectForKey:@"message"];
        id dataDic = [response objectForKey:@"data"];
        
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

///请求一个字典 && 不带等待视图
- (void)requestDicDataNoWatingView:(NSString *)url params:(NSDictionary *)params{
    
    __weak typeof(self) weakSelf = self;
    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        
        //NSString *message = [response objectForKey:@"msg"];
        id dataDic = [response objectForKey:@"data"];
        
        if (code == 200) {
            //请求成功
            [weakSelf requestNetDataSuccess:dataDic];
        }else{
            // 错误处理
            //[weakSelf showMessage:message];
            [weakSelf requestNetDataFail];
        }
        
    } fail:^(NSError *error) {
        
        [weakSelf requestNetDataFail];
    }];
}



//************************* 简版网络请求 *************************



#pragma mark - ************************ 消息提示弹框 ************************

///开启等待视图
- (void)startWaitingAnimating{
    
    [self.waitingView startAnimating];
    
    /** 自定义等待视图
     [self.view bringSubviewToFront:self.waitingView];
     [self.waitingView startAnimation];
     */
}
///关闭等待视图
- (void)stopWaitingAnimating{
    
    [self.waitingView stopAnimating];
    
    //[self.waitingView stopAnimation];
}

/**
///开启等待视图
- (void)startWaitingAnimatingWithTitle:(NSString *)title{
    
    [self.view bringSubviewToFront:self.waitingView];
    [self.waitingView startAnimationWithTitle:title];
}

///开启等待视图带回调事件
- (void)startWaitingAnimatingWithTitle:(NSString *)title block:(APPBackBlock)block{
    
    [self.view bringSubviewToFront:self.waitingView];
    [self.waitingView startAnimationWithTitle:title];
    
    self.blockSEL = block;
    [self performSelector:@selector(performBlock) withObject:nil afterDelay:1];
}

///关闭等待视图
- (void)stopWaitingAnimatingWithTitle:(NSString *)title{
    
    [self.waitingView stopAnimationWithTitle:title];
}

///关闭等待视图——>执行block
- (void)stopWaitingAnimatingWithTitle:(NSString *)title block:(APPBackBlock)block{
    
    [self.waitingView stopAnimationWithTitle:title];
    
    if (block) {
        block(YES,nil);
    }
}
 */


///自定义消息确定框
- (void)showAlertCustomMessage:(NSString *)message okBlock:(APPBackBlock)block{
    
    FSAlertView *fsAlert = [[FSAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:message withBlock:block];
}

///自定义弹框——>自定义标题
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message okBlock:(APPBackBlock)block{
    
    FSAlertView *fsAlert = [[FSAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message withBlock:block];
}

///自定义弹框——>自定义标题——>自定义按钮文字
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle okBlock:(APPBackBlock)block{
    
    FSAlertView *fsAlert = [[FSAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message leftBtnTitle:cancleTitle rightBtnTitle:okTitle withBlock:block];
}

///自定义弹框——>自定义标题——>自定义按钮文字 ——>左右按钮事件
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle leftBlock:(APPBackBlock)blockLeft rightBlock:(APPBackBlock)blockRight{
    
    FSAlertView *fsAlert = [[FSAlertView alloc] init];
    fsAlert.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [fsAlert showAlertWithTitle:title brif:message leftBtnTitle:cancleTitle rightBtnTitle:okTitle blockleft:blockLeft blockRight:blockRight];
}


///消息提示弹框
- (void)showMessage:(NSString *)message{
    
    [[GFNotifyMessage sharedInstance] showMessage:message];
    
    //默认设置两秒 第三1
    //[[MBProgressHUDTool sharedMBProgressHUDTool] showTextToastView:message view:self.view];
}

///消息提示弹框 && 执行block
- (void)showMessage:(NSString *)message block:(APPBackBlock)block{
    
    //默认设置两秒
    [[GFNotifyMessage sharedInstance] showMessage:message];
    
    self.blockSEL = block;
    [self performSelector:@selector(performBlock) withObject:nil afterDelay:1];
    
    /** 第三方
    //默认设置两秒
    [[MBProgressHUDTool sharedMBProgressHUDTool] showTextToastView:message view:self.view];
    
    self.blockSEL = block;
    [self performSelector:@selector(performBlock) withObject:nil afterDelay:1];
     */
}

///执行block
- (void)performBlock{
    
    if (self.blockSEL) {
        self.blockSEL(YES, nil);
    }
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

///消息提示框
- (void)showAlertMessage:(NSString *)message title:(NSString *)title btnTitle:(NSString *)btnTitle block:(nullable Block)block{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (block) {
            block();
        }
    }];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

///消息提示框 && 处理block
- (void)showAlertMessage:(NSString *)message title:(NSString *)title btnLeftTitle:(NSString *)leftTitle leftBlock:(Block)leftBlock btnRightTitle:(NSString *)rightTitle rightBlock:(Block)rightBlock{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (leftBlock) {
            leftBlock();
        }
    }];
    [alertController addAction:leftAction];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //执行block
        if (rightBlock) {
            rightBlock();
        }
    }];
    [alertController addAction:rightAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

///弹出弹输入框系统弹框
- (void)showAlertTitle:(NSString *)title textFieldPlaceString:(NSString *)placeString leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle block:(APPBackBlock)block{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeString;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:leftBtnTitle style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:rightBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (alertController.textFields.firstObject.text.length) {
            if (block) {
                block(YES,alertController.textFields.firstObject.text);
            }
        }else{
            [self showMessage:@"请输入内容"];
        }
    }];
    [alertController addAction:cancel];
    [alertController addAction:confirm];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

///消息提示列表选择
- (void)showAlertListWithTitle:(nullable NSString *)title message:(nullable NSString *)message listTitleArray:(NSArray *)listArray blockResult:(APPBackBlock)blockAction{
    
    UIAlertController *alertTellController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < listArray.count ; i++) {
        
        NSString *listTitle = listArray[i];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:listTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (blockAction) {
                blockAction(YES,[NSNumber numberWithInt:i]);
            }
        }];
        
        [alertTellController addAction:action];
    }
    
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertTellController addAction:cancleAction];
    
    [self presentViewController:alertTellController animated:YES completion:nil];
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

///滚动指定tableView的位置
- (void)scrollTableViewToSection:(NSInteger)section row:(NSInteger)row position:(UITableViewScrollPosition)position{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:YES];
}

///获取指定的cell
- (UITableViewCell *)getOneCellWithSection:(NSInteger)section row:(NSInteger)row{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];//这个方法只能获取可见的cell，不可见的返回nil
    return cell;
}

///选中指定cell
- (void)selectOneCellWithSection:(NSInteger)section row:(NSInteger)row positon:(UITableViewScrollPosition)position{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:position];
}

///刷新指定cell
- (void)reloadOneCellForSection:(NSInteger)section row:(NSInteger)row{
    
    NSIndexPath *zkIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSArray *array = @[zkIndexPath];
    
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
}

///删除一个cell
- (void)deleteOneCellForSection:(NSInteger)section row:(NSInteger)row{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - cell编辑设置  && 警告！！！ 左滑露出删除按钮，没有点击，滑动返回 ！MJRefresh会崩溃！在viewWillDismiss里进行 [self.tableView reloadDate]刷新cell
///返回编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone;
}
//返回按钮上的显示文字
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";//默认返回 @"删除" ——>@"好的"  @"确定"
}

///删除cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
    if (indexPath.section == 0) {
        return YES;
    }else{
        return NO;
    }
     */
    return NO;
}
///删除cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        /**
        //1.没有动画效果
        // 先删除数据源
        [self.commonGoodsArray removeObjectAtIndex:indexPath.row];
        // 再reloadDate
        [self.tableView reloadData];
         */
        
        //2.可设置删除动画效果
        // 先删除数据源
        [self.arrayDataList removeObjectAtIndex:indexPath.row];
        // 再删除cell
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - cell编辑多按钮模式
///ios11.0以后
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    if (@available(iOS 11.0, *)) {
        WS(weakSelf);
        
        //删除
        UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            [weakSelf deleteData:indexPath];
            
            completionHandler (YES);
        }];
        //deleteRowAction.image = [UIImage imageNamed:@"icon_del"];
        deleteRowAction.backgroundColor = [UIColor redColor];
        
        //修改
        UIContextualAction *modifyRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"修改" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            [weakSelf deleteDataTwo:indexPath];
            
            completionHandler (YES);
        }];
        //deleteRowAction.image = [UIImage imageNamed:@"icon_del"];
        modifyRowAction.backgroundColor = [UIColor orangeColor];
        
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction,modifyRowAction]];
        
        return config;
        
    } else {
        // Fallback on earlier versions
        return nil;
    }
}


///ios8.0以后
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 添加一个删除按钮
    WS(weakSelf);
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [weakSelf deleteData:indexPath];
    }];
    
    // 一个修改按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"修改"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [weakSelf deleteDataTwo:indexPath];
    }];
    topRowAction.backgroundColor = UIColorFromRGB(250, 163, 92);
    
    
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, topRowAction];
}
- (void)deleteData:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了删除");
    
}
- (void)deleteDataTwo:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了修改");
    
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

#pragma mark - 复杂的网络数据请求（暂时放弃）
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
//处理modelData（这个方法一定要重写！！！！！数据请求完就会回调这个方法）
- (void)handleModelData:(id)object{
    
    //处理业务逻辑  (一个是列表数组 && 一个是model类数据)
    
    //刷新tableView
    [self.tableView reloadData];
    
}


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

///推进一个视图 && 把当前视图杀掉
- (void)popLasetVCAndpushViewController:(APPBaseViewController *)viewController{
    
    NSMutableArray *arrayVC = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [arrayVC removeLastObject];
    [arrayVC gf_addObject:viewController];
    
    [self.navigationController setViewControllers:arrayVC animated:YES];
    
    /**
    //清空中间的VC
    //获取导航视图栈内所有的视图
    NSMutableArray *navArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    if (navArr.count >= 2) {
        NSArray *newArray = @[[navArr firstObject],[navArr lastObject]];
        self.navigationController.viewControllers = newArray;
    }
     */
}

#pragma mark - 弹出模态视图


///弹出模态视图
- (void)presentViewController:(APPBaseViewController *)presentVC{
    
    presentVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:presentVC animated:YES completion:nil];
}

///弹出模态视图
- (void)presentViewController:(APPBaseViewController *)presentVC presentStyle:(UIModalTransitionStyle)presentStyle completionBlock:(void (^ __nullable)(void))completion{
    
    presentVC.modalTransitionStyle = presentStyle;
    
    [self presentViewController:presentVC animated:YES completion:completion];
}


#pragma mark - 系统UIButton方法自动添加

///给按钮添加事件
- (void)btnAddEventControlWithBtn:(UIButton *)button action:(SEL)action{
    
    //- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

///给按钮添加显示(默认状态)
- (void)btnAddTitleWithBtn:(UIButton *)button title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color{
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    [button setAttributedTitle:attrString forState:UIControlStateNormal];
}

///给按钮添加显示——设置状态
- (void)btnAddTitleWithBtn:(UIButton *)button title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color state:(UIControlState)state{
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    [button setAttributedTitle:attrString forState:state];
}


#pragma mark - 延时器执行方法

///延时几秒执行事件
- (void)performDelayerEventWithTimeOut:(NSInteger)timeOut block:(APPBackBlock)block{
    
    self.blockSEL = block;
    [self performSelector:@selector(performBlock) withObject:nil afterDelay:timeOut];
    
}

///延时几秒执行事件 + 传参对象
- (void)performDelayerEventWithTimeOut:(NSInteger)timeOut block:(APPBackBlock)block withObject:(nullable id)object{
    
    self.blockSEL = block;
    [self performSelector:@selector(handleDelayerEvent:) withObject:object afterDelay:timeOut];
    
}


///延时器执行事件
- (void)handleDelayerEvent:(id)object{
    
    if (self.blockSEL) {
        self.blockSEL(YES, object);
    }
}


@end
