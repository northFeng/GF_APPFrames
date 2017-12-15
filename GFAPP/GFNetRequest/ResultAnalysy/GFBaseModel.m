//
//  GFURLRequest.h
//  MJExtension
//
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFBaseModel.h"

@implementation GFBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"Id" : @"id"
            };
}



@end
