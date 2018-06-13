//
//  ExampleViewController.m
//  GFAPP
//
//  Created by XinKun on 2017/11/24.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "ExampleViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

#pragma mark - 页面初始化 && 基本页面设置
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建其他视图
    [self createView];
    
    //[self.tableView.mj_header beginRefreshing];
    
}

///设置导航栏样式
- (void)setNaviBarState{
    //设置状态栏样式
    [self setStatusBarStyleLight];
    //设置状态栏是否隐藏
    //[self setStatusBarIsHide:YES];
    
    //设置导航条
    self.naviBarTitle = @"标题";
    [self.naviBar setLeftFirstButtonWithTitleName:@"返回"];
    
    self.naviBar.backgroundColor = [UIColor darkGrayColor];
    
}

/*
//开启自动旋转屏幕
- (BOOL)shouldAutorotate{
    
    return NO;
}
//设置旋转屏幕方向---->左横和右横
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
 */

//初始化界面基础数据
- (void)initData {
    
    
}


#pragma mark - Init View  初始化一些视图之类的
- (void)createView{
    
    //创建tableView
    [self createTableView];
    //添加上拉下拉
    [self addTableViewRefreshView];
    
    //特别设置tableView和提示图
    //self.waitingView.color = [UIColor magentaColor];
    
    //    self.tableView.frame = CGRectMake(0, KTopHeight, KScreenWidth, KScreenHeight - KTopHeight);
    //    self.tableView.backgroundColor = RGBCOLORX(248);
    //注册cell
    //[self.tableView registerNib:[UINib nibWithNibName:@"CFTradeCell" bundle:nil] forCellReuseIdentifier:@"tradeCell"];
    
}

#pragma mark - Network Request  网络请求
- (void)requestNetData{
    NSLog(@"请求数据");
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //可使用的
    [params setObject:[NSNumber numberWithInteger:self.page]  forKey:@"pageNo"];
    //一次拉取10条
    [params setObject:[NSNumber numberWithInt:10]  forKey:@"pageSize"];
    
    //复杂版
    //[self requestDataWithUrl:@"url" params:nil odelClass:[Model class]];
    
    //简版网络请求
    //[self requestNetDataUrl:nil params:params];
}

//处理modelData（这个方法一定要重写！！！！！数据请求完就会回调这个方法）
- (void)handleModelData:(id)object{
    
    //处理业务逻辑
    
    //刷新tableView
    [self.tableView reloadData];
    
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


#pragma mark - 其他视图的 事件协议代理处理方法
//命名规则
- (void)XXXView_OnClickXXXBtn:(id)sender{
    
    NSLog(@"点击XXXView上的XXX按钮");
    
    //ViewModel来处理 数据业务
    
}







@end
