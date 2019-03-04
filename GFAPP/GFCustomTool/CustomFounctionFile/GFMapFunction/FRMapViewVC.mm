//
//  FRMapViewVC.m
//  FlashRider
//
//  Created by gaoyafeng on 2019/1/22.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "FRMapViewVC.h"

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKCustomViewHierarchy";

//BMKMapViewDelegate:百度地图代理  BMKLocationManagerDelegate:百度地图管理者代理  BMKRouteSearchDelegate:骑行规划代理
@interface FRMapViewVC () <BMKMapViewDelegate,BMKLocationManagerDelegate,BMKRouteSearchDelegate>

@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象

//定位标注
@property (nonatomic, strong) BMKLocationViewDisplayParam *param; //定位图层自定义样式参数


///发送位置标注
@property (nonatomic, strong) FSAnnotation *markSend;

///收件位置标注
@property (nonatomic, strong) FSAnnotation *markReceived;

///路径规划搜索
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

//******************** 路径规划需要的属性 ********************
///路径规划起点坐标
@property (nonatomic) CLLocationCoordinate2D startPt;

///路径规划终点坐标
@property (nonatomic) CLLocationCoordinate2D endPt;

///路径规划 划线 折点对象
@property (nonatomic,strong,nullable) BMKPolyline *polyline;

///路径规划生产的折线坐标个数
@property (nonatomic,assign) NSInteger pointCount;


@end

@implementation FRMapViewVC
{
    
    CLLocationCoordinate2D *_coors;
    
    BOOL _isFirstLoad;
    
    //订单详情model
    OrderListModel *_modelOrder;
    
    OrderChildModel *_childModel;//子订单
    
    FSMapLabel *_labelSendPaopao;//发标注上的label
    
    CLLocationCoordinate2D _currentCoordinate;
    
    NSInteger _planeType;
}


- (void)dealloc {
    
    //销毁地图
    [self deallocBKMap];
}

///销毁地图
- (void)deallocBKMap{
    
    if (_mapView) {
        //地图死亡了必须关掉!
        [BMKMapView enableCustomMapStyle:NO];
        
        _mapView = nil;
    }
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //...配置
        [self initData];//初始化数据
    }
    return self;
}

///初始化变量
- (void)initData{
    
    _isFirstLoad = YES;
    
    _trackingMode = BMKUserTrackingModeFollow;
    
    _zoomLevel = 16;
    
    _logoPosition = BMKLogoPositionLeftBottom;
    
    _showMapPoi = YES;
    
    ///地图是否可以有手势功能 默认YES
    
    ///手指点击
    _gesturesTap = YES;
    
    ///平移地图
    _gesturesScroll = YES;
    
    ///旋转地图
    _gesturesRotate = YES;
    
    ///俯视地图
    _gesturesOverlook = YES;
    
    _planeType = -1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
    
    if (_isFirstLoad) {
        _isFirstLoad = NO;
        //地图显示立即进行定位跟随模式
        [self startFollowing];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}

///set方法
- (void)setZoomLevel:(NSInteger)zoomLevel{
    
    _zoomLevel = zoomLevel;
    if (_mapView) {
        //地图精度
        _mapView.zoomLevel = _zoomLevel;
    }
}

///刷新地图
- (void)refreshMap{
    
    [_mapView mapForceRefresh];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    
    //自定义地图文件JSON(必须在创建地图之前使用！！)
    NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_config_0323" ofType:@""];
    [BMKMapView customMapStyle:path];
    
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    //打开个性化地图（必须在创建地图后使用！！地图死亡了必须关掉！）
    [BMKMapView enableCustomMapStyle:YES];
    
    
    //设置mapView的代理
    _mapView.delegate = self;
    
    //更新定位信息（不需要定位信息）
    [self setupLocationManager];
}


#pragma mark - 进入定位跟随模式
//跟随态
-(void)startFollowing
{
    NSLog(@"进入跟随态");
    
    //设置地图中心点(不设置默认到天安门)
    [self changeMapCenterCoordinate:CLLocationCoordinate2DMake(39.2938393, 114.3938292)];
    //初始化当前定位
    _currentCoordinate = CLLocationCoordinate2DMake(39.2938393, 114.3938292);
    //地图精度
    _mapView.zoomLevel = _zoomLevel;
    
    //开启定位服务
    [self.locationManager startUpdatingLocation];//开始连续定位
    [self.locationManager startUpdatingHeading];//开始设备朝向事件回调
    //显示定位图层
    _mapView.showsUserLocation = YES;
    
    //使用跟随功能
    _mapView.userTrackingMode = _trackingMode;
}


#pragma mark - 自定义定位样式 && 功能
- (void)setupLocationManager {
    
    //开启定位服务
    [self.locationManager startUpdatingLocation];
    //设置显示定位图层
    _mapView.showsUserLocation = YES;
    
    
    //配置定位图层个性化样式，初始化BMKLocationViewDisplayParam的实例
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    //设置定位图标(屏幕坐标)X轴偏移量为0
    param.locationViewOffsetX = 0;
    //设置定位图标(屏幕坐标)Y轴偏移量为0
    param.locationViewOffsetY = 0;
    //设置定位图层locationView在最上层(也可设置为在下层)
    param.locationViewHierarchy = LOCATION_VIEW_HIERARCHY_TOP;
    //设置定位图标，需要将该图片放到mapapi.bundle/images目录下
    //param.locationViewImgName = @"map_local";
    param.locationViewImage = [UIImage imageNamed:@"map_local"];
    //设置显示精度圈
    param.isAccuracyCircleShow = NO;
    ///是否显示气泡，默认YES
    param.canShowCallOut = NO;
    //更新定位图层个性化样式
    [_mapView updateLocationViewWithParam:param];
    
    self.param = param;
}

#pragma mark - 定位代理回调 BMKLocationManagerDelegate
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    NSLog(@"定位失败");
}
//更新用户方向信息
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    NSLog(@"用户方向更新");
    
    self.userLocation.heading = heading;
    [_mapView updateLocationData:self.userLocation];
}

