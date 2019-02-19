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
//自定义标注
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


//自定义标注视图
@interface FSPinAnnotiontaionView : BMKPinAnnotationView

///文字显示
@property (nonatomic,strong) FSMapLabel *labelPaopao;


@end



NS_ASSUME_NONNULL_END
