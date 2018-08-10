//
//  APPHttpTool.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/21.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPHttpTool.h"


#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "AFNetworking.h"

@implementation APPHttpTool

+ (instancetype)sharedNetworking{
    
    static APPHttpTool *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[APPHttpTool alloc] init];
    });
    return handler;
}

+ (void)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Failure)fail{
    
    NSLog(@"请求地址----%@\n    请求参数----%@",url,params);
    
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    AFHTTPSessionManager *manager = [self getAFManager];
    
    [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求结果=%@",responseObject);
        
        if (success) {
            NSInteger code = (NSInteger)responseObject[@"message"][@"code"];
            //后台协商进行用户登录异常提示 && 强制用户退出
            if (code==401||code==403||code==-10001) {
                //执行退出
                [[APPManager sharedInstance] forcedExitUserWithShowControllerItemIndex:0];
                
                if (fail) {
                    fail(nil);
                }
            } else {
                
                success(responseObject,code);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            NSLog(@"没有网络");
        }
        if (fail) {
            fail(error);
        }
    }];
}

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Failure)fail
{
    NSLog(@"请求地址----%@\n    请求参数----%@",url,params);
    
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    /**
     加密处理：对字段进行json序列化进行加密成字符串，进行发送到后台
     一定要判断请求的URL是否为上传图片，若为上传图片则不进行加密处理
     */
    
    AFHTTPSessionManager *manager=[self getAFManager];
    [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求结果=%@",responseObject);
        
        if (success) {
            
            //NSInteger code = (NSInteger)responseObject[@"message"][@"code"];
            NSInteger code = [responseObject[@"message"][@"code"] integerValue];
            if (code==401||code==403||code==-10001){
                
                //执行退出
                [[APPManager sharedInstance] forcedExitUserWithShowControllerItemIndex:0];
                
                if (fail) {
                    fail(nil);
                }
            } else {
                success(responseObject,code);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        if (fail) {
            fail(error);
        }
    }];
}

+ (void)deleteWithUrl:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Failure)fail
{
    
    NSLog(@"请求地址----%@\n    请求参数----%@",url,params);
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    AFHTTPSessionManager *manager=[self getAFManager];
    
    [manager DELETE:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求结果=%@",responseObject);
        if (success) {
            NSInteger code = (NSInteger)responseObject[@"message"][@"code"];
            
            
            if (code==401||code==403||code==-10001)
            {
                //执行退出
                [[APPManager sharedInstance] forcedExitUserWithShowControllerItemIndex:0];
                
                if (fail) {
                    fail(nil);
                }
            }
            else {
                success(responseObject,code);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        if (fail) {
            fail(error);
        }
    }];
}


#pragma makr - 开始监听网络连接
+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                [APPHttpTool sharedNetworking].networkStats=StatusUnknown;
                
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络");
                [APPHttpTool sharedNetworking].networkStats=StatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                [APPHttpTool sharedNetworking].networkStats=StatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                [APPHttpTool sharedNetworking].networkStats=StatusReachableViaWiFi;
                NSLog(@"WIFI--%d",[APPHttpTool sharedNetworking].networkStats);
                break;
        }
    }];
}

