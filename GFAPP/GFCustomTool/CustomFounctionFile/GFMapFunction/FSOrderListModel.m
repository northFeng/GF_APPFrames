//
//  FSOrderListModel.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/9/8.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSOrderListModel.h"

///收件列表
@implementation ReceiverListModel


@end

///骑手信息
@implementation RiderInfo

@end

///费用详情
@implementation OrderPriceDetail

@end

///订单数量model
@implementation OrderStateCount



@end


///订单列表model
@implementation FSOrderListModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"receiverList" : [ReceiverListModel class],
             @"courier":[RiderInfo class]
             };
    
}



@end

