//
//  GFBookService.m
//  GFNetWorkRequest
//
//  Created by XinKun on 2017/7/31.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFBookService.h"

#import "GFFoundZLDetailModel.h"//model

@implementation GFBookService


//data返回的 是 数组
- (void)postItemListWithItemPage:(NSInteger)page resultBack:(GFServiceBackArrayBlock)resultBack {
    
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionary];
    [mutableParams setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"pageNo"];
    [mutableParams setObject:@"10" forKey:@"pageSize"];
    
    Class class = [GFBaseModel class];
    
    [[GFNetRequest sharedInstance] postWithNANUser:@"material/list" parameters:mutableParams resultBack:^(GFCommonResult *result, id responseObject) {
        //        NSLog(@"responseObject = %@",responseObject);
        [self analyzeDataWithResult:result responseData:responseObject modelClass:class analyzeResultBack:^(GFCommonResult *result, NSArray *data) {
            
            //请求下来的是数组
            if (resultBack) {
                resultBack(result,data);
            }
        }];
    }];
}


//data返回来的 是 字典
- (void)getFoundZLDetailInfoidString:(NSString *)idString result:(GFServiceBackArrayBlock)resultBack{
    
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionary];
    [mutableParams setObject:idString forKey:@"Id"];
    
    
    [[GFNetRequest sharedInstance] post:@"columns/detail" parameters:mutableParams resultBack:^(GFCommonResult *result, id responseObject) {
        [self analyzeDataWithResult:result responseData:responseObject modelClass:[GFBaseModel class] analyzeResultBack:^(GFCommonResult *result, NSArray *data) {
            
            id model;
            if (data && data.count>0) {
                model = data[0];
            }
            if (resultBack) {
                resultBack(result,model);
            }
        }];
    }];
}






@end
