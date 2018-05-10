//
//  GFTabBarController.m
//  GFAPP
//
//  Created by XinKun on 2017/11/10.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFTabBarController.h"

//常量命名规则（驼峰式命名规则），所有的单词首字母大写和加上与类名有关的前缀:
//文字默认和选中时颜色
#define ColorTabBar_TextSelect [UIColor blueColor]
#define ColorTabBar_TextNormal [UIColor grayColor]
#define ColorTabBar [UIColor whiteColor]
//分割线
#define ColorSegmentation [UIColor blueColor]

////顶部条以及tabBar条的宽度，以及工具条距离安全区域的距离(最好放在外部全局来使用)
//#define APP_NaviBarHeight (iPhoneX ? 88. : 64.)
//#define APP_TabBarHeight (iPhoneX ? 83. : 49.)
//#define APP_NaviBar_ItemsHeight 44.
//#define APP_TabBar_ItemsHeight 49.

@interface GFTabBarController ()
{
    UIView *_customTaBar;//自定义tabBar
    
    UIView *_itemsView;//管理子视图去
    
    NSMutableArray *_arrayBackBtn;
    
    //默认图片的名字数组
    NSMutableArray *_arrayNormalImage;
    //选中按钮图片数组
    NSMutableArray *_arraySelectImage;
    //按钮标题
    NSArray *_arrayTitle;
    
}
@property (nonatomic,strong) UIButton *lastSelectBackBtn;//记录上一次选中的按钮
@property (nonatomic,strong) UIImageView *lastSelectImage;//记录上一次选中的图片
///记录上一次的label
@property (nonatomic,strong) UILabel *lastSelectLab;


@end

@implementation GFTabBarController

+ (GFTabBarController *)sharedInstance
{
    static GFTabBarController *tabBar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBar = [[GFTabBarController alloc] init];
    });
    return tabBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    _arrayBackBtn = [NSMutableArray array];
    
    //创建tabBar基本视图
    [self createCustomTabBar];
    
}

///创建Items,并设置默认第一个显示位置
-(void)creatItemsWithDefaultIndex:(NSInteger)defaultIndex normalImageNameArray:(NSArray *)arrayNomal selectImageArray:(NSArray *)arraySelect itemsTitleArray:(NSArray *)titleArray{
    
    //放到外部来创建
//    //默认图片
//    NSArray *arrayNomal = @[@"ic_1_2",@"ic_2_2",@"ic_3_2",@"ic_4_2"];
//    //选中按钮的图片
//    NSArray *arraySelect = @[@"ic_1_1",@"ic_2_1",@"ic_3_1",@"ic_4_1",];
//
//    //item的标题
//    _arrayTitle = @[@"首页",@"案例",@"搜索",@"我的"];
    
    //赋值数据
    _arrayTitle = titleArray;
    _arrayNormalImage = [NSMutableArray array];
    _arraySelectImage = [NSMutableArray array];
    
    for (NSString *iamgeString in arrayNomal) {
        UIImage *iamge = [UIImage imageNamed:iamgeString];
        [_arrayNormalImage addObject:iamge];
    }
    for (NSString *iamgeString in arraySelect) {
        UIImage *iamge = [UIImage imageNamed:iamgeString];
        [_arraySelectImage addObject:iamge];
    }
 
    //btn的个数
    NSInteger numberOfBnt = _arrayNormalImage.count;
    //btn的宽度
    CGFloat btnWidth = APP_SCREEN_WIDTH/numberOfBnt;
    
    //循环创建btn
    UIImage *imageSize;
    for (int i = 0; i < numberOfBnt; i++) {
        //到时候可以自己封装个按钮 这样简单一些
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];//底部按钮
        backBtn.tag = 10+i;
        backBtn.backgroundColor = [UIColor clearColor];
        
        //这里可以设置图片的大小 CGRectMake(i*btnWidth, 5, btnWidth, btnHeight)
        UIImageView *btnImage = [[UIImageView alloc] init];
        btnImage.userInteractionEnabled = NO;
        btnImage.backgroundColor = [UIColor clearColor];
        btnImage.image = _arrayNormalImage[i];
        btnImage.tag  = 20+i;
        [backBtn addSubview:btnImage];//加入底部按钮
        imageSize = _arrayNormalImage[i];
        
        //创建文字
        UILabel *lab = [[UILabel alloc] init];
        lab.backgroundColor = [UIColor clearColor];
        lab.userInteractionEnabled = NO;
        lab.tag = 30+i;
        lab.text = _arrayTitle[i];
        lab.textColor = ColorTabBar_TextNormal;
        lab.font = [UIFont systemFontOfSize:13];
        lab.textAlignment = NSTextAlignmentCenter;
        [backBtn addSubview:lab];//加入底部按钮
        
        /**
         * *****************************************************
         *
         * ******************** 布局图片和文字的约束  *************
         *
         * ****************************************************
         */
        //图片
        [btnImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backBtn);
            make.top.equalTo(backBtn).offset(5);
            make.width.mas_equalTo(imageSize.size.width);
            make.height.mas_equalTo(imageSize.size.height);
        }];
        //文字
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btnImage);
            make.centerY.equalTo(btnImage).offset(imageSize.size.height/2.+10);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(18);
        }];
        
        //默认第一次进来选中位置
        if (i == defaultIndex) {
            //设置被选中的视图
            self.selectedIndex = defaultIndex;
            
            //设置选中图片和文字
            btnImage.image = _arraySelectImage[defaultIndex];
            lab.textColor = ColorTabBar_TextSelect;
            
            _lastSelectBackBtn = backBtn;
            _lastSelectImage = btnImage;
            _lastSelectLab = lab;
        }
        
        
        [_itemsView addSubview:backBtn];
        
        ///点击事件
        [backBtn addTarget:self action:@selector(onClickTabBarItemsBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_arrayBackBtn addObject:backBtn];
    }
    
    //布局items约束
    [self layoutItemsConstraints];
    
}

