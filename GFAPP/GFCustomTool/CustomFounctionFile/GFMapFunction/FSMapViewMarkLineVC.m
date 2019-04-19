//
//  FSMapViewMarkLineVC.m
//  FlashSend
//
//  Created by gaoyafeng on 2019/4/17.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "FSMapViewMarkLineVC.h"

@interface FSMapViewMarkLineVC ()

///发送位置标注
@property (nonatomic, strong) FSAnnotation *markSend;

///骑手位置标注
@property (nonatomic, strong) FSAnnotation *markRider;

///店铺到第一个收件人弧线
@property (nonatomic,strong,nullable) BMKArcline *lineFirst;

@end

@implementation FSMapViewMarkLineVC


///只显示标注 && 无他操作 && 价格明细赋值
- (void)setMarkInfFromPriceDetailWithShopLocation:(CLLocationCoordinate2D)lotionShop recetInfoArray:(NSArray *)arrayRecet{
    //设置店铺地址为中心点
    //[self changeMapCenterCoordinate:lotionShop];
    
    //添加发件标注
    _markSend = [[FSAnnotation alloc] init];
    _markSend.coordinate = lotionShop;
    [self.mapView addAnnotation:_markSend];
    
    for (int i = 0; i < arrayRecet.count ; i++) {
        FSMapLocationInfo *receiptInfo = arrayRecet[i];
        
        FSAnnotation *annotation = [[FSAnnotation alloc] init];
        annotation.distance = @"";
        if (arrayRecet.count == 1) {
            annotation.type = 0;//收字
        }else{
            annotation.type = i + 1;//收件标注顺号
        }
        annotation.coordinate = [receiptInfo getCLLocationCoordinate2D];
        
        [self.mapView addAnnotation:annotation];
    }
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
        
        //价格明细显示位置
        sendView.labelPaopao.hidden = YES;
        sendView.image = [UIImage imageNamed:@"map_shop"];
        
        return sendView;
    }else if (annotation == _markRider){
        //骑手
        BMKPinAnnotationView *riderView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"rider"];
        if (!riderView) {
            
            riderView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"rider"];
            riderView.image = [UIImage imageNamed:@"map_qs"];
            riderView.centerOffset = CGPointMake(0, -(riderView.frame.size.height * 0.4));
        }
        
        return riderView;
    }else if ([annotation isKindOfClass:[FSAnnotation class]]){
        //收件
        FSPinAnnotiontaionView *annotationView = (FSPinAnnotiontaionView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"shoujianren"];
        if (!annotationView) {
            
            annotationView = [[FSPinAnnotiontaionView alloc] initWithAnnotation:annotation reuseIdentifier:@"shoujianren"];
            
            NSString *imageStr = [NSString stringWithFormat:@"map_%d",((FSAnnotation *)annotation).type];
            annotationView.image = [UIImage imageNamed:imageStr];
            annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.4));
        }
        
        return annotationView;
    }
    
    return nil;
}



#pragma mark - 添加弧线绘制
///根据数据进行弧线绘制
- (void)addArclinesWithModels:(NSArray *)arrayLocal{
    
    //店铺 ——> 收件人1
    NSMutableArray *arrayLine = [NSMutableArray array];
    
    for (int i = 1; i < arrayLocal.count ; i++) {
        
        if (i == 1) {
            FSMapLocationInfo *pointShop = arrayLocal[0];
            FSMapLocationInfo *pointOne = arrayLocal[1];
            _lineFirst = [self getArclineWithLocationStart:[pointShop getCLLocationCoordinate2D] end:[pointOne getCLLocationCoordinate2D]];
            //line.lineColor = RGB(27,164,251);//蓝色
            [arrayLine gf_addObject:_lineFirst];
        }else{
            //收件之间的划线
            FSMapLocationInfo *point1 = [arrayLocal gf_getItemWithIndex:i - 1];
            FSMapLocationInfo *point2 = [arrayLocal gf_getItemWithIndex:i];
            
            if (point1 && point2) {
                BMKArcline *line = [self getArclineWithLocationStart:[point1 getCLLocationCoordinate2D] end:[point2 getCLLocationCoordinate2D]];
                //line.lineColor = RGB(241,186,3);//橙黄色
                [arrayLine gf_addObject:line];
            }
        }
    }
    
    //添加划线
    [self.mapView addOverlays:arrayLine];
    
    //自动计算地图缩放
    [self mapViewAutoZoomWithPoints:arrayLocal padding:UIEdgeInsetsMake(50, 10, 20, 10)];
}


#pragma mark - 添加各种绘制连线触发的代理
/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKArcline class]]){
        //初始化一个overlay并返回相应的BMKArclineView的实例
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        //设置arclineView的画笔颜色
        if (overlay == _lineFirst) {
            arclineView.strokeColor = RGB(27,164,251);//蓝色
        }else{
            arclineView.strokeColor = RGB(241,186,3);//橙黄色
        }
        
        //设置arclineView为虚线样式
        arclineView.lineDash = NO;
        //设置arclineView的线宽度
        arclineView.lineWidth = 1.4;
        return arclineView;
    }
    return nil;
}

///根据经纬度生产弧线
- (BMKArcline *)getArclineWithLocationStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end{
    
    CLLocationCoordinate2D coords[3] = {0};
    
    coords[0] = start;
    coords[1] = [self getMiddleLocationFormStat:start end:end];
    coords[2] = end;
    
    /**
     根据指定经纬度生成一段圆弧
     */
    BMKArcline *arcline = [BMKArcline arclineWithCoordinates:coords];
    
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



@end