//更新定位信息 && 连续定位回调函数。
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    
    self.userLocation.location = location.location;//定位信息（这里可以设置成全局变量）
    //实现该方法，否则定位图标不出现
    [_mapView updateLocationData:self.userLocation];
    
    //更新当前位置坐标
    _currentCoordinate = location.location.coordinate;
    
    //设置  定位标注   的经纬度坐标
    //_annotation.coordinate = self.userLocation.location.coordinate;
    
    /**
    //时时 更新路径规划
    if (_planeType == 0 || _planeType == 1) {
        [self searchDataCyclingPlanningWithPlanStyle:_planeType];
    }
     */
}

#pragma mark - 百度地图代理BMKMapViewDelegate  && 添加标注

///添加一个标注
- (void)addLocationAnnotation {
    //初始化标注类BMKPointAnnotation的实例
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    /**
     
     当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
     来生成标注对应的View
     @param annotation 要添加的标注
     */
    [_mapView addAnnotation:annotation];
    //_annotation = annotation;
}

#pragma mark - 赋值数据 && 添加标注
///赋值订单详情model信息
- (void)setMarkInfoModel:(OrderListModel *)orderDetailModel childModel:(OrderChildModel *)childModel{
    
    _modelOrder = orderDetailModel;
    _childModel = childModel;
    
    /////10："待支付"、20:“派件中”, 30："待取货"、40："闪送中"、50： "已完成" 、60： "已取消"
    
    //移除旧的
    [_mapView removeAnnotations:_mapView.annotations];
    
    //添加标注先后顺序 ---> 标注显示图层顺序
    //取件标注
    _markSend = [[FSAnnotation alloc] init];
    _markSend.coordinate = CLLocationCoordinate2DMake([[orderDetailModel.location gf_getItemWithIndex:1] doubleValue],[[orderDetailModel.location gf_getItemWithIndex:0] doubleValue]);
    [_mapView addAnnotation:_markSend];

    
    //添加收件标注
    _markReceived = [[FSAnnotation alloc] init];
    _markReceived.coordinate = CLLocationCoordinate2DMake([childModel.latitude doubleValue],[childModel.longitude doubleValue]);
    [_mapView addAnnotation:_markReceived];
    
}

