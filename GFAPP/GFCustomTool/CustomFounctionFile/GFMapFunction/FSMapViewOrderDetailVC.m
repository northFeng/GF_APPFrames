//
//  FSMapViewOrderDetailVC.m
//  FlashSend
//
//  Created by gaoyafeng on 2019/4/17.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "FSMapViewOrderDetailVC.h"

@interface FSMapViewOrderDetailVC ()

///发送位置标注
@property (nonatomic, strong) FSAnnotation *markSend;

///骑手位置标注
@property (nonatomic, strong) FSAnnotation *markRider;

///订单详情model
@property (nonatomic,strong,nullable) FSOrderDetailModel *modelOrder;

///发件标注上的label
@property (nonatomic,strong,nullable) FSMapLabel *labelSendPaopao;

@end

@implementation FSMapViewOrderDetailVC
{
    BOOL _isOpenCycle;//待支付 && 派单中
}

///销毁地图
- (void)deallocBKMap{
    
    if (self.mapView) {
        
        _isOpenCycle = NO;//关闭循环 && 这里不关闭会导致 FSMapViewVC 无法释放
        self.mapView = nil;
    }
    
}

///初始化变量
- (void)initData{
    
    [super initData];
    
    //只有待支付才开启
    _isOpenCycle = NO;
    
    self.mapPadding = UIEdgeInsetsMake(50, 20, 250, 20);
}

///为订单详情特殊设置中心点偏上移
- (void)changeMapCenterCoordinateForOrderDetail:(CLLocationCoordinate2D)newCenter{
    
    //使中心点纬度下移500米（0.01为一公里）
    newCenter = CLLocationCoordinate2DMake(newCenter.latitude - 0.005, newCenter.longitude);
    [self.mapView setCenterCoordinate:newCenter animated:YES];
}


///赋值订单详情model信息
- (void)setMarkInfoModel:(FSOrderDetailModel *)orderDetailModel{
    
    if (!_modelOrder) {
        _modelOrder = orderDetailModel;
        [self refreshMark];
    }else{
        //订单状态 发生变化 ——> 刷新标注
        _modelOrder = orderDetailModel;
        [self refreshMark];
    }
}

