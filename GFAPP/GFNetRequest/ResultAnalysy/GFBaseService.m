//
//  GFURLRequest.h
//  MJExtension
//  
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFBaseService.h"

/**
 *  Base层的错误码定义
 */
enum {
    ERROR_COMMON            = 11000,
    ERROR_BATABASE_OPEN     = 11001,
    ERROR_ANALYZE_DATA      = 11002
};

@implementation GFBaseService

- (void)analyzeDataWithResult:(GFCommonResult *)result responseData:(id)responseData modelClass:(Class)modelClass analyzeResultBack:(GFAnalyzeBackBlock)analyzeResultBack
{
    GFCommonResult *analyzeResult = nil;
    NSMutableArray *logicData = nil;
    
    if ( result.resultCode == GF_RESULT_CODE_SUCCESS ) {
        ///请求成功
        @try {
            // 统一报文头解析
            analyzeResult = [GFCommonResult resultWithData:responseData];
            
            if ( analyzeResult.resultCode == GF_RESULT_CODE_SUCCESS ) {
                // 成功数据的解析
                if (responseData != nil && responseData != [NSNull null] && [responseData isKindOfClass:[NSDictionary class]]) {
                    //data 里面放着数据
                    id data = [responseData objectForKey:@"data"];
                    if (data != nil && data != [NSNull null]) {
                        logicData = [NSMutableArray array];
                        
                        if ([data isKindOfClass:[NSArray class]]) {
                            //数据 是 数组
                            for (id child in data) {
                                //父类指针 指向了 子类创建的对象
                                GFBaseModel *baseModel = [modelClass mj_objectWithKeyValues:child];
                                if (baseModel) {
                                    [logicData addObject:baseModel];
                                }
                            }
                        }
                        else if ([data isKindOfClass:[NSDictionary class]]) {
                            //数据是 字典
                            id baseModel = [modelClass mj_objectWithKeyValues:data];
                            [logicData addObject:baseModel];
                        }else {
                            logicData = data;
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            // 解析失败
            NSLog(@"%@ %@", exception.reason, [exception description]);
            analyzeResult = [GFCommonResult resultWithData:GF_RESULT_CODE_FAILURE resultDesc:@"数据获取异常"];
        }
        @finally {
            
        }
    }else if ( result.resultCode == GF_RESULT_CODE_FAILURE ) {
        analyzeResult = [GFCommonResult resultWithData:result.resultCode resultDesc:@"请求失败"];
    }else {
        analyzeResult = [GFCommonResult resultWithData:result.resultCode resultDesc:result.resultDesc];
    }
    
    if (analyzeResultBack) {
        analyzeResultBack(analyzeResult, logicData);
    }
}



@end
