//
//  OneViewController.m
//  GFAPP
//
//  Created by XinKun on 2017/11/11.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "OneViewController.h"

#import "FivViewController.h"
#import "GFButton.h"

#import "GFAudioPlayerViewController.h"

#import "GFTextField.h"

@interface OneViewController ()

///
@property (nonatomic,strong) UIImage *imageXZQ;

///
@property (nonatomic,strong) UIImageView *iv;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建tableView
    //[self createTableView];
    //特殊设置
    //[self setTableViewAndPromptView];
    //创建其他视图
    _imageXZQ = ImageFile(@"timg-2.jpeg", @"");
    [self createView];
    
//    [self showPromptNonetView];
//
    
    [self requestData];
    
    
    
}



///设置导航栏样式
- (void)setNaviBarState{
    //设置状态栏样式
    [self setStatusBarStyleLight];
    //设置状态栏是否隐藏
    //[self setStatusBarIsHide:YES];
    
    //设置导航条
    self.naviBarTitle = @"大主宰";
    [self.naviBar setLeftFirstButtonWithTitleName:@"返回"];
    
    self.naviBar.backgroundColor = [UIColor darkGrayColor];
    
}

#pragma mark - 初始化界面基础数据
- (void)initData {
    
    
}

#pragma mark - 特别设置tableView和提示图
- (void)setTableViewAndPromptView{
    //对tableView和提示图以及等待视图做一些特殊设置
    self.tableView.frame = CGRectMake(0, APP_NaviBarHeight, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - (APP_NaviBarHeight + APP_TabBarHeight));
    self.waitingView.color = [UIColor magentaColor];
}

#pragma mark - Init View  初始化一些视图之类的
- (void)createView{
    
    GFButton *btn = [GFButton buttonWithType:0];
    [btn setTitle:@"你好" labelSize:CGSizeMake(32, 16) labelFont:15 textColor:[UIColor redColor] imageName:@"ic_1_1" imgSize:CGSizeMake(40, 40) viewDirection:GFButtonType_Horizontal_ImgText spacing:4];
    btn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(200);
        make.width.and.height.mas_equalTo(100);
    }];
    
    
    GFTextField *textField = [[GFTextField alloc] initWithFrame:CGRectMake(100, 300, 200, 60)];
    textField.limitStringLength = 10;
    textField.backgroundColor = [UIColor greenColor];
    [self.view addSubview:textField];
        
}

#pragma mark - Network Request  网络请求
- (void)requestData{
    
    //[self requesModelDataWithUrl:@"http://www.baidu.com" params:nil odelClass:nil];
    
}

//处理modelData（这个方法一定要重写！！！！！数据请求完就会回调这个方法）
- (void)handleModelData:(id)object{
    
    //处理业务逻辑
    NSLog(@"处理完数据");
    //刷新tableView
    [self.tableView reloadData];
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //FivViewController需要设置为可以自由旋转的屏幕视图
//    FivViewController *fiv = [[FivViewController alloc] init];
//    fiv.naviBarTitle = @"南薛北张";
//    //这个方法是我们自己重写的方法
//    [self pushViewControllerWithRotateVC:fiv];
    
    GFAudioPlayerViewController *audioController = [[GFAudioPlayerViewController alloc] init];
    [self.navigationController pushViewController:audioController animated:YES];

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