///更新标注
- (void)refreshMark{
    
    /////10："待支付"、20:“派件中”, 30："待取货"、40："闪送中"、50： "已完成" 、60： "已取消"
    
    //移除旧的
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //NSMutableArray *arrayPoints = [NSMutableArray array];
    
    //添加标注先后顺序 ---> 标注显示图层顺序
    //根据不同的状态添加骑手标注
    if (_modelOrder.orderStatus) {
        //闪送中 && 待取货 才有骑手位置
        _markRider = [[FSAnnotation alloc] init];
        _markRider.coordinate = CLLocationCoordinate2DMake([_modelOrder.courier.latitude floatValue],[_modelOrder.courier.longitude floatValue]);
        [self.mapView addAnnotation:_markRider];
        
        /**
        FSMapLocationInfo *point1 = [[FSMapLocationInfo alloc] init];
        point1.latitude = _modelOrder.courier.latitude;
        point1.longitude = _modelOrder.courier.longitude;
        [arrayPoints gf_addObject:point1];
         */
    }
    
    //添加发件标注
    _markSend = [[FSAnnotation alloc] init];
    _markSend.distance = _modelOrder.sender.distance;
    _markSend.coordinate = CLLocationCoordinate2DMake([_modelOrder.sender.fromLatitude floatValue],[_modelOrder.sender.fromLongitude floatValue]);
    //_markSend.type = 0;
    [self.mapView addAnnotation:_markSend];
    
    /**
    FSMapLocationInfo *pointSend = [[FSMapLocationInfo alloc] init];
    pointSend.latitude = _modelOrder.sender.fromLatitude;
    pointSend.longitude = _modelOrder.sender.fromLongitude;
    [arrayPoints gf_addObject:pointSend];
     */
    
    //添加收货标注
    for (int i=0; i < _modelOrder.receivers.count ; i++) {
        FSAnnotation *annotation = [[FSAnnotation alloc] init];
        
        ReceiverListModel *receiInfo = _modelOrder.receivers[i];
        
        annotation.distance = receiInfo.distance;
        if (_modelOrder.receivers.count == 1) {
            annotation.type = 0;//收字
        }else{
            annotation.type = i + 1;//收件标注顺号
        }
        annotation.coordinate = CLLocationCoordinate2DMake([receiInfo.toLatitude floatValue],[receiInfo.toLongitude floatValue]);
        [self.mapView addAnnotation:annotation];
        
        /**
        FSMapLocationInfo *pointReceit = [[FSMapLocationInfo alloc] init];
        pointReceit.latitude = receiInfo.toLatitude;
        pointReceit.longitude = receiInfo.toLongitude;
        [arrayPoints gf_addObject:pointReceit];
         */
    }
    
    if (_modelOrder.orderStatus == 0 || _modelOrder.orderStatus == 1) {
        //路径规划
        [self searchDataCyclingPlanningWithPlanFormStartPt:CLLocationCoordinate2DMake([_modelOrder.courier.latitude floatValue],[_modelOrder.courier.longitude floatValue])];
    }else{
        //让所有标注都在一个视图上出现
        //[self mapViewAutoZoomWithPoints:arrayPoints padding:UIEdgeInsetsMake(50, 20, 250, 20)];
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
        
        //订单详情
        //显示文字--->距离
        sendView.labelPaopao.hidden = YES;
        switch (_modelOrder.orderStatus) {
                
            case 0:
            {
                //待支付
                sendView.labelPaopao.hidden = NO;
                
                //获取发标注上的label
                _labelSendPaopao = sendView.labelPaopao;
                //开启循环
                _isOpenCycle = YES;
                [self refreshTimeWatingPay];
            }
                break;
            case 1:
            {
                //派单中...
                sendView.labelPaopao.hidden = NO;
                
                //获取发标注上的label
                _labelSendPaopao = sendView.labelPaopao;
                //开启循环
                _isOpenCycle = YES;
                [self refreshTimeWatingPay];
            }
                break;
            case 2:
            {
                //待取货
                //关闭循环
                _isOpenCycle = NO;
                _labelSendPaopao = nil;
                
                NSString *mapTitle;
                
                if (((FSAnnotation *)annotation).distance.length) {
                    if ([((FSAnnotation *)annotation).distance integerValue] > 1000) {
                        mapTitle = [NSString stringWithFormat:@"距离店铺%.2f千米",[((FSAnnotation *)annotation).distance floatValue]/1000.];
                    }else{
                        mapTitle = [NSString stringWithFormat:@"距离店铺%@米",((FSAnnotation *)annotation).distance];
                    }
                    
                    sendView.labelPaopao.hidden = NO;
                    [sendView.labelPaopao setTextTitle:mapTitle];
                }else{
                    //没有数据
                    sendView.labelPaopao.hidden = YES;
                }
            }
                break;
                
            default:
                break;
        }
        
        switch (((FSAnnotation *)annotation).type) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                //选择位置
                sendView.labelPaopao.hidden = NO;
                [sendView.labelPaopao setTextTitle:@"店铺位置"];
            }
                break;
            case 2:
            {
                //价格明细显示位置
                sendView.labelPaopao.hidden = YES;
                sendView.image = [UIImage imageNamed:@"map_shop"];
            }
                break;
                
            default:
                break;
        }
        
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
        if (_modelOrder.orderStatus == 0 && ((FSAnnotation *)annotation).distance.length > 0) {
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
    
    return nil;
}

