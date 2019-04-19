//
//  FSMapViewOrderDetailVC.h
//  FlashSend
//  订单详情地图
//  Created by gaoyafeng on 2019/4/17.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "FSMapViewVC.h"

#import "FSOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSMapViewOrderDetailVC : FSMapViewVC

///为订单详情特殊设置中心点偏上移
- (void)changeMapCenterCoordinateForOrderDetail:(CLLocationCoordinate2D)newCenter;

///赋值订单详情model信息
- (void)setMarkInfoModel:(FSOrderDetailModel *)orderDetailModel;


@end


NS_ASSUME_NONNULL_END