///刷新导航路线
- (void)setMapNogationRouteWithType:(NSInteger)type{
    
    _planeType = type;
    
    //路径规划
    [self searchDataCyclingPlanningWithPlanStyle:type];
}


#pragma mark - 根据anntation生成对应的annotationView
/**
 根据anntation生成对应的annotationView
 
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    
    if (annotation == _markSend) {
        //发件
        FSPinAnnotiontaionView *sendView = (FSPinAnnotiontaionView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"send"];
        
        if (!sendView) {
            sendView = [[FSPinAnnotiontaionView alloc] initWithAnnotation:annotation reuseIdentifier:@"send"];
            sendView.image = [UIImage imageNamed:@"order_takegood"];
            sendView.centerOffset = CGPointMake(0, -(sendView.frame.size.height * 0.4));
        }

        return sendView;
    }else if (annotation == _markReceived){
        //骑手
        BMKPinAnnotationView *receivedView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"received"];
        if (!receivedView) {
            
            receivedView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"received"];
            receivedView.image = [UIImage imageNamed:@"order_sendgood"];
            receivedView.centerOffset = CGPointMake(0, -(receivedView.frame.size.height * 0.4));
        }
        
        return receivedView;
    }
    /**
    else if ([annotation isKindOfClass:[FSAnnotation class]]){
        //收件
        FSPinAnnotiontaionView *annotationView = (FSPinAnnotiontaionView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"shoujianren"];
        if (!annotationView) {
            
            annotationView = [[FSPinAnnotiontaionView alloc] initWithAnnotation:annotation reuseIdentifier:@"shoujianren"];
            
            NSString *imageStr;
            if (_modelOrder.receivers.count == 1) {
                imageStr = @"map_sj";
            }else{
                imageStr = [NSString stringWithFormat:@"map_%d",((FSAnnotation *)annotation).type];
            }
            annotationView.image = [UIImage imageNamed:imageStr];
            annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.4));
            
            //显示文字--->距离
            FSMapLabel *maplabel = [[FSMapLabel alloc] init];
            maplabel.widthView = 160.;
            [annotationView addSubview:maplabel];
            [maplabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(annotationView);
                make.bottom.equalTo(annotationView.mas_top).offset(-0);
                make.width.mas_equalTo(160.);
                make.height.mas_equalTo(37.);
            }];
            maplabel.hidden = YES;
            
            annotationView.labelPaopao = maplabel;
        }
        
        //显示文字
        if (_modelOrder.orderStatus == APPEnumOrderState_sending && ((FSAnnotation *)annotation).distance.length > 0) {
            NSString *mapTitle;
            
            if (((FSAnnotation *)annotation).distance.length) {
                if ([((FSAnnotation *)annotation).distance integerValue] > 1000) {
                    mapTitle = [NSString stringWithFormat:@"距骑手%.2f千米",[((FSAnnotation *)annotation).distance floatValue]/1000.];
                }else{
                    mapTitle = [NSString stringWithFormat:@"距骑手%@米",((FSAnnotation *)annotation).distance];
                }
                
                [annotationView.labelPaopao setTextTitle:mapTitle];
                
                annotationView.labelPaopao.hidden = NO;
            }else{
                annotationView.labelPaopao.hidden = YES;
            }
        }else{
            annotationView.labelPaopao.hidden = YES;
        }
        
        return annotationView;
    }
     */
    
    return nil;
}


#pragma mark - 懒加载变量属性  Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        
        _mapView = [[BMKMapView alloc] init];
        
        //设置地图上的属性
        /**
         - BMKMapTypeNone: 空白地图
         - BMKMapTypeStandard: 标准地图
         - BMKMapTypeSatellite: 卫星地图
         */
        _mapView.mapType = BMKMapTypeStandard;
        
        //log位置
        _mapView.logoPosition = _logoPosition;
        
        //设置地图显示POI标注
        _mapView.showMapPoi = _showMapPoi;
        
        //地图View不支持用户多点缩放(双指)
        _mapView.zoomEnabled = YES;
        //地图View不支持用户缩放(双击或双指单击)
        _mapView.zoomEnabledWithTap = _gesturesTap;
        //地图View不支持用户移动地图
        _mapView.scrollEnabled = _gesturesScroll;
        //地图View不支持旋转
        _mapView.rotateEnabled = _gesturesRotate;
        //地图View不支持俯仰角
        _mapView.overlookEnabled = _gesturesOverlook;
    }
    return _mapView;
}

- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[BMKLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.allowsBackgroundLocationUpdates = NO;
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

///骑行规划对象
- (BMKRouteSearch *)routeSearch{
    
    if (!_routeSearch) {
        
        //初始化BMKRouteSearch实例
        _routeSearch = [[BMKRouteSearch alloc]init];
        //设置骑行路径规划的代理
        _routeSearch.delegate = self;
    }
    return _routeSearch;
}



#pragma mark - 其他地图显示控制

///显示比例尺
- (void)showMapScaleBarWithBarposition:(CGPoint)barPoint{
    
    //设置显示比例尺
    _mapView.showMapScaleBar = YES;
    //设置比例尺的位置，以BMKMapView左上角为原点，向右向下增长
    _mapView.mapScaleBarPosition = barPoint;
}

///隐藏比例尺
- (void)hideScaleBar{
    
    _mapView.showMapScaleBar = NO;
}

///设置新的地图中心点
- (void)changeMapCenterCoordinate:(CLLocationCoordinate2D)newCenter{
    
    //设置中心点经纬度坐标
    //CLLocationCoordinate2D center = CLLocationCoordinate2DMake(35.718, 111.581);
    /**
     设定地图中心点坐标
     @param coordinate 要设定的地图中心点坐标，用经纬度表示
     @param animated 是否采用动画效果
     */
    
    [_mapView setCenterCoordinate:newCenter animated:YES];
}

///为订单详情特殊设置中心点偏上移
- (void)changeMapCenterCoordinateForOrderDetail:(CLLocationCoordinate2D)newCenter{
    
    //使中心点纬度下移500米（0.01为一公里）
    newCenter = CLLocationCoordinate2DMake(newCenter.latitude - 0.005, newCenter.longitude);
    [_mapView setCenterCoordinate:newCenter animated:YES];
}

///设置地图显示范围
- (void)setMapShowRegionWithRegion:(BMKCoordinateSpan)span{
    
    //设置地图中心点经纬度坐标
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(39.923018, 116.404440);
    //设置经纬度范围
    //BMKCoordinateSpan span = BMKCoordinateSpanMake(0.013142, 0.011678);
    
    //当前地图的经纬度范围，设置的该范围可能会被调整为适合地图View显示的范围
    [_mapView setRegion:BMKCoordinateRegionMake(centerCoordinate, span)];
    
}




@end

#pragma mark - *********************************  路径规划分类 *********************************
@implementation FRMapViewVC (PathPlanning)

#pragma mark - 路径规划
///路径规划
- (void)searchDataCyclingPlanningWithPlanStyle:(NSInteger)planStyle{
    
    if (planStyle == -1) {
        //为 -1 不规划
        return ;
    }
    
    //************** 起点信息 **************
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    //起点名称
    start.pt = _currentCoordinate;//骑手当前位置
    
    //存储起点坐标
    _startPt = _currentCoordinate;
    
    //起点所在城市，注：cityName和cityID同时指定时，优先使用cityID
    start.cityName = @"北京";//APPManagerObject.localCityName;
    
    /**
     //起点所在城市ID，注：cityName和cityID同时指定时，优先使用cityID
     if ((option.from.cityName.length > 0 && option.from.cityID != 0) || (option.from.cityName.length == 0 && option.from.cityID != 0))  {
     start.cityID = option.from.cityID;
     }
     //起点坐标
     start.pt = option.from.pt;
     */
    
    ////************** 终点信息 **************
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    //终点名称
    //end.name = option.to.name;
    
    //0:店铺    1:收件人   2:清除导航路径
    switch (planStyle) {
        case 0:
            //店铺
            end.pt = CLLocationCoordinate2DMake([[_modelOrder.distances gf_getItemWithIndex:1] doubleValue],[[_modelOrder.distances gf_getItemWithIndex:0] doubleValue]);
            //存储终点坐标
            _endPt = CLLocationCoordinate2DMake([[_modelOrder.distances gf_getItemWithIndex:1] doubleValue],[[_modelOrder.distances gf_getItemWithIndex:0] doubleValue]);
            break;
        case 1:
            //收件人
            end.pt = CLLocationCoordinate2DMake([_childModel.latitude doubleValue],[_childModel.longitude doubleValue]);
            //存储终点坐标
            _endPt = CLLocationCoordinate2DMake([_childModel.latitude doubleValue],[_childModel.longitude doubleValue]);
            break;
        case 2:
            //清除规划
            [_mapView removeOverlays:_mapView.overlays];//移除旧的规划路线
            //设置中心点
            [_mapView setCenterCoordinate:_currentCoordinate animated:YES];
            break;
            
        default:
            break;
    }
    
    
    
    //终点所在城市，注：cityName和cityID同时指定时，优先使用cityID
    end.cityName = @"北京";//APPManagerObject.localCityName;
    
    /**
     //终点所在城市ID，注：cityName和cityID同时指定时，优先使用cityID
     if ((option.to.cityName.length > 0 && option.to.cityID != 0) || (option.to.cityName.length == 0 && option.to.cityID != 0))  {
     end.cityID = option.to.cityID;
     }
     //终点坐标
     end.pt = option.to.pt;
     */
    
    BOOL flag = NO;
    //骑行
    //初始化请求参数类BMKRidingRoutePlanOption的实例
    BMKRidingRoutePlanOption *ridingRoutePlanOption = [[BMKRidingRoutePlanOption alloc]init];
    //检索的起点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
    ridingRoutePlanOption.from = start;
    //检索的终点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
    ridingRoutePlanOption.to = end;
    /**
     *发起骑行路线检索请求，异步函数，返回结果在BMKRouteSearchDelegate的onGetRidingRouteResult中
     */
    flag = [self.routeSearch ridingSearch:ridingRoutePlanOption];
    
    if (flag) {
        NSLog(@"路径检索成功");
    } else {
        NSLog(@"路径检索失败");
    }
}

#pragma mark - 路径规划搜索回调代理 BMKRouteSearchDelegate

/**
 返回骑行路线检索结果
 
 @param searcher 检索对象
 @param result 检索结果，类型为BMKRidingRouteResult
 @param error 错误码，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    
    [_mapView removeOverlays:_mapView.overlays];//移除旧的规划路线
    
    //[_mapView removeAnnotations:_mapView.annotations];//上面更新标注已经有移除旧的标注
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //+polylineWithPoints: count:坐标点的个数
        __block NSUInteger pointCount = 0;
        //获取所有骑行路线中第一条路线
        BMKRidingRouteLine *routeline = (BMKRidingRouteLine *)result.routes[0];
        //遍历骑行路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取骑行路线中的每条路段
            BMKRidingStep *step = routeline.steps[idx];
            
            /** 这里可以不添加标注（规划路线上的地点标注，可以不加这些，只要规划出来的折线就行）
             
             //初始化标注类BMKPointAnnotation的实例
             BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
             //设置标注的经纬度坐标为子路段的入口经纬度
             annotation.coordinate = step.entrace.location;
             //设置标注的标题为子路段的说明
             annotation.title = step.entraceInstruction;
             
             //当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
             //来生成标注对应的View
             //@param annotation 要添加的标注
             [self.mapView addAnnotation:annotation];//这里可以不添加标注（规划路线上的地点标注，可以不加这些，只要规划出来的折线就行）
             */
            
            //统计路段所经过的地理坐标集合内点的个数
            pointCount += step.pointsCount;
        }];
        
        //重新修改路径规划上的布局点
        [self redrawPointsWithRouteLine:routeline pointCount:pointCount];
    }
}

