//
//  GFURLRequest.h
//  MJExtension
//
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//


#import "GFCommonResult.h"

@implementation GFCommonResult

- (instancetype)init
{
    if (self = [super init])
    {
        self.resultCode = GF_RESULT_CODE_SUCCESS;
        self.resultDesc = @"";
    }
    
    return self;
}

- (instancetype)initWithData:(int)resultCode resultDesc:(NSString *)resultDesc
{
    if (self = [self init]) {
        self.resultCode = resultCode;
        self.resultDesc = resultDesc;
    }
    return self;
}

#pragma mark - class method

+ (instancetype)resultWithData:(int)resultCode resultDesc:(NSString *)resultDesc
{
    return [[self alloc] initWithData:resultCode resultDesc:resultDesc];
}

///解析数据返回状态
+ (instancetype)resultWithData:(id)data
{
    GFCommonResult *serviceResult = [[self alloc] init];
    
    if (data != nil && data != [NSNull null] && [data isKindOfClass:[NSDictionary class]]) {
        // 解析 错误码
        id value = [data objectForKey:@"state"];
        serviceResult.resultCode = ([NSNull null] == value || nil == value) ? 0 : [value intValue];

        if (serviceResult.resultCode!=100
            && serviceResult.resultCode!= 101
            /*  枚举里面的值  */
           ) {
            serviceResult.resultCode = GF_RESULT_CODE_NETWORK_FAILURE;
            serviceResult.resultDesc = @"请求失败";
        }
        
        // 关键结果码手动映射
        switch (serviceResult.resultCode) {
            case GF_RESULT_CODE_SUCCESS: {
                serviceResult.resultCode = GF_RESULT_CODE_SUCCESS;
                serviceResult.resultDesc = @"请求成功";
            }
                break;
            case GF_RESULT_CODE_FAILURE_PARAMETER_WORING: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_PARAMETER_WORING;
                serviceResult.resultDesc = @"参数错误";
            }
                break;
            case GF_RESULT_CODE_SUCCESS_DATA_EMPTY: {
                serviceResult.resultCode = GF_RESULT_CODE_SUCCESS_DATA_EMPTY;
                serviceResult.resultDesc = @"请求失败,请重试";
            }
                break;
            case GF_RESULT_CODE_FAILURE_ACCOUNT_LOSE: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_ACCOUNT_LOSE;
                serviceResult.resultDesc = @"账号失效，请重新登录";
            }
                break;
            case GF_RESULT_CODE_FAILURE_REGISTERED: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_REGISTERED;
                serviceResult.resultDesc = _kGFPhoneIsRegist;
            }
                break;
            case GF_RESULT_CODE_FAILURE_SERVERS_WORING: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_SERVERS_WORING;
                serviceResult.resultDesc = @"服务器数据读取错误";
            }
                break;
            case GF_RESULT_CODE_FAILURE_PAGE_WORING: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_PAGE_WORING;
                serviceResult.resultDesc = @"已无更多数据";
            }
                break;
            case GF_RESULT_CODE_FAILURE_NOT_REGISTER: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_NOT_REGISTER;
                serviceResult.resultDesc = @"该账号未被注册";
            }
                break;
            case GF_RESULT_CODE_FAILURE_PASSWORD_WORING: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_PASSWORD_WORING;
                serviceResult.resultDesc = @"密码错误";
            }
                break;
            case GF_RESULT_CODE_FAILURE_NOT_PERMISSION: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_NOT_PERMISSION;
                serviceResult.resultDesc = @"未购买没有下载权限";
            }
                break;
            case GF_RESULT_CODE_FAILURE_INSUFFICIENT_BALANCE: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_INSUFFICIENT_BALANCE;
                serviceResult.resultDesc = @"账户余额不足，无法完成购买";
            }
                break;
            case GF_RESULT_CODE_FAILURE_NOT_PROBATION: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_NOT_PROBATION;
                serviceResult.resultDesc = @"该本图书不允许试读";
            }
                break;
            case GF_RESULT_CODE_FAILURE_SERVERS_EXIST: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_SERVERS_EXIST;
                serviceResult.resultDesc = @"该数据已存在";
            }
                break;
            case GF_RESULT_CODE_FAILURE_RECHARGE_FAILURE: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_RECHARGE_FAILURE;
                serviceResult.resultDesc = @"苹果充值失败";
            }
                break;
            case GF_RESULT_CODE_FAILURE_CDKEY_NOT_EXIST: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_CDKEY_NOT_EXIST;
                serviceResult.resultDesc = @"兑换码失效或不存在";
            }
                break;
            case GF_RESULT_CODE_FAILURE_OLD_PASSWORD_WORING: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_OLD_PASSWORD_WORING;
                serviceResult.resultDesc = @"原密码错误";
            }
                break;
            case GF_RESULT_CODE_FAILURE_SMS_OVER_LIMIT: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE_SMS_OVER_LIMIT;
                serviceResult.resultDesc = @"操作过于频繁，请稍后重试";
            }
                break;
            case GF_RESULT_CODE_THIRD_PARTY_FIRST_LOGIN: {
                serviceResult.resultCode = GF_RESULT_CODE_THIRD_PARTY_FIRST_LOGIN;
                serviceResult.resultDesc = @"第三方第一次登陆";
            }
                break;
            case GF_RESULT_CODE_EXIST_DATA: {
                serviceResult.resultCode = GF_RESULT_CODE_EXIST_DATA;
                serviceResult.resultDesc = @"数据已存在";
            }
                break;
                
            case GF_RESULT_CODE_NETWORK_FAILURE: {
                serviceResult.resultCode = GF_RESULT_CODE_NETWORK_FAILURE;
                serviceResult.resultDesc = @"网络异常";
            }
                break;
            case GF_RESULT_CODE_FAILURE: {
                serviceResult.resultCode = GF_RESULT_CODE_FAILURE;
                serviceResult.resultDesc = @"请求失败";
            }
                break;
            default:
                serviceResult.resultDesc = @"返回结果乱码";
                break;
        }
    }
    
    return serviceResult;
}




@end
