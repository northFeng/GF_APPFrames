//
//  GFURLRequest.h
//  MJExtension
//  结果 状态 解析
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  通用结果码
 */
typedef enum
{
    /** 请求成功 */
    GF_RESULT_CODE_SUCCESS = 100,
    /** 参数错误 */
    GF_RESULT_CODE_FAILURE_PARAMETER_WORING,
    /** 请求成功，但数据为空 */
    GF_RESULT_CODE_SUCCESS_DATA_EMPTY,
    /** 账号失效，请重新登录 */
    GF_RESULT_CODE_FAILURE_ACCOUNT_LOSE,
    /** 该账号已被注册 */
    GF_RESULT_CODE_FAILURE_REGISTERED,
    /** 服务器数据读取错误 */
    GF_RESULT_CODE_FAILURE_SERVERS_WORING,
    /** 分页索引越界 */
    GF_RESULT_CODE_FAILURE_PAGE_WORING,
    /** 该账号未被注册 */
    GF_RESULT_CODE_FAILURE_NOT_REGISTER,
    /** 密码错误 */
    GF_RESULT_CODE_FAILURE_PASSWORD_WORING,
    /** 未购买没有下载权限 */
    GF_RESULT_CODE_FAILURE_NOT_PERMISSION,
    /** 账户余额不足，无法完成购买 */
    GF_RESULT_CODE_FAILURE_INSUFFICIENT_BALANCE,
    /** 该本图书不允许试读 */
    GF_RESULT_CODE_FAILURE_NOT_PROBATION,
    /** 该数据已存在 */
    GF_RESULT_CODE_FAILURE_SERVERS_EXIST,
    /** 苹果充值失败 */
    GF_RESULT_CODE_FAILURE_RECHARGE_FAILURE,
    /** 兑换码失效或不存在 */
    GF_RESULT_CODE_FAILURE_CDKEY_NOT_EXIST,
    /** 原密码错误 */
    GF_RESULT_CODE_FAILURE_OLD_PASSWORD_WORING,
    /** 短信超过限制 */
    GF_RESULT_CODE_FAILURE_SMS_OVER_LIMIT,
    /** 第三方第一次登陆 */
    GF_RESULT_CODE_THIRD_PARTY_FIRST_LOGIN,
    /** 服务器数据已存在 */
    GF_RESULT_CODE_EXIST_DATA,
    
    /** 网络异常 */
    GF_RESULT_CODE_NETWORK_FAILURE,
    /** 请求失败 */
    GF_RESULT_CODE_FAILURE

} GFResultCode;

/**
 *  通用结果类
 */
@interface GFCommonResult : NSObject

/** 结果码 */
@property (nonatomic, assign) GFResultCode resultCode;

/** 结果描述 */
@property (nonatomic, strong) NSString *resultDesc;

/**
 *  通过结果码和结果描述生成结果对象
 *
 *  @param resultCode 结果码
 *  @param resultDesc 结果描述
 *
 *  @return 结果对象
 */
+ (instancetype)resultWithData:(int)resultCode resultDesc:(NSString *)resultDesc;


///解析数据返回状态
+ (instancetype)resultWithData:(id)data;


@end
