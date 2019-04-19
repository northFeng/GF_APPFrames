//
//  FSMapViewVC.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/9/27.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSMapViewVC.h"

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKCustomViewHierarchy";

//BMKMapViewDelegate:百度地图代理  BMKLocationManagerDelegate:百度地图管理者代理  BMKRouteSearchDelegate:骑行规划代理
@interface FSMapViewVC () <BMKMapViewDelegate,BMKLocationManagerDelegate,BMKRouteSearchDelegate>

@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象

//定位标注
@property (nonatomic, strong) BMKLocationViewDisplayParam *param; //定位图层自定义样式参数


@end

@implementation FSMapViewVC
{
    
    CLLocationCoordinate2D *_coors;
    
    BOOL _isFirstLoad;
}


- (void)dealloc {
    //地图死亡了必须关掉!
    [BMKMapView enableCustomMapStyle:NO];
    
    //销毁地图
    [self deallocBKMap];
}

///销毁地图
- (void)deallocBKMap{
    
    if (_mapView) {

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
    
    //是否定位跟随
    _isFollowing = NO;
    
    _mapPadding = UIEdgeInsetsMake(10, 10, 10, 10);//地图四边留空
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
    
    //自定义地图文件JSON(必须在创建地图之前使用！！)
    NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_config_0323" ofType:@""];
    [BMKMapView customMapStyle:path];//设置个性化地图样式
    
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
    if (_isFollowing) {
        [self setupLocationManager];
    }
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


#pragma mark - 进入定位跟随模式
//跟随态
-(void)startFollowing
{
    NSLog(@"进入跟随态");
    
    //设置地图中心点(不设置默认到天安门)
    [self changeMapCenterCoordinate:CLLocationCoordinate2DMake([[APPManager sharedInstance].localLatitude floatValue], [[APPManager sharedInstance].localLongitude floatValue])];
    //地图精度
    _mapView.zoomLevel = _zoomLevel;
    
    //开启定位服务
    //[self.locationManager startUpdatingLocation];//开始连续定位
    //[self.locationManager startUpdatingHeading];//开始设备朝向事件回调
    //显示定位图层
    _mapView.showsUserLocation = YES;
    
    //使用跟随功能
    //_mapView.userTrackingMode = _trackingMode;
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
    //param.locationViewImgName = @"xiaoduBear";
    //param.locationViewImage = [UIImage imageNamed:@"map_local"];//用户自定义定位图标，V4.2.1以后支持
    
    //设置显示精度圈
    param.isAccuracyCircleShow = NO;
    ///是否显示气泡，默认YES
    param.canShowCallOut = YES;
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
    //NSLog(@"用户方向更新");
    
    self.userLocation.heading = heading;
    [_mapView updateLocationData:self.userLocation];
}

//更新定位信息
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
    
    //设置  定位标注   的经纬度坐标
    //_annotation.coordinate = self.userLocation.location.coordinate;
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

#pragma mark - 添加标注

///只添加店铺表标注
- (void)setShopMarkWithInfo:(CLLocationCoordinate2D)lotion title:(NSString *)title{
    
    //添加发件标注
    FSAnnotation *markSend = [[FSAnnotation alloc] init];
    markSend.coordinate = lotion;
    markSend.type = 1;
    [_mapView addAnnotation:markSend];
}


#pragma mark - 根据anntation生成对应的annotationView
/**
 根据anntation生成对应的annotationView
 
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[FSAnnotation class]]) {
        //发件
        FSPinAnnotiontaionView *sendView = (FSPinAnnotiontaionView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"send"];
        
        if (!sendView) {
            sendView = [[FSPinAnnotiontaionView alloc] initWithAnnotation:annotation reuseIdentifier:@"send"];
            sendView.image = [UIImage imageNamed:@"map_fa"];
            sendView.centerOffset = CGPointMake(0, -(sendView.frame.size.height * 0.4));
            
            //文字显示label
            FSMapLabel *maplabel = [[FSMapLabel alloc] init];
            maplabel.widthView = 160.;
            [sendView addSubview:maplabel];
            [maplabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(sendView);
                make.bottom.equalTo(sendView.mas_top).offset(-0);
                make.width.mas_equalTo(160);
                make.height.mas_equalTo(37.);
            }];
            maplabel.hidden = YES;
            sendView.labelPaopao = maplabel;
        }
        
        //选择位置
        sendView.labelPaopao.hidden = NO;
        [sendView.labelPaopao setTextTitle:@"店铺位置"];
        
        return sendView;
    }
    
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
        
        //地图精度
        _mapView.zoomLevel = _zoomLevel;
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
@implementation FSMapViewVC (PathPlanning)

#pragma mark - 路径规划
///路径规划 0:步行  1:骑行  2:驾车
- (void)searchDataCyclingPlanningWithPlanStyle:(NSInteger)planStyle startPt:(CLLocationCoordinate2D)startPt endPt:(CLLocationCoordinate2D)endPt{
    
    //************** 起点信息 **************
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    //起点名称
    //start.name = option.from.name;
    start.pt = startPt;
    
    //存储起点坐标
    _startPt = startPt;
    
    //起点所在城市，注：cityName和cityID同时指定时，优先使用cityID
    start.cityName = APPManagerObject.localCityName;
    
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
    end.pt = endPt;
    _endPt = endPt;
    
    //终点所在城市，注：cityName和cityID同时指定时，优先使用cityID
    end.cityName = APPManagerObject.localCityName;
    
    /**
     //终点所在城市ID，注：cityName和cityID同时指定时，优先使用cityID
     if ((option.to.cityName.length > 0 && option.to.cityID != 0) || (option.to.cityName.length == 0 && option.to.cityID != 0))  {
     end.cityID = option.to.cityID;
     }
     //终点坐标
     end.pt = option.to.pt;
     */
    
    BOOL flag = NO;
    switch (planStyle) {
        case 0:
        {
            //步行
            //初始化请求参数类BMKWalkingRoutePlanOption的实例
            BMKWalkingRoutePlanOption *walkingRoutePlanOption = [[BMKWalkingRoutePlanOption alloc] init];
            //检索的起点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
            walkingRoutePlanOption.from = start;
            //检索的终点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
            walkingRoutePlanOption.to = end;
            /**
             发起步行路线检索请求，异步函数，返回结果在BMKRouteSearchDelegate的onGetWalkingRouteResult中
             */
            
            flag = [self.routeSearch walkingSearch:walkingRoutePlanOption];
        }
            break;
        case 1:
        {
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
        }
            break;
        case 2:
        {
            //驾车
            //初始化请求参数类BMKDrivingRoutePlanOption的实例
            BMKDrivingRoutePlanOption *drivingRoutePlanOption = [[BMKDrivingRoutePlanOption alloc]init];
            //检索的起点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
            drivingRoutePlanOption.from = start;
            //检索的终点，可通过关键字、坐标两种方式指定。cityName和cityID同时指定时，优先使用cityID
            drivingRoutePlanOption.to = end;
            //
            //drivingRoutePlanOption.wayPointsArray = option.wayPointsArray;
            /*
             驾车策略，默认使用BMK_DRIVING_TIME_FIRST
             BMK_DRIVING_BLK_FIRST：躲避拥堵
             BMK_DRIVING_TIME_FIRST：最短时间
             BMK_DRIVING_DIS_FIRST：最短路程
             BMK_DRIVING_FEE_FIRST：少走高速
             */
            //drivingRoutePlanOption.drivingPolicy = option.drivingPolicy;
            /*
             路线中每一个step的路况，默认使用BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE
             BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE：不带路况
             BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE：道路和路况
             */
            //drivingRoutePlanOption.drivingRequestTrafficType = option.drivingRequestTrafficType;
            /**
             发起驾乘路线检索请求，异步函数，返回结果在BMKRouteSearchDelegate的onGetDrivingRouteResult中
             */
            flag = [self.routeSearch drivingSearch:drivingRoutePlanOption];
        }
            break;
            
        default:
            break;
    }
    
    
    if (flag) {
        NSLog(@"路径检索成功");
    } else {
        NSLog(@"路径检索失败");
    }
}

#pragma mark - 路径规划搜索回调代理 BMKRouteSearchDelegate

/**
 返回步行路线检索结果
 
 @param searcher 检索对象
 @param result 检索结果，类型为BMKWalkingRouteResult
 @param error 错误码，@see BMKSearchErrorCode
 */
- (void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    
    [_mapView removeOverlays:_mapView.overlays];//移除旧的路径规划
    //[_mapView removeAnnotations:_mapView.annotations];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //+polylineWithPoints: count:坐标点的个数
        __block NSUInteger pointCount = 0;
        //获取所有步行路线中第一条路线
        BMKWalkingRouteLine *routeline = (BMKWalkingRouteLine *)result.routes[0];
        //遍历步行路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取步行路线中的每条路段
            BMKWalkingStep *step = routeline.steps[idx];
            //初始化标注类BMKPointAnnotation的实例
            
            /**
             BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
             //设置标注的经纬度坐标为子路段的入口经纬度
             annotation.coordinate = step.entrace.location;
             //设置标注的标题为子路段的说明
             annotation.title = step.entraceInstruction;
             
             [_mapView addAnnotation:annotation];
             */
            
            //统计路段所经过的地理坐标集合内点的个数
            pointCount += step.pointsCount;
        }];
        
        //重新修改路径规划上的布局点
        [self redrawPointsWithRouteLine:routeline pointCount:pointCount];
        
        /**
        //+polylineWithPoints: count:指定的直角坐标点数组
        BMKMapPoint *points = new BMKMapPoint[pointCount];
        __block NSUInteger j = 0;
        //遍历步行路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取步行路线中的每条路段
            BMKWalkingStep *step = routeline.steps[idx];
            //遍历路段所经过的地理坐标集合
            for (NSUInteger i = 0; i < step.pointsCount; i ++) {
                //将每条路段所经过的地理坐标点赋值给points
                points[j].x = step.points[i].x;
                points[j].y = step.points[i].y;
                j ++;
            }
        }];
        //根据指定直角坐标点生成一段折线
        BMKPolyline *polyline = [BMKPolyline polylineWithPoints:points count:pointCount];
        
         向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
         来生成标注对应的View
         
         @param overlay 要添加的overlay
         
        _polyline = polyline;
        _pointCount = pointCount;
        [_mapView addOverlay:polyline];//添加新的路径规划
        [self addCustomOverlay];//添加自定义划线路径
        
        //根据polyline设置地图范围
        [self mapViewFitPolyline:polyline withMapView:self.mapView];
         */
    }
}

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