#pragma mark - 创建AFN管理者
+(AFHTTPSessionManager *)getAFManager{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //请求序列化
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//设置请求数据为json
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = 15;//超时时间
    //请求头信息设置
    /**
    [manager.requestSerializer setValue:KHSPlatformType forHTTPHeaderField:@"platform"];
    [manager.requestSerializer setValue:[HSAppInfo appChannel] forHTTPHeaderField:@"channel"];
    [manager.requestSerializer setValue:[HSDeviceHepler deviceUUID] forHTTPHeaderField:@"deviceId"];
    [manager.requestSerializer setValue:[UIDevice currentDevice].model forHTTPHeaderField:@"model"];
    [manager.requestSerializer setValue:[HSAppInfo appVersion] forHTTPHeaderField:@"appVersion"];
     
    //本地账户的token 和 账户ID 每次请求都放到请求头中，后台做判断，有异常就返回了，强制用户退出登录
    [manager.requestSerializer setValue:[HSAccountManager sharedAccountManager].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[HSAccountManager sharedAccountManager].userId forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:[HSAppInfo appBundleID] forHTTPHeaderField:@"packageName"];
     */
    
    //响应序列化
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    //响应数据格式设置
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    //RELEASE模式下进行HTTPS设置
#if RELEASE
    
    //购买的证书!!!对于ios开发来说，啥代码都不用写了。如果是自签名证书，就需要 验证证书的过程，也就是在 afn 里面写一些配置
    
    //************************** 购买的额CA证书 设置（其实可以省略什么都不写） ******************
    /**
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:YES];
    manager.securityPolicy = securityPolicy;
     */
    //****************************************************
    
    
    //********************** 自签证书设置 *****************************
    //HTTPS设置
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

    //设置证书模式
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *set = [[NSSet alloc] initWithObjects:cerData, nil];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:set];
    //客户端是否信任证书   &&  是否允许无效证书（也就是自建的证书）默认为NO
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    /**
     假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
     
     置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
     
     如置为NO，建议自己添加对应域名的校验逻辑。
     */
    //是否在证书域字段中验证域名 默认为YES
    [manager.securityPolicy setValidatesDomainName:NO];
    
#endif
    
    
    return manager;
}

+(NSString *)strUTF8Encoding:(NSString *)str{
    //编码
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //解码
    //[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}



// 加上这行代码，https ssl 验证。
//[mgr setSecurityPolicy:[self customSecurityPolicy]];
/**
可能遇到的问题
1）证书一定要拉到项目里面，AFN加了验证之后，看看获取证书的certData是否为空。如果为空，则证书有问题
NSData *certData = [NSData dataWithContentsOfFile:cerPath];
2.如果https服务器没有数据返回，很大可能是因为服务器配置出了问题。
 */
+ (AFSecurityPolicy*)customSecurityPolicy{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hgcang" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}



#pragma mark - 上传图片和视频
+ (void)uploadImageAndMovieName:(NSString *)fileName fileType:(NSString *)fileType filePath:(NSString *)filePath{
    
    //获取文件的后缀名
    NSString *extension = [fileName componentsSeparatedByString:@"."].lastObject;
    
    //设置mimeType
    NSString *mimeType;
    if ([fileType isEqualToString:@"image"]) {
        mimeType = [NSString stringWithFormat:@"image/%@", extension];
    } else {
        mimeType = [NSString stringWithFormat:@"video/%@", extension];
    }
    
    //创建AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置响应文件类型为JSON类型
    manager.responseSerializer    = [AFJSONResponseSerializer serializer];
    
    //初始化requestSerializer
    manager.requestSerializer     = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = nil;
    
    //设置timeout
    [manager.requestSerializer setTimeoutInterval:20.0];
    
    //设置请求头类型
    [manager.requestSerializer setValue:@"form/data" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头, 授权码
    //[manager.requestSerializer setValue:@"YgAhCMxEehT4N/DmhKkA/M0npN3KO0X8PMrNl17+hogw944GDGpzvypteMemdWb9nlzz7mk1jBa/0fpOtxeZUA==" forHTTPHeaderField:@"Authentication"];
    
    //上传服务器接口
    NSString *url = [NSString stringWithFormat:@"http://xxxxx.xxxx.xxx.xx.x"];
    
    //开始上传
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error;
        BOOL success = [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:fileName fileName:fileName mimeType:mimeType error:&error];
        
        if (!success) {
            
            NSLog(@"appendPartWithFileURL error: %@", error);
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"上传进度: %f", uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"成功返回: %@", responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败: %@", error);
        
    }];
}



@end
