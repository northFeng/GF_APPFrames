//
//  FSGuideHandleVC.m
//  FlashSend
//
//  Created by gaoyafeng on 2019/4/18.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "FSGuideHandleVC.h"


NSString * const guideInfoKey = @"guideHandleInfo";


NSString * const FSGuideTypeHome = @"FSGuideTypeHome";//首页
NSString * const FSGuideTypeMine = @"FSGuideTypeMine";//个人中心
NSString * const FSGuideTypeSubmitOrder = @"FSGuideTypeSubmitOrder";//提交订单
NSString * const FSGuideTypeFillOrder = @"FSGuideTypeFillOrder";//填写订单

@interface FSGuideHandleVC ()

///文字图片
@property (nonatomic,strong,nullable) UIImageView *imgText;

///cellView图片
@property (nonatomic,strong,nullable) UIImageView *imgCellView;

///箭头指向
@property (nonatomic,strong,nullable) UIImageView *imgJT;

///下一步
@property (nonatomic,strong,nullable) UIButton *btnNext;

///跳过
@property (nonatomic,strong,nullable) UIButton *btnJump;

///要存储的key
@property (nonatomic,copy,nullable) NSString *storeKey;

@end


@implementation FSGuideHandleVC

///创建&&显示 操作指引
+ (void)showGuideHandleOnVC:(UIViewController *)superVC showType:(NSInteger)guideType{

//    if ([FSLoginManager isLoginToRequest]) {
//
//    }
    
    //登录
    NSDictionary *dicInfo = [APPUserDefault objectForKey:guideInfoKey];
    if (!dicInfo) {
        dicInfo = [NSDictionary dictionary];
    }
    
    NSString *typeKeyStr;
    NSString *keyStr;
    switch (guideType) {
        case 0:
            //首页
            typeKeyStr = dicInfo[FSGuideTypeHome];
            keyStr = FSGuideTypeHome;
            
            break;
        case 1:
            //个人中心
            typeKeyStr = dicInfo[FSGuideTypeMine];
            keyStr = FSGuideTypeMine;
            break;
        case 2:
            //提交订单
            typeKeyStr = dicInfo[FSGuideTypeSubmitOrder];
            keyStr = FSGuideTypeSubmitOrder;
            break;
        case 3:
            //填写订单
            typeKeyStr = dicInfo[FSGuideTypeFillOrder];
            keyStr = FSGuideTypeFillOrder;
            break;
            
        default:
            break;
    }
    
    if (typeKeyStr.length == 0) {
        
        //没有引导过
        FSGuideHandleVC *guideVC = [[FSGuideHandleVC alloc] init];
        guideVC.guideType = guideType;
        guideVC.storeKey = keyStr;
        
        [superVC addChildViewController:guideVC];
        [superVC.view addSubview:guideVC.view];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    [self createBaseView];
    
    switch (_guideType) {
        case 0:
            //首页
            [self addHomeGuide];
            
            break;
        case 1:
            //个人中心
            [self addShopGuide];
            
            break;
        case 2:
            //提交订单
            [self addSwitchSendAddressGuide];
            
            break;
        case 3:
            //填写订单
            [self addInsuranceGuide];
            
            break;
            
        default:
            break;
    }
}




///创建基本视图
- (void)createBaseView{
    
    _imgText = [[UIImageView alloc] init];
    [self.view addSubview:_imgText];
    
    _imgCellView = [[UIImageView alloc] init];
    [self.view addSubview:_imgCellView];
    
    _imgJT = [[UIImageView alloc] init];
    [self.view addSubview:_imgJT];
    
    _btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_btnNext];
    
    _btnJump = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnJump setImage:ImageNamed(@"guide_skip") forState:UIControlStateNormal];
    [_btnJump addTarget:self action:@selector(onClickBtnJump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnJump];
    
    _btnJump.sd_layout.rightSpaceToView(self.view, 18).topSpaceToView(self.view, kStatusBarHeight).widthIs(29).heightIs(22);
}

#pragma mark - 点击事件
///点击下一步 && 知道了
- (void)onClickBtnNext{
    
    [self saveGuideInfo];
}

///点击跳过
- (void)onClickBtnJump{
    
    [self saveGuideInfo];
}

