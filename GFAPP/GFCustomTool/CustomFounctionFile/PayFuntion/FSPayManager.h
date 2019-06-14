//
//  FSPayManager.h
//  FlashSend
//  闪送支付管理类
//  Created by gaoyafeng on 2018/8/27.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AlipaySDK/AlipaySDK.h>//支付宝SDK

#import "WXApi.h"//微信SDK

#import "FSWXPayModel.h"//微信字符model

@interface FSPayManager : NSObject <WXApiDelegate>//遵守微信代理


///单利
+ (instancetype)sharedManager;

///支付结果回调
//@property (nonatomic,copy) void(^blockPayResult)(BOOL success,NSString *strMsg);

///支付结果回调
@property (nonatomic,copy) APPBackBlock blockPayResult;


/**
 支付宝支付
 param: orderString 后台返回的字符串：订单拼接+订单签名
 */
- (void)payByAliPayWithOrderString:(NSString *)orderString;

///支付宝解析数据结果(支付宝支付返回APP时会触发)
- (void)aliPayAnalyticResultWithDictionary:(NSDictionary *)resultDic;


/**
 微信支付
 param:参数 orderDic 为 ，后台返回的字典
 */
- (void)payByWXPayWithOrderWxModel:(FSWXPayModel *)wxInfoModel;


///是否能打开微信
+ (BOOL)isCanOpenWeixin;


#pragma mark - 统一支付接口
/**
 *  @brief 支付统一接口
 *
 *  @param dicPayams 支付接口post参数字典
 *  @param payType 支付方式
 *  @param consumeType 消费方式 0:订单支付  1:小费
 *  @param resultBlock 支付结果触发回调
 *
 */
+ (void)paymentUnifiedWithPostPayams:(NSDictionary *)dicPayams payType:(NSInteger)payType consumeType:(NSInteger)consumeType resultBlock:(APPBackBlock)resultBlock;


@end

//注册微信支付
//[WXApi registerApp:[APPKeyInfo getWXPayAPPId]];


#pragma mark - 支付宝和微信支付触发的回调代理
/**ios9.0弃用
///微信支付重写代理
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:[FSPayManager sharedManager]];//代理用自定义的
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            if (![FSPayManager sharedManager].blockPayResult) {
                [FSPayManager sharedManager].blockPayResult = ^(BOOL success, NSString *strMsg) {
                    
                } ;
            }
            
            [[FSPayManager sharedManager] aliPayAnalyticResultWithDictionary:resultDic];
            
        }];
        
    }else if ([url.host isEqualToString:@"pay"]){
        //微信支付
        return [WXApi handleOpenURL:url delegate:[FSPayManager sharedManager]];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            if (![FSPayManager sharedManager].blockPayResult) {
                [FSPayManager sharedManager].blockPayResult = ^(BOOL success, NSString *strMsg) {
                    
                } ;
            }
            
            [[FSPayManager sharedManager] aliPayAnalyticResultWithDictionary:resultDic];
        }];
    }else if ([url.host isEqualToString:@"pay"]){
        //微信支付
        return [WXApi handleOpenURL:url delegate:[FSPayManager sharedManager]];
    }
    return YES;
}
 */