/**
 返回驾车路线检索结果
 
 @param searcher 检索对象
 @param result 检索结果，类型为BMKDrivingRouteResult
 @param error 错误码 @see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    [_mapView removeOverlays:_mapView.overlays];
    //[_mapView removeAnnotations:_mapView.annotations];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //+polylineWithPoints: count:坐标点的个数
        __block NSUInteger pointCount = 0;
        //获取所有驾车路线中第一条路线
        BMKDrivingRouteLine *routeline = (BMKDrivingRouteLine *)result.routes[0];
        //遍历驾车路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取驾车路线中的每条路段
            BMKDrivingStep *step = routeline.steps[idx];
            
            /**
             //初始化标注类BMKPointAnnotation的实例
             BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
             //设置标注的经纬度坐标为子路段的入口经纬度
             annotation.coordinate = step.entrace.location;
             //设置标注的标题为子路段的说明
             annotation.title = step.entraceInstruction;
             
             [_mapView addAnnotation:annotation];
             */
            
            //统计路段所经过的地理坐标集合内点的个数
            pointCount += step.pointsCount;
        }];
        
        //重新修改路径规划上的布局点
        [self redrawPointsWithRouteLine:routeline pointCount:pointCount];
        
        /**
        //+polylineWithPoints: count:指定的直角坐标点数组
        BMKMapPoint *points = new BMKMapPoint[pointCount];
        __block NSUInteger j = 0;
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
        //根据指定直角坐标点生成一段折线
        BMKPolyline *polyline = [BMKPolyline polylineWithPoints:points count:pointCount];
        
         向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
         来生成标注对应的View
         
         @param overlay 要添加的overlay
         
        _polyline = polyline;
        _pointCount = pointCount;
        [_mapView addOverlay:polyline];
        [self addCustomOverlay];//添加自定义划线路径
        
        //根据polyline设置地图范围
        [self mapViewFitPolyline:polyline withMapView:self.mapView];
         */
    }
}


