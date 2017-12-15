//
//  GFURLRequest.h
//  MJExtension
//  网络请求
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFHttpRequest : NSObject


/**
 *  @param baseUrl 代表根url，为了省録url的一部分
 *
 *  @return nil
 */
- (instancetype)initWithBaseURL:(NSString *)baseUrl;

/**
 *  post请求
 *
 *  @param URLString  写请求的绝对地址或相对地址
 *  @param parameters 请求的参数dictionary
 *  @param resultBack 请求成功失败后，返回的数据
 */
- (void )post:(NSString *)URLString parameters:(NSDictionary *)parameters
   resultBack:(GFNetRequestBackBlock)resultBack;

/**
 *  上传文件post请求
 *
 *  @param URLString   写请求的绝对地址或相对地址
 *  @param parameters  请求的参数dictionary
 *  @param data       upload的数据
 *  @param name       上传文件的名字，和服务器约定，为了去到data
 *  @param fileName   name+后缀名
 *  @param mimeType   上传文件的类型 eg：image/jpeg
 *  @param resultBack 请求成功失败后，返回的数据
 */
- (void)post:(NSString *)URLString parameters:(NSDictionary *)parameters
        data:(NSData *)data  name:(NSString *)name fileName:(NSString *)fileName
    mimeType:(NSString *)mimeType
  resultBack:(GFNetRequestBackBlock)resultBack;
/**
 *  get请求
 *   参数介绍同post
 *  @param URLString  <#URLString description#>
 *  @param parameters <#parameters description#>
 *  @param resultBack <#resultBack description#>
 */
- (void )get:(NSString *)URLString parameters:(NSDictionary *)parameters
  resultBack:(GFNetRequestBackBlock)resultBack;
/**
 *  head请求
 *  参数介绍同post
 *  @param URLString  <#URLString description#>
 *  @param parameters <#parameters description#>
 *  @param resultBack <#resultBack description#>
 */

- (void)head:(NSString *)URLString parameters:(NSDictionary *)parameters
  resultBack:(GFNetRequestBackBlock)resultBack;

@end