///重新布局绘制的点数
- (void)redrawPointsWithRouteLine:(BMKRouteLine *)routeline pointCount:(NSInteger)pointCount{
    
    BMKMapPoint *points = new BMKMapPoint[pointCount + 2];
    
    //**** 起点为骑手位置 ****
    points[0] = BMKMapPointForCoordinate(_startPt);//将 经纬度坐标  转换为 投影后的  直角地理坐标(这个类里都是 转换/判断矩形、点与点 API)
    
    __block NSUInteger j = 1;//路径规划的点从第2个开始存储
    //遍历驾车路线中的所有路段
    [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //获取驾车路线中的每条路段
        BMKDrivingStep *step = routeline.steps[idx];
        //遍历每条路段所经过的地理坐标集合点
        for (NSUInteger i = 0; i < step.pointsCount; i ++) {
            //将每条路段所经过的地理坐标点赋值给points
            points[j].x = step.points[i].x;
            points[j].y = step.points[i].y;
            j ++;
        }
    }];
    //****  添加终点(这段老画布上) ****
    points[j] = BMKMapPointForCoordinate(_endPt);
    
    //根据指定直角坐标点生成一段折线 (points里面有多少点，参数count可以控制绘制的点数)
    BMKPolyline *polyline = [BMKPolyline polylineWithPoints:points count:(pointCount + 2)];
    /**
     向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
     来生成标注对应的View
     
     @param overlay 要添加的overlay
     */
    [_mapView addOverlay:polyline];
    
    
    //根据polyline设置地图范围
    [self mapViewFitPolyline:polyline withMapView:self.mapView];
}

