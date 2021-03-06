//
//  OneViewController.m
//  GFAPP
//
//  Created by XinKun on 2017/11/11.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "OneViewController.h"

#import "FivViewController.h"

#import "GFAudioPlayerViewController.h"

#import "GFTextField.h"

#import "GFSlideDeleteCell.h"
#import "GFTabBarController.h"

#import "APPLoacalInfo.h"

#import "TwoViewController.h"
#import "ThrViewController.h"


#import "MBProgressHUD.h"


#import "GFLabel.h"

#import "GFSegmentManager.h"

#import "GFTextField.h"//自定义输入框

#import "GFSelectPhoto.h"

#import "GFAVPlayerViewController.h"

#import <FengViewFunction/FengOneVC.h>

#import "FengTwoVC.h"

#import "NSString+Hash.h"

@import CoreLocation;

@interface OneViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

///
@property (nonatomic,strong) UIImage *imageXZQ;

///
@property (nonatomic,strong) UIImageView *iv;


/**  */
@property (nonatomic,strong) UIViewController *currentVC;

/**  */
@property (nonatomic,strong) TwoViewController *oneVC;

/**  */
@property (nonatomic,strong) UIImageView *imgView;



@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSMutableArray *arrayView = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        UILabel *view = [[UILabel alloc] init];
        view.text = @"附加费";
        if (i % 2) {
            view.backgroundColor = [UIColor redColor];
        }else{
            view.backgroundColor = [UIColor greenColor];
        }
        [arrayView addObject:view];
        [self.view addSubview:view];
    }
    
    
    [arrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(120);
        make.height.mas_equalTo(30);
    }];
    //[arrayView mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:60 leadSpacing:10 tailSpacing:10];
    [arrayView mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    
    NSString *signString = @"123456so_kc";
    signString = [signString sha256String];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
}




//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    /**
     UIViewAnimationOptionLayoutSubviews            = 1 <<  0,
     UIViewAnimationOptionAllowUserInteraction      = 1 <<  1, // turn on user interaction while animating
     UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2, // start all views from current value, not initial value
     UIViewAnimationOptionRepeat                    = 1 <<  3, // repeat animation indefinitely
     UIViewAnimationOptionAutoreverse               = 1 <<  4, // if repeat, run animation back and forth
     UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5, // ignore nested duration
     UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
     UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
     UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
     UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
     
     UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
     UIViewAnimationOptionCurveEaseIn               = 1 << 16,
     UIViewAnimationOptionCurveEaseOut              = 2 << 16,
     UIViewAnimationOptionCurveLinear               = 3 << 16,
     
     UIViewAnimationOptionTransitionNone            = 0 << 20, // default
     UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
     UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
     UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
     UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
     UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
     UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
     UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
     
     UIViewAnimationOptionPreferredFramesPerSecondDefault     = 0 << 24,
     UIViewAnimationOptionPreferredFramesPerSecond60          = 3 << 24,
     UIViewAnimationOptionPreferredFramesPerSecond30
     */
    
    NSArray *array = @[[NSNumber numberWithInteger:UIViewAnimationOptionLayoutSubviews],
                       [NSNumber numberWithInteger:UIViewAnimationOptionAllowUserInteraction],
                       [NSNumber numberWithInteger:UIViewAnimationOptionBeginFromCurrentState],
                       [NSNumber numberWithInteger:UIViewAnimationOptionRepeat],
                       [NSNumber numberWithInteger:UIViewAnimationOptionAutoreverse],
                       [NSNumber numberWithInteger:UIViewAnimationOptionOverrideInheritedDuration],
                       [NSNumber numberWithInteger:UIViewAnimationOptionOverrideInheritedCurve],
                       [NSNumber numberWithInteger:UIViewAnimationOptionAllowAnimatedContent],
                       [NSNumber numberWithInteger:UIViewAnimationOptionShowHideTransitionViews],
                       [NSNumber numberWithInteger:UIViewAnimationOptionOverrideInheritedOptions],
                       [NSNumber numberWithInteger:UIViewAnimationOptionCurveEaseInOut],
                       [NSNumber numberWithInteger:UIViewAnimationOptionCurveEaseIn],
                       [NSNumber numberWithInteger:UIViewAnimationOptionCurveEaseOut],
                       [NSNumber numberWithInteger:UIViewAnimationOptionCurveLinear],
                       [NSNumber numberWithInteger:UIViewAnimationOptionTransitionNone],
                       [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromLeft],
                       [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromRight],
                       [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCurlUp],
                       [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCurlDown],
                       [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCrossDissolve],
                       [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromTop],
                       [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromBottom],
                       [NSNumber numberWithInteger:UIViewAnimationOptionPreferredFramesPerSecondDefault],
                       [NSNumber numberWithInteger:UIViewAnimationOptionPreferredFramesPerSecond60],
                       [NSNumber numberWithInteger:UIViewAnimationOptionPreferredFramesPerSecond30]];
    
    NSNumber *num = array[arc4random()%(array.count-1)];
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.5 options:[num integerValue] animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
            
        }
    }];
}






///设置导航栏样式
- (void)setNaviBarStyle{
    //设置状态栏样式
    [self setStatusBarStyleDefault];
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
    self.tableView.frame = CGRectMake(0, APP_NaviBarHeight, kScreenWidth, kScreenWidth - (APP_NaviBarHeight + APP_TabBarHeight));
    self.waitingView.color = [UIColor magentaColor];
    
    [self.tableView registerClass:[GFSlideDeleteCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.separatorColor = [UIColor redColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Init View  初始化一些视图之类的
- (void)createView{
    

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




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ((GFSlideDeleteCell *)cell).delegate = self;
    ((GFSlideDeleteCell *)cell).cellIndexPath = indexPath;
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - 自定义代理设置滑动删除按钮
- (NSArray *)gfSlideDeleteCell:(GFSlideDeleteCell *)slideDeleteCell trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GFSwipeActionBtn *btn = [GFSwipeActionBtn rowActionWithStyle:GFSwipeActionStyleDefaule title:@"删除" image:nil actionWidth:80 backgroundColor:nil handler:^(NSIndexPath *indexPath) {
        NSLog(@"这是第一个按钮------>这是第：%ld个",indexPath.section);
    }];
    [btn setTitleColor:[UIColor redColor] forState:0];
    btn.backgroundColor = [UIColor lightGrayColor];
    
    GFSwipeActionBtn *btnTwo = [GFSwipeActionBtn rowActionWithStyle:GFSwipeActionStyleDefaule title:@"添加" image:nil actionWidth:100 backgroundColor:nil handler:^(NSIndexPath *indexPath) {
        NSLog(@"这是第二个按钮------>这是第：%ld个",indexPath.section);
    }];
    [btnTwo setTitleColor:[UIColor blueColor] forState:0];
    btnTwo.backgroundColor = [UIColor magentaColor];
    
    return @[btn,btnTwo];
}
///必须监听这个代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GFTableViewSlideNotice object:nil];
    
}



- (void)onClickBtn:(UIButton *)btn{
    
    NSLog(@"你点击了我！！！");
    
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