#pragma mark - tabBar内部点击事件切换视图
///处理items点击逻辑事件
-(void)onClickTabBarItemsBtn:(UIButton *)btn{
    if (btn != _lastSelectBackBtn) {
        
        //这个是UITabBarController的属性
        self.selectedIndex = btn.tag-10;
        
        //把上一次选中的btn的selected = NO
        _lastSelectImage.image = _arrayNormalImage[_lastSelectImage.tag-20];
        _lastSelectLab.textColor = ColorTabBar_TextNormal;
        
        //把本次的点击的btn的selected = YES
        UIImageView *btnImage = (UIImageView *)[_itemsView viewWithTag:20+self.selectedIndex];
        btnImage.image = _arraySelectImage[self.selectedIndex];
        
        UILabel *lab = (UILabel *)[_itemsView viewWithTag:30+self.selectedIndex];
        lab.textColor = ColorTabBar_TextSelect;
        
        //改变最后一次选中的按钮
        _lastSelectBackBtn = btn;
        _lastSelectImage = btnImage;
        _lastSelectLab = lab;
    }
}

#pragma mark - 切换TabBar上的VC && 切换按钮样式(外部控制)
- (void)setSelectItemBtnIndex:(NSInteger)indexItem{
    //self.selectedViewController; 获取所选取的VC
    UIButton *btn = (UIButton *)[_itemsView viewWithTag:indexItem + 10];
    
    [self onClickTabBarItemsBtn:btn];
}


#pragma mark - 创建tabBar基本视图
///创建tabBar基本视图
- (void)createCustomTabBar{
    
    //隐藏系统按钮
    self.tabBar.hidden = YES;
    
    //创建自定义tabBar
    _customTaBar = [[UIView alloc] init];
    _customTaBar.backgroundColor = ColorTabBar;
    [self.view addSubview:_customTaBar];
    [_customTaBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view);
        make.height.mas_equalTo(APP_TabBarHeight);
    }];
    
    //创建items条（这里用约束去设置，这样 在 开 个人热点的时候也不会压下去）
    _itemsView = [[UIView alloc] init];//WithFrame:CGRectMake(0,kScreenHeight-49 ,kScreenWidth, 49)];
    _itemsView.backgroundColor = [UIColor clearColor];
    
    //添加分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorSegmentation;
    [_itemsView addSubview:lineView];
    
    [self.view addSubview:_itemsView];
    
    //添加约束
    [_itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(_customTaBar);
        make.height.mas_equalTo(APP_TabBar_ItemsHeight);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(_itemsView);
        make.height.mas_equalTo(0.5);
    }];
    
}

///布局items约束
- (void)layoutItemsConstraints{
    
    //建立约束
    for (int i=0; i<_arrayBackBtn.count; i++) {
        
        UIButton *btnSuper;
        UIButton *btn = _arrayBackBtn[i];
        UIButton *btnNext;
        if (i==0) {
            btnNext = _arrayBackBtn[i+1];
        }
        
        if (i>=1) {
            btnSuper = _arrayBackBtn[i-1];
        }
        
        if (i==0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.and.bottom.equalTo(_itemsView);
                make.width.equalTo(btnNext);
            }];
        }else{
            if (i==_arrayBackBtn.count-1) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(btnSuper.mas_right);
                    make.top.bottom.and.width.equalTo(btnSuper);
                    make.right.equalTo(_itemsView);
                }];
                
            }else{
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(btnSuper.mas_right);
                    make.top.bottom.width.equalTo(btnSuper);
                }];
            }
        }
    }
}

///设置TabBar颜色 && 按钮条背景颜色
- (void)setTabBarColor:(UIColor *)tabBarColor itemsBtnBarColor:(UIColor *)itemsBarColor{
    
    _customTaBar.backgroundColor = tabBarColor;
    
    _itemsView.backgroundColor = itemsBarColor;
}

#pragma mark - 屏幕方向控制
- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [self.selectedViewController supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}




@end
