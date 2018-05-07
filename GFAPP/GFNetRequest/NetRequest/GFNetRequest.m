//
//  GFURLRequest.h
//  MJExtension
//
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFNetRequest.h"

#import "GFMonitorNetWork.h"//网络监测

#import "GFHttpRequest.h"

#pragma mark - 正式服务器
//http://www.xinkunic.com
NSString *const APIScheme = @"http";
NSString *const Host = @"119.254.198.165:8081/";
NSString *const API = @"lpdp/";

#pragma mark - 测试服务器
//http://www.xinkunic.com
NSString *const DevelopmentAPIScheme = @"http";
/** 全网测试服务器 **/
NSString *const DevelopmentHost = @"119.254.198.161/";
NSString *const DevelopmentAPI = @"api/";

static BOOL _developmentMode = YES;//YES为正式服  NO 为测试服


@interface GFNetRequest ()

///网络
@property (nonatomic,strong) NSString *baseURL;

@end

@implementation GFNetRequest

+ (instancetype)sharedInstance
{
    static GFNetRequest *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

- (instancetype)init
{
    
    if ((self = [super init]))
    {
        // Use JSON，注意：这里出错率很大，后台不是返回的json的时候
        self.baseURL = [self getHttpServiceBaseUrl];
        
        // 启动耗时任务
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            // 开启网络监测
            [[GFMonitorNetWork managerForDomain] monitoringNetworkStatus];
            
        }];
        
    }
    return self;
}

- (NSString *)getHttpServiceBaseUrl {
    NSString *baseUrl = nil;
    if (_developmentMode) {
        //正式服
        baseUrl = [NSString stringWithFormat:@"%@://%@%@",APIScheme,Host,API];
    }else {
        //测试服
        baseUrl = [NSString stringWithFormat:@"%@://%@%@",DevelopmentAPIScheme,DevelopmentHost,DevelopmentAPI];
    }
    return baseUrl;
}

///域名地址，host
-(NSString *)hostUrl{
    
    return [self getHttpServiceBaseUrl];
}

//获取网络状态
- (GFNetworkStatus)getNetworkStatus
{
    return [[GFMonitorNetWork managerForDomain] getNetworkStatus];
}

//获取网络状态描述
- (NSString *)getNetworkStatusName{
    
    return [[GFMonitorNetWork managerForDomain] getNetworkStatusDescription];
}

///停止网络监测
- (void)stopMonitoring{
    
   [[GFMonitorNetWork managerForDomain] stopMonitoring];
}


- (void)get:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
 resultBack:(GFNetRequestBackBlock)resultBack
{
    if (GF_NETWORK_STATUS_NONE == [self getNetworkStatus]) {
        GFCommonResult *result = [GFCommonResult resultWithData:GF_RESULT_CODE_NETWORK_FAILURE resultDesc:nil];
        resultBack(result, nil);
        return;
    }
    
    GFHttpRequest *httpClient = [[GFHttpRequest alloc] initWithBaseURL:_baseURL];
    
    [httpClient get:urlString parameters:parameters resultBack:resultBack];
}


- (void)post:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
  resultBack:(GFNetRequestBackBlock)resultBack
{
    
    if (GF_NETWORK_STATUS_NONE == [self getNetworkStatus]) {
        GFCommonResult *result = [GFCommonResult resultWithData:GF_RESULT_CODE_NETWORK_FAILURE resultDesc:nil];
        resultBack(result, nil);
        return;
    }
    
    GFHttpRequest *httpClient = [[GFHttpRequest alloc] initWithBaseURL:_baseURL];
    
    [httpClient post:urlString parameters:parameters resultBack:resultBack];
}
- (void)postWithNANUser:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
             resultBack:(GFNetRequestBackBlock)resultBack{
    if (GF_NETWORK_STATUS_NONE == [self getNetworkStatus]) {
        GFCommonResult *result = [GFCommonResult resultWithData:GF_RESULT_CODE_NETWORK_FAILURE resultDesc:nil];
        resultBack(result, nil);
        return;
    }
    GFHttpRequest *httpClient = [[GFHttpRequest alloc] initWithBaseURL:_baseURL];
    
    [httpClient post:urlString parameters:parameters resultBack:resultBack];
}

- (void)upload:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
          data:(NSData *)data  name:(NSString *)name fileName:(NSString *)fileName
      mimeType:(GFMimeType)mimeType
    resultBack:(GFNetRequestBackBlock)resultBack
{
    if (GF_NETWORK_STATUS_NONE == [self getNetworkStatus]) {
        GFCommonResult *result = [GFCommonResult resultWithData:GF_RESULT_CODE_NETWORK_FAILURE resultDesc:nil];
        resultBack(result, nil);
        return;
    }
    
    GFHttpRequest *httpClient = [[GFHttpRequest alloc] initWithBaseURL:_baseURL];
    
    NSString *mimeString = nil;
    switch (mimeType) {
        case GF_MIME_TYPE_JPEG:
            mimeString = @"image/jpeg";
            break;
        case GF_MIME_TYPE_GIF:
            mimeString = @"image/gif";
            break;
        case GF_MIME_TYPE_PNG:
            mimeString = @"image/png";
            break;
        default:
            mimeString = @"";
            break;
    }
    [httpClient post:urlString parameters:parameters data:data name:name fileName:fileName mimeType:mimeString resultBack:resultBack];
}


@end
