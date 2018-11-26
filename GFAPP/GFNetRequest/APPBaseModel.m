//
//  APPBaseModel.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/8/28.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "APPBaseModel.h"

@implementation APPBaseModel


#pragma mark - 常用的重写方法
/**
 返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
 Model 属性名和 JSON 中的 Key 不相同,重写该方法
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             /**
              @"name" : @"n",
              @"page" : @"p",
              @"desc" : @"ext.desc",
              @"bookID" : @[@"id",@"ID",@"book_id"]//对应多个key，依次匹配
              */
             };
}

/**
 容器类属性
 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
 有的话重写该方法
 */
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             /**
              @"shadows" : [Shadow class],
              @"borders" : Border.class,
              @"attachments" : @"Attachment"
              */
             };
}


/**
 Model 包含其他 Model
 
 // Model: 什么都不用做，转换会自动完成
 @interface Author : NSObject
 @property NSString *name;
 @property NSDate *birthday;
 @end
 @implementation Author
 @end
 
 @interface Book : NSObject
 @property NSString *name;
 @property NSUInteger pages;
 @property Author *author; //Book 包含 Author 属性
 @end
 @implementation Book
 @end
 */


#pragma mark - 自己封装方法使用

///转换成字符串
+ (NSString *)gf_modelToJsonStringWith:(APPBaseModel *)model{
    
    NSString *jsonStr = [model yy_modelToJSONString];
    return jsonStr;
}

///转换成字典
+ (NSDictionary *)gf_modelToJsonDictionaryWithModel:(APPBaseModel *)model{
    
    NSDictionary *dictonary = [model yy_modelToJSONObject];
    return dictonary;
}

///转换成data
+ (NSData *)gf_modelToJsonDataWithModel:(APPBaseModel *)model{
    
    NSData *data = [model yy_modelToJSONData];
    return data;
}


#pragma mark - 黑白名单过滤
/**
 黑名单与白名单
 */
// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray *)modelPropertyBlacklist {
    return nil;//@[@"test1", @"test2"];
}
// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return nil;//@[@"name"];
}

@end
