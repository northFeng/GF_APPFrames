//
//  GFURLRequest.h
//  MJExtension
//
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFHttpRequest.h"


@interface GFHttpRequest ()

@property (nonatomic,strong,readwrite)NSString *baseURL;

@property (nonatomic,assign)NSTimeInterval defaultSeconds;

///请求任务
@property (nonatomic,strong) NSURLSessionDataTask *requestTask;

@end

@implementation GFHttpRequest

- (instancetype)initWithBaseURL:(NSString *)baseURL
{
    
    if (self = [super init]) {
        
        _baseURL = baseURL;
        //默认请求时间限制
        _defaultSeconds = 10.f;
    }
    return self;
}

#pragma mark - 设置AFHTTPSessionManager
- (AFHTTPSessionManager *)getAFManager{
    //[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求数据为json
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置返回数据为json
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = 10;
    //设置请求数据接收格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    //往Header里面添加公共数据参数
    //    [manager.requestSerializer setValue:KHSPlatformType forHTTPHeaderField:@"platform"];
    //    [manager.requestSerializer setValue:[HSAppInfo appChannel] forHTTPHeaderField:@"channel"];
    //    [manager.requestSerializer setValue:[HSDeviceHepler deviceUUID] forHTTPHeaderField:@"deviceId"];
    //    [manager.requestSerializer setValue:[UIDevice currentDevice].model forHTTPHeaderField:@"model"];
    //    [manager.requestSerializer setValue:[HSAppInfo appVersion] forHTTPHeaderField:@"appVersion"];
    //    [manager.requestSerializer setValue:[HSAccountManager sharedAccountManager].token forHTTPHeaderField:@"token"];
    //    [manager.requestSerializer setValue:[HSAccountManager sharedAccountManager].userId forHTTPHeaderField:@"userId"];
    //    [manager.requestSerializer setValue:[HSAppInfo appBundleID] forHTTPHeaderField:@"packageName"];
    
    
    return manager;
    
}

///post请求
- (void )post:(NSString *)URLString parameters:(NSDictionary *)parameters
   resultBack:(GFNetRequestBackBlock)resultBack;
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    if (contentTypes) {
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"application/json"];
        //[contentTypes addObject:@"application/json;charset=utf-8"];
    }
    
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置超过时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = _defaultSeconds;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    self.baseURL = [NSString stringWithFormat:@"%@%@",self.baseURL,URLString];
    
    self.requestTask = [manager POST:self.baseURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        GFCommonResult *result = [GFCommonResult resultWithData:GF_RESULT_CODE_SUCCESS resultDesc:nil];
        
        resultBack(result, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"post1 ：： ----------------------- Error -----------------------------\n%@",error);
        GFResultCode resultCode = GF_RESULT_CODE_FAILURE;
        NSString *errorDescription = [error description];
        if (error.code <= -998 && error.code >= -1103) {
            resultCode = GF_RESULT_CODE_NETWORK_FAILURE;
            errorDescription = @"网络异常";
        }else if (error.code == 3840){
            resultCode = GF_RESULT_CODE_FAILURE;
            errorDescription = @"数据获取失败";
        }
        GFCommonResult *result = [GFCommonResult resultWithData:resultCode resultDesc:errorDescription];
        
        resultBack(result, nil);
        
    }];
    
}


///上传文件post  用通知来取消 任务请求
- (void)post:(NSString *)URLString parameters:(NSDictionary *)parameters
        data:(NSData *)data  name:(NSString *)name fileName:(NSString *)fileName
    mimeType:(NSString *)mimeType
  resultBack:(GFNetRequestBackBlock)resultBack;
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    if (contentTypes) {
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"application/json"];
        //[contentTypes addObject:@"application/json;charset=utf-8"];
    }
    
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    //manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置超过时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = _defaultSeconds;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    self.baseURL = [NSString stringWithFormat:@"%@%@",self.baseURL,URLString];
    
    self.requestTask = [manager POST:self.baseURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        GFCommonResult *result = [GFCommonResult resultWithData:GF_RESULT_CODE_SUCCESS resultDesc:nil];
        resultBack(result, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"post2 ：： ----------------------- Error -----------------------------\n%@",error);
        GFResultCode resultCode = GF_RESULT_CODE_FAILURE;
        NSString *errorDescription = [error description];
        if (error.code <= -998&&error.code>=-1103) {
            resultCode = GF_RESULT_CODE_NETWORK_FAILURE;
            errorDescription = @"网络异常";
        }
        GFCommonResult *result = [GFCommonResult resultWithData:resultCode resultDesc:errorDescription];
        resultBack(result, nil);
        
    }];
    
}


///get请求
- (void)get:(NSString *)URLString parameters:(NSDictionary *)parameters
  resultBack:(GFNetRequestBackBlock)resultBack
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置超过时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = _defaultSeconds;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    self.baseURL = [NSString stringWithFormat:@"%@%@",self.baseURL,URLString];
    
    self.requestTask = [manager GET:self.baseURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        GFCommonResult *result = [GFCommonResult resultWithData:GF_RESULT_CODE_SUCCESS resultDesc:nil];
        
        resultBack(result, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"get ：： ----------------------- Error -----------------------------\n%@",error);
        GFCommonResult *result = [GFCommonResult resultWithData:GF_RESULT_CODE_FAILURE resultDesc:[error description]];
        resultBack(result, nil);
        
    }];

}

- (void)head:(NSString *)URLString parameters:(NSDictionary *)parameters
  resultBack:(GFNetRequestBackBlock)resultBack
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置超过时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = _defaultSeconds;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    self.baseURL = [NSString stringWithFormat:@"%@%@",self.baseURL,URLString];
    
    [manager HEAD:self.baseURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task) {
       
        GFCommonResult *result = [GFCommonResult resultWithData:GF_RESULT_CODE_SUCCESS resultDesc:nil];
        resultBack(result, task.taskDescription);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"head ：： ----------------------- Error -----------------------------\n%@",error);
        GFCommonResult *result = [GFCommonResult resultWithData:GF_RESULT_CODE_FAILURE resultDesc:[error description]];
        resultBack(result, nil);
        
    }];
    
}







@end
