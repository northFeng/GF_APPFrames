//
//  GFURLRequest.h
//  MJExtension
//  解析数据
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GFCommonResult.h"

/**
 *  解析结果返回通知
 *
 *  @param result 解析结果
 *  @param data   最终数据
 */
typedef void(^GFAnalyzeBackBlock)(GFCommonResult *result, NSArray *data);

/**
 *  解析结果返回通知
 *
 *  @param result 网络返回结果
 *  @param items  数组
 */
typedef void (^GFServiceBackArrayBlock) (GFCommonResult *result,NSArray *items);

/**
 *  解析结果返回通知
 *
 *  @param result 网络返回结果
 *  @param object 单个model数据或者其他结果数据
 */
typedef void (^GFServiceBackObjectBlock) (GFCommonResult *result, id object);


@interface GFBaseService : NSObject

/**
 *  将请求数据解析为业务数据
 *
 *  @param result            请求结果
 *  @param responseData      请求数据
 *  @param modelClass        业务数据模型
 *  @param analyzeResultBack 解析完成后的回调通知
 */
- (void)analyzeDataWithResult:(GFCommonResult *)result responseData:(id)responseData modelClass:(Class)modelClass analyzeResultBack:(GFAnalyzeBackBlock)analyzeResultBack;



@end
