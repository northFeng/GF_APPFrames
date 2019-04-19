//
//  FSOrderDetailModel.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/9/28.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSOrderDetailModel.h"

@implementation Rider

@end

@implementation SenderInfo

@end


@implementation ReceiverInfo

@end



@implementation FSOrderDetailModel



+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
              @"courier" : [Rider class],
              @"sender" : [SenderInfo class],
              //@"receivers" : [ReceiverInfo class]
              @"receivers" : [ReceiverListModel class]
             };
}




@end
