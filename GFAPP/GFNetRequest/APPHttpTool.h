//
//  APPHttpTool.h
//  GFAPP
//  网络请求工具简版类
//  Created by gaoyafeng on 2018/5/21.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
    
}NetworkStatus;


typedef void (^Success) (id response , NSInteger code);
typedef void (^Failure) (NSError *error);

@interface APPHttpTool : NSObject


/**
 *  获取网络
 */
@property (nonatomic,assign)NetworkStatus networkStats;

/**
 *  单例
 */
+ (instancetype)sharedNetworking;

/**
 *  开启网络监测
 */
+ (void)startMonitoring;

/**
 *  get请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 */
+ (void)getWithUrl:(NSString *)url
            params:(NSDictionary *)params
           success:(Success)success
              fail:(Failure)fail;

/**
 *  post请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 */
+(void)postWithUrl:(NSString *)url
            params:(NSDictionary *)params
           success:(Success)success
              fail:(Failure)fail;


/**
 * delete请求方法,block回掉
 *
 @param url 请求连接，根路径
 @param params 参数
 @param success 请求成功返回数据
 @param fail 请求失败
 */
+ (void)deleteWithUrl:(NSString *)url
               params:(NSDictionary *)params
              success:(Success)success
                 fail:(Failure)fail;


@end