#pragma mark - 根据两点经纬度 添加弧线
///根据经纬度生产弧线
- (BMKArcline *)getArclineWithLocationStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end type:(NSInteger)type{
    
    CLLocationCoordinate2D coords[3] = {0};
    
    coords[0] = start;
    coords[1] = [self getMiddleLocationFormStat:start end:end];
    coords[2] = end;
    
    /**
     根据指定经纬度生成一段圆弧
     */
    BMKArcline *arcline = [BMKArcline arclineWithCoordinates:coords];
    
    //添加弧线上的箭头指示标注
    FRTaskAnnotation *annotation = [[FRTaskAnnotation alloc] init];
    //角度计算（这里还有问题）
    annotation.angle = [FSBaiDuMapManager computingAngleWithStart:start end:end];
    annotation.coordinate = coords[1];
    if (type == 0) {
        annotation.imgName = @"map_blueSJ";
    }else{
        annotation.imgName = @"map_yellowSJ";
    }
    [_mapView addAnnotation:annotation];
    
    return arcline;
}

///计算中间点经纬度 ——>形成弧形
- (CLLocationCoordinate2D)getMiddleLocationFormStat:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end{
    
    //X方向上往左移  ，当X位于同一水平 ，则 Y上移
    CLLocationCoordinate2D middleLocation;
    
    //（0.01为一公里）
    double distance = [FSBaiDuMapManager calculateTheDistanceBetweenTwoPoints:start endPoint:end];
    CLLocationDegrees xy = ((distance / 12.) / 1000) * 0.01;
    
    if (start.longitude < end.longitude) {
        //终点Y轴右边
        if (start.latitude < end.latitude) {
            //终点在X上
            middleLocation = CLLocationCoordinate2DMake((start.latitude + end.latitude) / 2. + xy, (start.longitude + end.longitude) / 2. - xy);
        }else{
            //终点在X下
            middleLocation = CLLocationCoordinate2DMake((start.latitude + end.latitude) / 2. - xy, (start.longitude + end.longitude) / 2. + xy);
        }
    }else if (start.longitude == end.longitude){
        //在一个Y轴上
        if (start.latitude < end.latitude) {
            //终点在X上
            middleLocation = CLLocationCoordinate2DMake((start.latitude + end.latitude) / 2. - xy, (start.longitude + end.longitude) / 2. - xy);
        }else{
            //终点在X下
            middleLocation = CLLocationCoordinate2DMake((start.latitude + end.latitude) / 2. + xy, (start.longitude + end.longitude) / 2. + xy);
        }
    }else{
        //终点在Y轴左边
        if (start.latitude < end.latitude) {
            //终点在X上
            middleLocation = CLLocationCoordinate2DMake((start.latitude + end.latitude) / 2. - xy, (start.longitude + end.longitude) / 2. - xy);
        }else{
            //终点在X下
            middleLocation = CLLocationCoordinate2DMake((start.latitude + end.latitude) / 2. + xy, (start.longitude + end.longitude) / 2. - xy);
        }
    }
    
    /**
     if (start.longitude == end.longitude) {
     //纬度上移
     middleLocation = CLLocationCoordinate2DMake((start.latitude + end.latitude) / 2. + xy, (start.longitude + end.longitude) / 2.);
     }else{
     //X经度左移
     middleLocation = CLLocationCoordinate2DMake((start.latitude + end.latitude) / 2., (start.longitude + end.longitude) / 2. - xy);
     }
     */
    
    return middleLocation;
}


