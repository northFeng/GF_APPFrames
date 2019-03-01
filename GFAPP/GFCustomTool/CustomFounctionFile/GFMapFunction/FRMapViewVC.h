//
//  FRMapViewVC.h
//  FlashRider
//  地图展示视图
//  Created by gaoyafeng on 2019/1/22.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSBaiDuMapManager.h"//地图管理者

#import "FROrderModel.h"//model

NS_ASSUME_NONNULL_BEGIN

@interface FRMapViewVC : UIViewController

///地图
@property (nonatomic,strong) BMKMapView *mapView;

///定位模式 默认跟随模式
@property (nonatomic,assign) BMKUserTrackingMode trackingMode;

///精度 （默认17） 手机上当前可使用的级别为4-21级
@property (nonatomic,assign) NSInteger zoomLevel;

///百度logo位置 (默认左下)
@property (nonatomic,assign) BMKLogoPosition logoPosition;

///是否显示底层标注  默认YES
@property (nonatomic,assign) BOOL showMapPoi;

//手势功能默认都有

///手指点击
@property (nonatomic,assign) BOOL gesturesTap;

///平移地图
@property (nonatomic,assign) BOOL gesturesScroll;

///旋转地图
@property (nonatomic,assign) BOOL gesturesRotate;

///俯视地图
@property (nonatomic,assign) BOOL gesturesOverlook;



///刷新地图
- (void)refreshMap;

///显示比例尺
- (void)showMapScaleBarWithBarposition:(CGPoint)barPoint;

///隐藏比例尺
- (void)hideScaleBar;

///设置新的地图中心点
- (void)changeMapCenterCoordinate:(CLLocationCoordinate2D)newCenter;

///为订单详情特殊设置中心点偏上移
- (void)changeMapCenterCoordinateForOrderDetail:(CLLocationCoordinate2D)newCenter;

///设置地图显示范围
- (void)setMapShowRegionWithRegion:(BMKCoordinateSpan)span;


#pragma mark - 赋值数据 && 添加标注
///赋值订单详情model信息
- (void)setMarkInfoModel:(OrderListModel *)orderDetailModel childModel:(OrderChildModel *)childModel;

///刷新导航路线 type: 0:店铺    1:收件人   2:清除导航路径
- (void)setMapNogationRouteWithType:(NSInteger)type;



///销毁地图
- (void)deallocBKMap;

@end

#pragma mark - 路径规划分类 PathPlanning
@interface FRMapViewVC (PathPlanning)


///路径规划 0:店铺    1:收件人   2:清除导航路径
- (void)searchDataCyclingPlanningWithPlanStyle:(NSInteger)planStyle;


@end



#pragma mark - 自定义标注 && 泡泡视图
//自定义标注(注册用的)——>通过这个注册标注 来传递信息给 ——> 显示标注
@interface FSAnnotation : BMKPointAnnotation

///距离
@property(nonatomic,copy) NSString *distance;

///收件人类型 （顺序）
@property(nonatomic,assign) int type;

@end



//自定义泡泡弹框
@interface FSMapLabel : UIView

///视图宽度
@property (nonatomic,assign) CGFloat widthView;

///普通文字
- (void)setTextTitle:(NSString *)title;

///富文本
- (void)setAttrbuteString:(NSAttributedString *)title;

@end


//自定义标注视图(展示标注用的)
@interface FSPinAnnotiontaionView : BMKPinAnnotationView

///文字显示
@property (nonatomic,strong) FSMapLabel *labelPaopao;


@end



NS_ASSUME_NONNULL_END