///进行保存记录
- (void)saveGuideInfo{
    
    NSDictionary *dicInfo = [APPUserDefault objectForKey:guideInfoKey];
    if (!dicInfo) {
        dicInfo = [NSDictionary dictionary];
    }
    NSMutableDictionary *dicMutable = [NSMutableDictionary dictionaryWithDictionary:dicInfo];
    
    [dicMutable gf_setObject:[_storeKey copy] withKey:[_storeKey copy]];//添加引导记录
    [APPUserDefault setObject:[dicMutable copy] forKey:guideInfoKey];//存储信息
    [APPUserDefault synchronize];
    
    self.view.hidden = YES;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - 首页引导
///首页指引
- (void)addHomeGuide{
    
    self.imgCellView.image = ImageNamed(@"guide_home_shopbtn");
    self.imgCellView.frame = CGRectMake((kScreenWidth - 264)/2., kStatusBarHeight + 5, 264, 43);
    
    self.imgJT.image = ImageNamed(@"guide_jt_rt");
    self.imgJT.frame = CGRectMake(144*KSCALE, self.imgCellView.gf_MaxY + 18, 50, 45);
    
    self.imgText.image = ImageNamed(@"guide_home_text");
    self.imgText.frame = CGRectMake((kScreenWidth - 307)/2., self.imgJT.gf_MaxY, 307, 36);
    
    [self.btnNext setImage:ImageNamed(@"guide_isee") forState:UIControlStateNormal];
    self.btnNext.frame = CGRectMake((kScreenWidth - 124)/2., self.imgText.gf_MaxY + 46, 124, 58);
    
    [_btnNext addTarget:self action:@selector(onClickBtnNext) forControlEvents:UIControlEventTouchUpInside];
    _btnJump.hidden = YES;
}


#pragma mark - 个人中心引导
///店铺指引
- (void)addShopGuide{
    
    _imgText.image = ImageNamed(@"guide_mine_shop_text");
    _imgText.frame = CGRectMake((kScreenWidth - 267)/2., 255+kStatusBarHeight, 267, 55);
    
    _imgJT.image = ImageNamed(@"guide_jt_rb");
    _imgJT.frame = CGRectMake(kScreenWidth - 146*KSCALE, _imgText.gf_MaxY + 11, 50, 45);
    
    _imgCellView.image = ImageNamed(@"guide_mine_shop_cell");
    _imgCellView.frame = CGRectMake((kScreenWidth - 355)/2., _imgJT.gf_MaxY + 20, 355, 54);
    
    [_btnNext setImage:ImageNamed(@"guide_next") forState:UIControlStateNormal];
    _btnNext.frame = CGRectMake(118*KSCALE, _imgCellView.gf_MaxY + 39, 124, 58);
    
    [_btnNext addTarget:self action:@selector(addShopStaffGuide) forControlEvents:UIControlEventTouchUpInside];
}

///店员指引
- (void)addShopStaffGuide{
    
    [_btnNext removeTarget:self action:@selector(addShopStaffGuide) forControlEvents:UIControlEventTouchUpInside];
    [_btnNext addTarget:self action:@selector(addAfterSalesGuide) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.2 animations:^{
       
        self.imgText.image = ImageNamed(@"guide_mine_staff_text");
        self.imgText.frame = CGRectMake((kScreenWidth - 253)/2., 305+kStatusBarHeight, 253, 34);
        
        self.imgJT.image = ImageNamed(@"guide_jt_rb");
        self.imgJT.frame = CGRectMake(kScreenWidth - 149*KSCALE, self.imgText.gf_MaxY + 18, 50, 45);
        
        self.imgCellView.image = ImageNamed(@"guide_mine_staff_cell");
        self.imgCellView.frame = CGRectMake((kScreenWidth - 356)/2., self.imgJT.gf_MaxY + 30, 356, 54);
        
        [self.btnNext setImage:ImageNamed(@"guide_next") forState:UIControlStateNormal];
        self.btnNext.frame = CGRectMake(130*KSCALE, self.imgCellView.gf_MaxY + 46, 124, 58);
        
    }];
}

///售后指引
- (void)addAfterSalesGuide{
    _btnJump.hidden = YES;
    
    [_btnNext removeTarget:self action:@selector(addAfterSalesGuide) forControlEvents:UIControlEventTouchUpInside];
    [_btnNext addTarget:self action:@selector(onClickBtnNext) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.btnNext setImage:ImageNamed(@"guide_isee") forState:UIControlStateNormal];
        self.btnNext.frame = CGRectMake(122*KSCALE, 300+kStatusBarHeight, 124, 58);
        
        self.imgText.image = ImageNamed(@"guide_mine_sales_text");
        self.imgText.frame = CGRectMake((kScreenWidth - 289)/2., self.btnNext.gf_MaxY + 40, 289, 34);
        
        self.imgJT.image = ImageNamed(@"guide_jt_rb");
        self.imgJT.frame = CGRectMake(180*KSCALE, self.imgText.gf_MaxY + 18, 50, 45);
        
        self.imgCellView.image = ImageNamed(@"guide_mine_sales_cell");
        self.imgCellView.frame = CGRectMake((kScreenWidth - 356)/2., self.imgJT.gf_MaxY + 31, 356, 54);
        
    }];
}


