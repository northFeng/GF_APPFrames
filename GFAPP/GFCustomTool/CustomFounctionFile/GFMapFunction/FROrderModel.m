//
//  FROrderModel.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/12/21.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "FROrderModel.h"

///取消订单model
@implementation CancleOrderModel



@end


///收件model
@implementation OrderChildModel



@end

///订单列表
@implementation OrderListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"idNum" : @"id"
             //@"bookID" : @[@"id",@"ID",@"book_id"]//对应多个key，依次匹配
             };
}

/**
 容器类属性
 */
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"orderDetailResults" : [OrderChildModel class],
             };
}

@end

@implementation FROrderModel

/**
 容器类属性
 */
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"orderResults" : [OrderListModel class],
             };
}



@end
