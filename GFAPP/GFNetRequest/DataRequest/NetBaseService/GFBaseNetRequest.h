//
//  GFBaseNetRequest.h
//  GFAPP
//
//  Created by XinKun on 2017/11/24.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFBaseService.h"

@interface GFBaseNetRequest : GFBaseService

/**
 *  @brief 请求结果是个数组列表
 *
 *  @param url 请求地址
 *  @param paramDic 参数字典
 *
 *  @param resultBack block结果;
 */
- (void)getItemListWithUrl:(NSString *)url Params:(NSMutableDictionary *)paramDic modelClass:(Class)modelClass resultBack:(GFServiceBackArrayBlock)resultBack;


/**
 *  @brief 请求结果是个Model对象
 *
 *  @param url 请求地址
 *  @param paramDic 参数字典
 *
 *  @param resultBack block结果;
 */
- (void)getModelDataWithUrl:(NSString *)url Params:(NSMutableDictionary *)paramDic modelClass:(Class)modelClass resultBack:(GFServiceBackObjectBlock)resultBack;


@end
