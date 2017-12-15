//
//  GFFoundZLDetailModel.m
//  Lawpress
//
//  Created by XinKun on 2017/5/10.
//  Copyright © 2017年 彬万. All rights reserved.
//

#import "GFFoundZLDetailModel.h"

@implementation GFFoundZLDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"Id":@"id",
             @"arrayAuthorList" : @"authorList",
             @"arrayMaterialList" : @"materialList",
             @"isRead":@"readFlag"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
//             @"arrayAuthorList" : @"JYauthorListModel",
//             @"arrayMaterialList" : @"XKFoundHomeModel"
             };
}


@end
