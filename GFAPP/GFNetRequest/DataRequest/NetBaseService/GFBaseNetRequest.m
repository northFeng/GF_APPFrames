//
//  GFBaseNetRequest.m
//  GFAPP
//
//  Created by XinKun on 2017/11/24.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFBaseNetRequest.h"

@implementation GFBaseNetRequest

//data返回的 是 数组
- (void)getItemListWithUrl:(NSString *)url Params:(NSMutableDictionary *)paramDic modelClass:(Class)modelClass resultBack:(GFServiceBackArrayBlock)resultBack{
    
    [[GFNetRequest sharedInstance] post:url parameters:paramDic resultBack:^(GFCommonResult *result, id responseObject) {
       
        [self analyzeDataWithResult:result responseData:responseObject modelClass:modelClass analyzeResultBack:^(GFCommonResult *result, NSArray *data) {
            
            //请求下来的是数组
            if (resultBack) {
                
                resultBack(result,data);
            }
        }];
        
    }];
}

//data返回的 是 单个model对象
- (void)getModelDataWithUrl:(NSString *)url Params:(NSMutableDictionary *)paramDic modelClass:(Class)modelClass resultBack:(GFServiceBackObjectBlock)resultBack{
    
    [[GFNetRequest sharedInstance] post:url parameters:paramDic resultBack:^(GFCommonResult *result, id responseObject) {
        
        [self analyzeDataWithResult:result responseData:responseObject modelClass:modelClass analyzeResultBack:^(GFCommonResult *result, NSArray *data) {
            
            if (resultBack) {
                if (data.count) {
                    resultBack(result,data[0]);
                }else{
                    resultBack(result,nil);
                }
            }
        }];
    }];
}

@end