#pragma mark - 滑动冲突解决
/**
- (void)createView{
    
    //创建scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopNaviBarHeight, kScreenWidth, kScreenHeight - kTopNaviBarHeight)];
    self.scrollView.delegate = self;
    _scrollView.backgroundColor = APPColor_White;
    _scrollView.clipsToBounds = YES;
    //_scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - kTopNaviBarHeight);//根据内容去计算
    [self.view addSubview:_scrollView];
    
    CGRect backRect;
    //判断状态
    if (_orderCurrentStatus == APPEnumOrderState_complete || _orderCurrentStatus == APPEnumOrderState_cancle) {
        
        backRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTopNaviBarHeight);
    }else{
        //创建地图
        FSMapViewVC *mapVC = [[FSMapViewVC alloc] init];
        //设置地图
        mapVC.gesturesTap = NO;
        mapVC.gesturesRotate = NO;
        mapVC.gesturesScroll = YES;
        mapVC.gesturesOverlook = NO;
        
        [self addChildViewController:mapVC];
        mapVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTopNaviBarHeight);
        [self.scrollView addSubview:mapVC.view];
        
        _mapVC = mapVC;
        _mapView = mapVC.view;
        
        //添加手势
        // 给主scrollview 添加手势
        UIGestureRecognizer *mainScrollVTap = [[UIGestureRecognizer alloc]init];
        mainScrollVTap.delegate = self;
        [self.scrollView addGestureRecognizer:mainScrollVTap];
        //手势随便加
        UITapGestureRecognizer *provinceMapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(provinceMapTapped)];
        provinceMapTap.delegate = self;
        [self.mapVC.mapView addGestureRecognizer:provinceMapTap];
        
        //刷新按钮
        _btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRefresh setImage:ImageNamed(@"map_sx") forState:UIControlStateNormal];
        [self.mapVC.mapView addSubview:_btnRefresh];
        _btnRefresh.frame = CGRectMake(kScreenWidth - 44, (kScreenHeight - kTopNaviBarHeight) - 200 - 68, 34, 34);
        [_btnRefresh addTarget:self action:@selector(onClickBtnRefresh) forControlEvents:UIControlEventTouchUpInside];
        
        backRect = CGRectMake(0, (kScreenHeight - kTopNaviBarHeight) - 200, kScreenWidth, kScreenHeight);
        
        //添加信息视图尾部视图
        [self.scrollView addSubview:self.footView];
    }
    
    //添加backView
    _backView = [[FSOrderContentView alloc] initWithFrame:backRect];
    _backView.backgroundColor = [UIColor clearColor];
    _backView.clipsToBounds = YES;
    [_scrollView addSubview:_backView];
    
    if (_footView) {
        //设置约束 ——>为backView的尾部跟随视图
        self.footView.sd_layout.leftEqualToView(self.scrollView).rightEqualToView(self.scrollView).topSpaceToView(self.backView, 0).heightIs(kScreenHeight);
    }
    
    //添加取消弹框 和 添加小费弹框
    [self addCancleAlertView];
    
    //backView的回调事件
    APPWeakSelf;
    //待支付——->超时自动取消
    _backView.blockAutoCancle = ^(BOOL result, id idObject) {
        
        [weakSelf autoCancleOrder];
    };
    
}

///渐变视图
- (UIView *)footView{
    
    if (!_footView) {
        _footView = [[UIView alloc] init];
        _footView.backgroundColor = APPColor_White;
    }
    return _footView;
}

#pragma mark - 地图和scrollView冲突解决
///地图添加的手势
- (void)provinceMapTapped{
    
}
///手势触摸之前就会触发这个代理
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //判断如果是百度地图的view 既可以实现手势拖动 scrollview 的滚动关闭
    
    if ([gestureRecognizer.view isKindOfClass:[BMKMapView class]] ){
        
        self.scrollView.scrollEnabled = NO;
        
        return YES;
    }else{
        
        self.scrollView.scrollEnabled = YES;
        
        return NO;
    }
    
}

//不断改变地图的显示
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = self.scrollView.contentOffset.y;
    
    //使地图的位置固定
    self.mapView.frame = CGRectMake(0, y, kScreenWidth, kScreenHeight - kTopNaviBarHeight);
}

#pragma mark - 添加渐变视图
///添加竖向的混合颜色
- (void)view_addHybridBackgroundColorShowOnView:(UIView *)onView{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    UIColor *color1 = [APPColor_White colorWithAlphaComponent:0.0];
    UIColor *color2 = [APPColor_White colorWithAlphaComponent:0.2];
    UIColor *color3 = [APPColor_White colorWithAlphaComponent:0.3];
    UIColor *color4 = [APPColor_White colorWithAlphaComponent:0.5];
    UIColor *color5 = [APPColor_White colorWithAlphaComponent:1.0];
    gradientLayer.colors = @[(__bridge id)color1.CGColor, (__bridge id)color2.CGColor, (__bridge id)color3.CGColor, (__bridge id)color4.CGColor, (__bridge id)color5.CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @0.7, @0.9, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = CGRectMake(0, 0, onView.frame.size.width, onView.frame.size.height);
    
    //[onView.layer addSublayer:gradientLayer];
    [onView.layer insertSublayer:gradientLayer atIndex:0];
}
 
 */

