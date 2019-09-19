//
//  FSMapLinePlanVC.m
//  GFAPP
//
//  Created by gaoyafeng on 2019/5/20.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "FSMapLinePlanVC.h"

@interface FSMapLinePlanVC ()

@property (nonatomic,strong,nullable) BMKPolyline *lineShop;

@end

@implementation FSMapLinePlanVC
{
    
    NSMutableArray *_arrayPoint;//骑手+店铺+收件 点
    
    NSMutableArray *_arrayLine;//规划路线
    
    NSInteger _indexPoint;
}

///进行线路规划
- (void)addPlanLineWithModel:(NSArray *)pointArray{
    
    _arrayPoint = [pointArray mutableCopy];
    _arrayLine = [NSMutableArray array];
    
    _indexPoint = 1;//店铺点
    //添加骑手到点店铺路线
    CLLocationCoordinate2D rider = CLLocationCoordinate2DMake([[APPManager sharedInstance].localLatitude floatValue], [[APPManager sharedInstance].localLongitude floatValue]);
    FSMapLocationInfo *shopPoint = pointArray[1];
    CLLocationCoordinate2D shop = [shopPoint getCLLocationCoordinate2D];
    [self searchDataCyclingPlanningStartPt:rider endPt:shop];//添加骑手到店铺路线
}

///进行循环添加路径规划
- (void)addPlanLineToOrder{
    
    if (_indexPoint < _arrayPoint.count) {
        
        FSMapLocationInfo *pointCurrent = [_arrayPoint gf_getItemWithIndex:_indexPoint];
        FSMapLocationInfo *pointUp = [_arrayPoint gf_getItemWithIndex:_indexPoint -1];
        
        CLLocationCoordinate2D start = [pointUp getCLLocationCoordinate2D];
        CLLocationCoordinate2D end = [pointCurrent getCLLocationCoordinate2D];
        
        [self searchDataCyclingPlanningStartPt:start endPt:end];//添加店铺到收件人路线
    }else{
        //添加所有规划路线
        [self.mapView addOverlays:_arrayLine];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self mapViewAutoZoomWithPoints:_arrayPoint padding:self.mapPadding];
}

#pragma mark - 添加路线规划 ——> 重写路径规划分类中的一些方法
///重新布局绘制的点数
- (void)redrawPointsWithRouteLine:(BMKRouteLine *)routeline pointCount:(NSInteger)pointCount{
    
    BMKMapPoint *points = new BMKMapPoint[pointCount + 2];
    
    //**** 起点为骑手位置 ****
    points[0] = BMKMapPointForCoordinate(self.startPt);//将 经纬度坐标  转换为 投影后的  直角地理坐标(这个类里都是 转换/判断矩形、点与点 API)
    
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
    points[j] = BMKMapPointForCoordinate(self.endPt);
    
    //根据指定直角坐标点生成一段折线 (points里面有多少点，参数count可以控制绘制的点数)
    BMKPolyline *polyline = [BMKPolyline polylineWithPoints:points count:(pointCount + 2)];
    
    if (_arrayLine.count == 0) {
        _lineShop = polyline;
    }
    [_arrayLine gf_addObject:polyline];
    
    //[self.mapView addOverlay:polyline];
    _indexPoint ++;
    [self addPlanLineToOrder];//继续添加路线
}

#pragma mark - 添加 地图绘制 代理
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
        
        UIColor *lineColor = RGBX(0xFF9900);
        if (overlay == _lineShop) {
            lineColor = APPColor_Blue;
        }
        //设置polylineView的填充色
        polylineView.fillColor = lineColor;
        //设置polylineView的画笔（边框）颜色
        polylineView.strokeColor = lineColor;
        
        //设置polylineView的线宽度
        polylineView.lineWidth = 3.0;
        //是否虚线
        //polylineView.lineDash = YES;
        return polylineView;
    }
    
    return nil;
}


@end


#pragma mark - ************************ 自定义标注 && 泡泡视图 ************************

//自定义标注 路径规划
@implementation FRPlanAnnotation



@end

//路径规划 自定义泡泡弹框
@implementation FRPlanPaoPaoView



@end


#pragma mark - ************************ 自定义大头针上的文字显示view ************************
@implementation FRPlanPaoPaoTextView
{
    
    UIImageView *_imgBack;
    
    UILabel *_labelMark;
    
    UILabel *_labelDistance;
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if (self = [super init]) {
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    //背景图
    _imgBack = [[UIImageView alloc] init];
    _imgBack.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imgBack];
    [_imgBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    
    _labelMark = [GFFunctionMethod view_createLabelWith:@"" textFont:kFontOfCustom(kSemiboldFont, 12) textColor:APPColor_White textAlignment:NSTextAlignmentCenter];
    _labelMark.frame = CGRectMake(4, 2, 25, 25);
    [GFFunctionMethod view_addRoundedCornersOnView:_labelMark cornersPosition:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornersWidth:5];
    [_imgBack addSubview:_labelMark];
    
    _labelDistance = [GFFunctionMethod view_createLabelWith:@"" textFont:kFontOfCustom(kSemiboldFont, 12) textColor:[UIColor yellowColor] textAlignment:NSTextAlignmentCenter];
    _labelDistance.frame = CGRectMake(29, 2, 51, 25);
    [GFFunctionMethod view_addRoundedCornersOnView:_labelDistance cornersPosition:(UIRectCornerTopRight | UIRectCornerBottomRight) cornersWidth:5];
    [_imgBack addSubview:_labelDistance];
    
}

///赋值 0:商家  1:收件
- (void)setMarkText:(NSString *)markStr distanceStr:(NSString *)distanceStr type:(NSInteger)type{
    
    _labelMark.text = markStr;
    
    _labelDistance.text = distanceStr;
    
    switch (type) {
        case 0:
            //商家
            _imgBack.image = [UIImage imageNamed:@"map_shopdistance"];
            _labelDistance.textColor = APPColor_Blue;
            break;
        case 1:
            //收件
            _imgBack.image = [UIImage imageNamed:@"map_orderdistance"];
            _labelDistance.textColor = RGBX(0xE8B304);
            break;
            
        default:
            break;
    }
}



@end

