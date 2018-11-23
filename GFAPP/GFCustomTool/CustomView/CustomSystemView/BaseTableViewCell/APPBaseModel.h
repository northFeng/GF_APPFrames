//
//  APPBaseModel.h
//  GFAPP
//  根model
//  Created by gaoyafeng on 2018/7/18.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPBaseModel : NSObject

///转换成字符串
+ (NSString *)gf_modelToJsonStringWith:(APPBaseModel *)model;

///转换成字典
+ (NSDictionary *)gf_modelToJsonDictionaryWithModel:(APPBaseModel *)model;

///转换成data
+ (NSData *)gf_modelToJsonDataWithModel:(APPBaseModel *)model;



@end

/**
// 将 JSON (NSData,NSString,NSDictionary) 转换为 Model:
User *user = [User yy_modelWithJSON:json];//json为字典的字符串
[user yy_modelSetWithDictionary:dic];//dic为oc中的字典类型
 // 将 Model 转换为 JSON 对象:
 NSDictionary *json = [user yy_modelToJSONObject];

*/
