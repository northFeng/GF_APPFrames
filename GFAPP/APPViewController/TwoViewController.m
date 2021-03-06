//
//  TwoViewController.m
//  GFAPP
//
//  Created by XinKun on 2017/11/11.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "TwoViewController.h"

#import "ThrViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建tableView
    [self createTableView];
    //特殊设置
    [self setTableViewAndPromptView];
    //创建其他视图
    [self createView];
    
    [self showPromptNonetView];
    
    [self startWaitingAnimating];
    
}

///设置导航栏样式
- (void)setNaviBarStyle{
    
    self.naviBarTitle = @"大喜宙";
    
    [self.naviBar setLeftFirstButtonWithTitleName:@"你好"];
    
    [self setStatusBarIsHide:NO];
    
    [self setStatusBarStyleLight];
    
}



#pragma mark - 初始化界面基础数据
- (void)initData {
    
    
}

#pragma mark - 特别设置tableView和提示图
- (void)setTableViewAndPromptView{
    //对tableView和提示图以及等待视图做一些特殊设置
    self.tableView.frame = CGRectMake(0, APP_NaviBarHeight, kScreenWidth, kScreenHeight - (APP_NaviBarHeight + APP_TabBarHeight));
    self.waitingView.color = [UIColor magentaColor];
}

#pragma mark - Init View  初始化一些视图之类的
- (void)createView{
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    ThrViewController *thr = [[ThrViewController alloc] init];
    
    [self.navigationController pushViewController:thr animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