#pragma mark - 添加路径划线触发的代理
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        //初始化一个overlay并返回相应的BMKPolylineView的实例
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        //设置polylineView的填充色
        polylineView.fillColor = RGB(103,182,255);//[[UIColor cyanColor] colorWithAlphaComponent:1];
        //设置polylineView的画笔（边框）颜色
        polylineView.strokeColor = RGB(25,143,251);//[[UIColor blueColor] colorWithAlphaComponent:0.7];
        //设置polylineView的线宽度
        polylineView.lineWidth = 2.0;
        //是否虚线
        //polylineView.lineDash = YES;
        return polylineView;
    }
    return nil;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyline:(BMKPolyline *)polyline withMapView:(BMKMapView *)mapView {
    double leftTop_x, leftTop_y, rightBottom_x, rightBottom_y;
    if (polyline.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyline.points[0];
    leftTop_x = pt.x;
    leftTop_y = pt.y;
    //左上方的点lefttop坐标（leftTop_x，leftTop_y）
    rightBottom_x = pt.x;
    rightBottom_y = pt.y;
    //右底部的点rightbottom坐标（rightBottom_x，rightBottom_y）
    for (int i = 1; i < polyline.pointCount; i++) {
        BMKMapPoint point = polyline.points[i];
        if (point.x < leftTop_x) {
            leftTop_x = point.x;
        }
        if (point.x > rightBottom_x) {
            rightBottom_x = point.x;
        }
        if (point.y < leftTop_y) {
            leftTop_y = point.y;
        }
        if (point.y > rightBottom_y) {
            rightBottom_y = point.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(leftTop_x , leftTop_y);
    rect.size = BMKMapSizeMake(rightBottom_x - leftTop_x, rightBottom_y - leftTop_y);
    //修改地图四周的留白距离
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 50, 20, 50);
    [mapView fitVisibleMapRect:rect edgePadding:padding withAnimated:YES];
}




@end

#pragma mark - ********************************* 自定义标注组件 *********************************

#pragma mark - 自定义标注
@implementation FSAnnotation

@end



#pragma mark - 自定义大头针头部label
@implementation FSMapLabel
{
    UIView *_backView;//底部阴影
    
    UILabel *_label;
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if ([super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _widthView = 160.;
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.frame = CGRectMake(0, 0, 160., 37.);
        [self addSubview:_backView];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _widthView, 32) cornerRadius:16.5];
        [path moveToPoint:CGPointMake(_widthView/2. - 5, 32)];
        [path addLineToPoint:CGPointMake(_widthView/2., 37)];
        [path addLineToPoint:CGPointMake(_widthView/2. + 5, 32)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, 160., 37);
        maskLayer.path = path.CGPath;
        _backView.layer.mask = maskLayer;
        
        [self createView];
        
        //添加底部阴影
        UIColor *showColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.layer.cornerRadius = 18.5;
        [GFFunctionMethod view_addShadowOnView:self shadowOffset:CGSizeZero shadowColor:showColor shadowAlpha:1];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


//创建视图
- (void)createView{
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = kFontOfCustom(kSemibold, 14);
    _label.textColor = [UIColor blackColor];
    _label.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_label];
    //_label.frame = CGRectMake(2, 2, 96, 18);
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.top.equalTo(self).offset(2);
        make.bottom.equalTo(self).offset(-7);
    }];
}

- (void)setTextTitle:(NSString *)title{
    
    _label.text = title;
}

- (void)setAttrbuteString:(NSAttributedString *)title{
    
    _label.attributedText = title;
}


@end



#pragma mark - 自定义的标准视图
@implementation FSPinAnnotiontaionView




@end

#pragma mark - ************************* 自定义三角标注（任务地图上的三角）*************************
//自定义标注
@implementation FRTaskAnnotation



@end

//自定义标注视图
@implementation FRTaskAnnotiontaionView



@end