///循环获取时间
- (void)refreshTimeWatingPay{
    
    if (_isOpenCycle && _labelSendPaopao) {
        
        switch (_modelOrder.orderStatus) {
            case 0:
            {
                //更新等待支付时间
                NSAttributedString *showStr = [GFFunctionMethod string_getMergeAttributedStringWithHeadString:@"等待支付" headStringFont:kFontOfCustom(kSemiboldFont, 14) headStringColor:APPColor_BlackDeep middleString:[self getTimeDifference] middleStrFont:kFontOfCustom(kSemiboldFont, 14) middleStrColor:APPColor_Blue endString:@"" endStringFont:kFontOfCustom(kMediumFont, 14) endStringColor:APPColor_BlackDeep];
                [_labelSendPaopao setAttrbuteString:showStr];
            }
                break;
            case 1:
            {
                //更新派单中等待时间
                NSAttributedString *showStr = [GFFunctionMethod string_getMergeAttributedStringWithHeadString:@"派单中,已等待" headStringFont:kFontOfCustom(kSemiboldFont, 14) headStringColor:APPColor_BlackDeep middleString:[self getTimeWatingTakeOrder] middleStrFont:kFontOfCustom(kSemiboldFont, 14) middleStrColor:APPColor_Blue endString:@"" endStringFont:kFontOfCustom(kMediumFont, 14) endStringColor:APPColor_BlackDeep];
                [_labelSendPaopao setAttrbuteString:showStr];
            }
                break;
                
            default:
                break;
        }
        
        [self performSelector:@selector(refreshTimeWatingPay) withObject:nil afterDelay:1];
    }
}


///等待支付获取时间差
- (NSString *)getTimeDifference{
    
    if (_modelOrder.expireTime.length) {
        NSDate *date = [NSDate date];
        NSTimeInterval nowTime = date.timeIntervalSince1970 * 1000;
        //时间未到就开启
        int timeInterval = ([_modelOrder.expireTime floatValue] - nowTime)/1000;
        
        NSString *time = [NSString stringWithFormat:@"%02d:%02d",timeInterval/60,timeInterval%60];
        
        return time;
    }else{
        
        return @"00:00";
    }
}

///等待接单时间
- (NSString *)getTimeWatingTakeOrder{
    
    if (_modelOrder.payTime.length) {
        NSDate *date = [NSDate date];
        NSTimeInterval nowTime = date.timeIntervalSince1970 * 1000;
        //时间未到就开启
        int timeInterval = (nowTime - [_modelOrder.payTime integerValue])/1000;
        
        NSString *time;
        if (timeInterval > 60) {
            time = [NSString stringWithFormat:@"%d分钟",timeInterval/60];//[NSString stringWithFormat:@"",timeInterval/60,timeInterval%60];
        }else{
            time = [NSString stringWithFormat:@"%ds",timeInterval];//[NSString stringWithFormat:@"",timeInterval/60,timeInterval%60];
        }
        
        
        return time;
    }else{
        
        return @"0s";
    }
}


#pragma mark - 路径规划
///路径规划 0:步行  1:骑行  2:驾车
- (void)searchDataCyclingPlanningWithPlanFormStartPt:(CLLocationCoordinate2D)startPt{
    
    //************** 起点信息 **************
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    //起点名称
    //start.name = option.from.name;
    start.pt = startPt;
    
    //存储起点坐标
    self.startPt = startPt;
    
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
    
    switch (_modelOrder.orderStatus) {
        case 0:
        {
            //待取货
            end.pt = CLLocationCoordinate2DMake([_modelOrder.sender.fromLatitude floatValue],[_modelOrder.sender.fromLongitude floatValue]);
            
            //存储终点坐标
            self.endPt = CLLocationCoordinate2DMake([_modelOrder.sender.fromLatitude floatValue],[_modelOrder.sender.fromLongitude floatValue]);
        }
            break;
        case 1:
        {
            //闪送中
            for (ReceiverInfo *receiInfo in _modelOrder.receivers) {
                //判断骑手正在送哪一个快件
                if (receiInfo.distance.length > 0) {
                    
                    end.pt = CLLocationCoordinate2DMake([receiInfo.toLatitude floatValue],[receiInfo.toLongitude floatValue]);
                    
                    //存储终点坐标
                    self.endPt = CLLocationCoordinate2DMake([receiInfo.toLatitude floatValue],[receiInfo.toLongitude floatValue]);
                    
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
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



@end

