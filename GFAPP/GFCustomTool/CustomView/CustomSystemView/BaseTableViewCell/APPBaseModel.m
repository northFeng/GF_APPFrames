//
//  APPBaseModel.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/7/18.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPBaseModel.h"

@implementation APPBaseModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             /**
             @"name" : @"n",
             @"page" : @"p",
             @"desc" : @"ext.desc",
             @"bookID" : @[@"id",@"ID",@"book_id"]
              */
              };
}

//Model 包含其他 Model,什么都不用做，转换会自动完成

//容器类属性
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             /**
             @"shadows" : [Shadow class],
             @"borders" : Border.class,
             @"attachments" : @"Attachment"
              */
             };
}




@end
