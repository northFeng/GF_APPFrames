//
//  APPBaseModel.h
//  FlashSend
//  APP的数据模型基类
//  Created by gaoyafeng on 2018/8/28.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface APPBaseModel : NSObject

#pragma mark - YYmodel带的 对象 ——> JSON数据（自动过滤为nil的数据）
///转换成字符串
+ (NSString *)gf_modelToJsonStringWith:(APPBaseModel *)model;

///转换成字典
+ (NSDictionary *)gf_modelToJsonDictionaryWithModel:(APPBaseModel *)model;

///转换成data
+ (NSData *)gf_modelToJsonDataWithModel:(APPBaseModel *)model;

@end

NS_ASSUME_NONNULL_END