///添加 骑手标注 && 发件/收件标注 与路径规划 之间的连线(有点问题)
- (void)addCustomOverlay{
    
     //第一种方法
     //把直角坐标系 转换 经纬度坐标系
     //CLLocationCoordinate2D *coors = new CLLocationCoordinate2D[_pointCount];
     _coors = new CLLocationCoordinate2D[self.pointCount];
     [self.polyline getCoordinates:_coors range:NSMakeRange(0, self.pointCount)];
     
     //骑手到路径规划的直线
     CLLocationCoordinate2D coordRider[2] = {0};
     coordRider[0] = CLLocationCoordinate2DMake(_startPt.latitude, _startPt.longitude);
     coordRider[1] = CLLocationCoordinate2DMake(_coors[0].latitude, _coors[0].longitude);
     [_mapView addOverlay:[BMKPolyline polylineWithCoordinates:coordRider count:2]];
     
     
     //路劲规划终点到 发店 / 收件 直线 （这个有点问题！！终点位置获取失败）
     CLLocationCoordinate2D endOne = _coors[self.pointCount];
     CLLocationCoordinate2D coordEnd[2] = {0};
     coordEnd[0] = CLLocationCoordinate2DMake(endOne.latitude, endOne.longitude);//CLLocationCoordinate2DMake(_coors[_pointCount].latitude, _coors[_pointCount].longitude);
     coordEnd[1] = CLLocationCoordinate2DMake(_endPt.latitude, _endPt.longitude);
     [_mapView addOverlay:[BMKPolyline polylineWithCoordinates:coordEnd count:2]];
}

