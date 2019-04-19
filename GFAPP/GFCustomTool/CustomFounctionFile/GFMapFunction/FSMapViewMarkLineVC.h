//
//  FSMapViewMarkLineVC.h
//  FlashSend
//  标注连线 && 计价明细地图显示
//  Created by gaoyafeng on 2019/4/17.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "FSMapViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSMapViewMarkLineVC : FSMapViewVC

///只显示标注 && 无他操作 && 价格明细赋值
- (void)setMarkInfFromPriceDetailWithShopLocation:(CLLocationCoordinate2D)lotionShop recetInfoArray:(NSArray *)arrayRecet;

///根据数据进行弧线绘制
- (void)addArclinesWithModels:(NSArray *)arrayLocal;

@end

NS_ASSUME_NONNULL_END