#pragma mark - 提交订单指引
///切换发件地址指引
- (void)addSwitchSendAddressGuide{
    
    self.imgCellView.image = ImageNamed(@"guide_submit_send_cell");
    self.imgCellView.frame = CGRectMake((kScreenWidth - 351)/2., 57 + kStatusBarHeight, 351, 72);
    
    self.imgJT.image = ImageNamed(@"guide_jt_rt");
    self.imgJT.frame = CGRectMake(270*KSCALE, self.imgCellView.gf_MaxY + 18, 50, 45);
    
    self.imgText.image = ImageNamed(@"guide_submit_send_text");
    self.imgText.frame = CGRectMake((kScreenWidth - 271)/2., self.imgJT.gf_MaxY, 271, 36);
    
    [self.btnNext setImage:ImageNamed(@"guide_next") forState:UIControlStateNormal];
    self.btnNext.frame = CGRectMake((kScreenWidth - 124)/2., self.imgText.gf_MaxY + 46, 124, 58);
    
    [_btnNext addTarget:self action:@selector(addReceivePersonGuide) forControlEvents:UIControlEventTouchUpInside];
}

///添加收件人指引
- (void)addReceivePersonGuide{
    
    [_btnNext removeTarget:self action:@selector(addReceivePersonGuide) forControlEvents:UIControlEventTouchUpInside];
    [_btnNext addTarget:self action:@selector(addPriceDetailGuide) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.imgCellView.image = ImageNamed(@"guide_submit_receive_cell");
        self.imgCellView.frame = CGRectMake((kScreenWidth - 351)/2., 141 + kStatusBarHeight, 351, 72);
        
        self.imgJT.image = ImageNamed(@"guide_jt_rt");
        self.imgJT.frame = CGRectMake(128*KSCALE, self.imgCellView.gf_MaxY + 18, 50, 45);
        
        self.imgText.image = ImageNamed(@"guide_submit_receive_text");
        self.imgText.frame = CGRectMake((kScreenWidth - 313)/2., self.imgJT.gf_MaxY, 313, 36);
        
        [self.btnNext setImage:ImageNamed(@"guide_next") forState:UIControlStateNormal];
        self.btnNext.frame = CGRectMake((kScreenWidth - 124)/2., self.imgText.gf_MaxY + 46, 124, 58);
        
    }];
}

///查看价格指引
- (void)addPriceDetailGuide{
    _btnJump.hidden = YES;
    
    [_btnNext removeTarget:self action:@selector(addPriceDetailGuide) forControlEvents:UIControlEventTouchUpInside];
    [_btnNext addTarget:self action:@selector(onClickBtnNext) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.btnNext setImage:ImageNamed(@"guide_isee") forState:UIControlStateNormal];
        self.btnNext.frame = CGRectMake((kScreenWidth - 124)/2., kScreenHeight - (kTabBarBottomHeight+66) - (6+45) - (8+36) - (41+58), 124, 58);
        
        self.imgText.image = ImageNamed(@"guide_submit_price_text");
        self.imgText.frame = CGRectMake((kScreenWidth - 211)/2., kScreenHeight - (kTabBarBottomHeight+66) - (6+45) - (8+36), 211, 36);
        
        self.imgJT.image = ImageNamed(@"guide_jt_lb");
        self.imgJT.frame = CGRectMake(150*KSCALE, kScreenHeight - kTabBarBottomHeight - 66 - 6 - 45, 50, 45);
        
        self.imgCellView.image = ImageNamed(@"guide_submit_price_view");
        self.imgCellView.frame = CGRectMake((kScreenWidth - 375)/2., kScreenHeight - kTabBarBottomHeight - 66, 375, 66);
        
    }];
    
}

#pragma mark - 添加保价服务指引
///保价指引
- (void)addInsuranceGuide{
    
    self.imgCellView.image = ImageNamed(@"guide_submit_insurance_cell");
    self.imgCellView.frame = CGRectMake((kScreenWidth - 351)/2., kStatusBarHeight + 425, 351, 55);
    
    self.imgJT.image = ImageNamed(@"guide_jt_lb");
    self.imgJT.frame = CGRectMake(128*KSCALE, self.imgCellView.gf_Y - (4 + 45), 50, 45);
    
    self.imgText.image = ImageNamed(@"guide_submit_insurance_text");
    self.imgText.frame = CGRectMake((kScreenWidth - 259)/2., self.imgJT.gf_Y - (8 + 36), 259, 36);
    
    [self.btnNext setImage:ImageNamed(@"guide_isee") forState:UIControlStateNormal];
    self.btnNext.frame = CGRectMake((kScreenWidth - 124)/2., self.imgText.gf_Y - (42 + 58), 124, 58);
    
    [_btnNext addTarget:self action:@selector(onClickBtnNext) forControlEvents:UIControlEventTouchUpInside];
    _btnJump.hidden = YES;
}



@end