#pragma mark - 根据路径规划后结果，进行排整规划点
///路径规划后 ——>重新布局绘制的点数
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
    [_mapView addOverlay:polyline];//1、添加点连线
    
    
    //根据polyline设置地图范围
    [self mapViewFitPolyline:polyline withMapView:self.mapView padding:_mapPadding];//2、根据所有的点进行地图缩放，把所有的点都显示在可显示的范围内
}


#pragma mark - 添加各种绘制连线触发的代理
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

#pragma mark - 根据坐标点数组进行自动缩放地图 && 把所有的点都显示地图显示范围内
///根据坐标点数组进行自动缩放地图 && 把所有的点都显示地图显示范围内
- (void)mapViewAutoZoomWithPoints:(NSArray <FSMapLocationInfo *>*)pointsArray padding:(UIEdgeInsets)padding{
    
    BMKMapPoint *points = new BMKMapPoint[pointsArray.count];//开辟点位置数组
    
    for (int i = 0; i < pointsArray.count ; i++) {
        FSMapLocationInfo *pointModel = pointsArray[i];
        CLLocationCoordinate2D location = [pointModel getCLLocationCoordinate2D];
        
        points[i] = BMKMapPointForCoordinate(location);
        
    }
    
    //根据指定直角坐标点生成一段折线 (points里面有多少点，参数count可以控制绘制的点数)
    BMKPolyline *polyline = [BMKPolyline polylineWithPoints:points count:pointsArray.count];

    //根据polyline设置地图范围
    [self mapViewFitPolyline:polyline withMapView:self.mapView padding:padding];//2、根据所有的点进行地图缩放，把所有的点都显示在可显示的范围内
}

//根据polyline设置地图范围（根据所有的点进行计算出 左上角和右下角点 把所有的点进行显示——>计算地图缩放比例）
- (void)mapViewFitPolyline:(BMKPolyline *)polyline withMapView:(BMKMapView *)mapView padding:(UIEdgeInsets)padding{
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
    //UIEdgeInsets padding = UIEdgeInsetsMake(50, 20, 250, 20);
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
    _label.textColor = APPColor_BlackDeep;
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


#pragma mark - ****************** 位置信息model ************************
@implementation FSMapLocationInfo


///转换出
- (CLLocationCoordinate2D)getCLLocationCoordinate2D{
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.latitude doubleValue],[self.longitude doubleValue]);
    
    return coordinate;
}

@end

