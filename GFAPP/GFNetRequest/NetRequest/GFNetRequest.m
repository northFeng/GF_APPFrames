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
    NSString *baseUrl = [APPKeyInfo hostURL];
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
    //获取文件的后缀名
    NSString *extension = [fileName componentsSeparatedByString:@"."].lastObject;
    //视频的话就是 video/type
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
        case GF_MIME_TYPE_VIDEO:
            mimeString = [NSString stringWithFormat:@"video/%@",extension];
            break;
        default:
            mimeString = @"";
            break;
    }
    [httpClient post:urlString parameters:parameters data:data name:name fileName:fileName mimeType:mimeString resultBack:resultBack];
}


@end
