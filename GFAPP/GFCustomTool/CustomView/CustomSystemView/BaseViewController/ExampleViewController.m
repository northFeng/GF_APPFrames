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

///初始化最基本数据
- (void)initBaseParams{
    
    
    
}

#pragma mark - 页面初始化 && 基本页面设置
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建其他视图
    [self createView];
    
    //[self.tableView.mj_header beginRefreshing];
    
}

///设置导航栏样式
- (void)setNaviBarStyle{
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
    //!!!cell 里面的block 必须用 weakSelf!!! (会引起循环引用)
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//
//    [cell setCellModel];
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    return cell;
    return NULL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - cell的回调处理


#pragma mark - 按钮点击事件


#pragma mark - 逻辑处理
/**
 正常情况下ViewController里面一般是不会存在private methods的，这个private methods一般是用于日期换算、图片裁剪啥的这种小功能。这种小功能要么把它写成一个category，要么把他做成一个模块，哪怕这个模块只有一个函数也行。
 */



#pragma mark - Init View  初始化一些视图之类的 && getter && setter 
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
    //[self.tableView registerClass:[FSOrderCell class] forCellReuseIdentifier:@"FSOrderCell"];//非Xib
    //[self.tableView registerNib:[UINib nibWithNibName:@"CFTradeCell" bundle:nil] forCellReuseIdentifier:@"tradeCell"];//Xib
    
    //移除旧的占位图 && 添加新的占位图
    [self.promptEmptyView removeFromSuperview];
    self.promptEmptyView = nil;
    self.promptEmptyView = [[GFNotifyView alloc] init];
    [self.tableView addSubview:self.promptEmptyView];
    //全部隐藏
    self.promptEmptyView.hidden = YES;
    self.promptEmptyView.sd_layout.leftEqualToView(self.tableView).rightEqualToView(self.tableView).topSpaceToView(self.tableView, 61*KSCALE).heightIs(216);
    
    //自定义无内容占位图
    UIView *emptyView = [[UIView alloc] init];
    emptyView.backgroundColor = [UIColor clearColor];
    emptyView.frame = CGRectMake(0, 0, kScreenWidth, 216);
    UIImageView *imgQS = [[UIImageView alloc] init];
    imgQS.image = ImageNamed(@"home_qs");
    [emptyView addSubview:imgQS];
    imgQS.sd_layout.centerXEqualToView(emptyView).topEqualToView(emptyView).widthIs(141).heightIs(137);
    UILabel *label = [GFFunctionMethod view_createLabelWith:@"很抱歉，暂未找到您搜索的地址，建议您扩 大关键词进行搜索" font:14 textColor:[UIColor grayColor] textAlignment:NSTextAlignmentCenter textWight:0];
    label.numberOfLines = 2;
    [emptyView addSubview:label];
    label.sd_layout.centerXEqualToView(emptyView).bottomEqualToView(emptyView).widthIs(266).heightIs(40);
    
    //[self.promptEmptyView addCoustomBackView:emptyView];
    
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
