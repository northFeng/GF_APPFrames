//
//  GFURLRequest.h
//  MJExtension
//  接口调用
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface GFNetRequest : NSObject

/**
 *  网络代理单例实例 用这个的时候，可以在代理里面设置baseURL
 *
 *  @return 网络代理单例实例
 */
+ (instancetype)sharedInstance;

/**
 *  域名地址，host
 *
 *  @return NSString * host
 */
-(NSString*)hostUrl;


/**
 *  读取当前网络状态
 *
 *  @return 当前网络状态
 */
- (GFNetworkStatus)getNetworkStatus;

/**
 *  读取当前网络状态描述
 *
 *  @return 当前网络状态描述
 */
- (NSString *)getNetworkStatusName;

/**
 *  停止网络监听
 *  默认自动开启
 */
- (void)stopMonitoring;


/**
 *  以"POST"方法请求数据
 *
 *  @param urlString  请求的绝对地址或相对地址
 *  @param parameters 请求参数
 *  @param resultBack 请求结果返回
 */
- (void)post:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
  resultBack:(GFNetRequestBackBlock)resultBack;
/**
 *  以"POST"方法请求数据  ------ 不带token
 *
 *  @param urlString  请求的绝对地址或相对地址
 *  @param parameters 请求参数
 *  @param resultBack 请求结果返回
 */
- (void)postWithNANUser:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
             resultBack:(GFNetRequestBackBlock)resultBack;

/**
 *  以"GET"方法请求数据
 *
 *  @param urlString  请求的绝对地址或相对地址
 *  @param parameters 请求参数
 *  @param resultBack 请求结果返回
 */
- (void)get:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
 resultBack:(GFNetRequestBackBlock)resultBack;

/**
 *  上传文件类数据
 *
 *  @param urlString  请求的绝对地址或相对地址
 *  @param parameters 请求参数
 *  @param data       文件数据
 *  @param name       文件名称，不包括扩展名
 *  @param fileName   文件名称，包括扩展名
 *  @param mimeType   文件类型
 *  @param resultBack 上传结果返回
 */
- (void)upload:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
          data:(NSData *)data  name:(NSString *)name fileName:(NSString *)fileName
      mimeType:(GFMimeType)mimeType
    resultBack:(GFNetRequestBackBlock)resultBack;



@end
