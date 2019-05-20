//
//  FSMapLinePlanVC.h
//  GFAPP
//  多个线路规划连线
//  Created by gaoyafeng on 2019/5/20.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "FSMapViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSMapLinePlanVC : FSMapViewVC




@end

#pragma mark - 自定义标注 && 泡泡视图
//自定义标注 路径规划
@interface FRPlanAnnotation : BMKPointAnnotation

///距离
@property(nonatomic,copy) NSString *distance;

///0:店铺 1:收件
@property(nonatomic,assign) int type;


@end


//路径规划 自定义大头针
@interface FRPlanPaoPaoView : BMKPinAnnotationView



@end

///自定义 泡泡文字显示view
@interface FRPlanPaoPaoTextView : UIView

///赋值 0:商家  1:收件
- (void)setMarkText:(NSString *)markStr distanceStr:(NSString *)distanceStr type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
