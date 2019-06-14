//
//  FSPayManager.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/8/27.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSPayManager.h"

@implementation FSPayManager

+ (instancetype)sharedManager{
    
    static dispatch_once_t onceToken;//秀事成全局变量（生命周期随着APP生死）
    
    static FSPayManager *fsPayManager;
    
    dispatch_once(&onceToken, ^{
        
        fsPayManager = [[FSPayManager alloc] init];
        
    });
    
    return fsPayManager;
}

/**
 支付宝支付
 param: orderString 后台返回的字符串：订单拼接+订单签名
 */
- (void)payByAliPayWithOrderString:(NSString *)orderString{
    
    // NOTE: 如果加签成功，则继续执行支付
    if (orderString != nil) {
        
        //************************ 这里是支付成功后 ， 支付宝 根据这个scheme进行返回APP客户端 ********************
        NSString *appScheme = @"alipayshansongbusiness";//[APPKeyInfo getzfbAppScheme];
        
        typeof(self) weakSelf = self;
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            //解析结果
            [weakSelf aliPayAnalyticResultWithDictionary:resultDic];
        }];
    }else{
        
        if (self.blockPayResult) {
            
            self.blockPayResult(NO,@"数据错误");
        }
    }
    
}

///支付宝解析数据结果
- (void)aliPayAnalyticResultWithDictionary:(NSDictionary *)resultDic{
    
    NSInteger resultCode = [resultDic[@"resultStatus"] integerValue];
    
    NSString *strMsg = @"支付结果";
    switch (resultCode) {
        case 4000:
            NSLog(@"订单支付失败");
            strMsg = @"订单支付失败";
            self.blockPayResult(NO,strMsg);
            break;
        case 5000:
            NSLog(@"重复请求");
            strMsg = @"请勿重复请求";
            self.blockPayResult(NO,strMsg);
            break;
        case 6001:
            NSLog(@"用户中途取消");
            strMsg = @"支付失败";
            self.blockPayResult(NO,strMsg);
            break;
        case 6002:
            NSLog(@"网络连接出错");
            strMsg = @"支付失败";
            self.blockPayResult(NO,strMsg);
            break;
        case 6004:
            //这个必须去请求后台，去后台来确定 支付 是否成功
            NSLog(@"支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态");
            strMsg = @"支付结果未知";
            self.blockPayResult(NO,strMsg);
            break;
        case 8000:
            //这个必须去请求后台，去后台来确定 支付 是否成功
            NSLog(@"正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态");
            strMsg = @"支付正在处理";
            self.blockPayResult(NO,strMsg);
            break;
        case 9000:
            NSLog(@"订单支付成功");
            strMsg = @"订单支付成功";
            self.blockPayResult(YES,strMsg);
            /*
             1、商户需要验证该通知数据中的out_trade_no是否为商户系统中创建的订单号；2、判断total_amount是否确实为该订单的实际金额（即商户订单创建时的金额）；3、校验通知中的seller_id（或者seller_email) 是否为out_trade_no这笔单据对应的操作方（有的时候，一个商户可能有多个seller_id/seller_email）；4、验证app_id是否为该商户本身。上述1、2、3、4有任何一个验证不通过，则表明同步校验结果是无效的，只有全部验证通过后，才可以认定买家付款成功。
             */
            
            break;
            
        default:
            break;
    }
    
}

/**
 微信支付
 param:参数 wxInfoModel 为 ，后台返回数据
 */
- (void)payByWXPayWithOrderWxModel:(FSWXPayModel *)wxInfoModel{
    
    
    if ( wxInfoModel != nil) {
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = wxInfoModel.partnerId;//改为orderDic
        req.prepayId            = wxInfoModel.prepayId;//后台调用统一下单接口从微信获取的预付订单号，不需要处理
        req.nonceStr            = wxInfoModel.nonceStr;
        req.timeStamp           = wxInfoModel.timeStamp.intValue;
        req.package             = wxInfoModel.packageValue;
        req.sign                = wxInfoModel.sign;//这个把上面的所有参数按照微信支付文档拼接规则进行拼接+MD5签名
        [WXApi sendReq:req];
        //日志输出
        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",wxInfoModel.appId,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    }else{
        if (self.blockPayResult) {
            self.blockPayResult(NO, @"数据错误");
        }
    }
}


#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    // 判断支付类型
    if([resp isKindOfClass:[PayResp class]]){
        //支付回调
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = @"支付结果";
        
        PayResp *response= (PayResp*)resp;
        
        switch (response.errCode) {
            case WXSuccess:
                strMsg = @"支付成功";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                //支付成功去后台进行验证
                /*
                 后台验证参数：1、req.prepayId预付订单号
                 2、req.nonceStr随机字符串（32位）
                 */
                
                //回调处理
                if (self.blockPayResult) {
                    self.blockPayResult(YES,strMsg);
                }
                
                break;
            case WXErrCodeCommon:
                strMsg = @"支付失败";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                //支付成功去后台进行验证
                /*
                 后台验证参数：1、req.prepayId预付订单号
                 2、req.nonceStr随机字符串（32位）
                 */
                
                //回调处理
                if (self.blockPayResult) {
                    self.blockPayResult(NO,strMsg);
                }
                
                break;
            case WXErrCodeUserCancel:
                strMsg = @"您已取消支付";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                //支付成功去后台进行验证
                /*
                 后台验证参数：1、req.prepayId预付订单号
                 2、req.nonceStr随机字符串（32位）
                 */
                
                //回调处理
                if (self.blockPayResult) {
                    self.blockPayResult(NO,strMsg);
                }
                
                break;
                
            default:
                strMsg = @"支付失败";//[NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                //回调处理
                if (self.blockPayResult) {
                    self.blockPayResult(NO,strMsg);
                }
                
                break;
        }
        
    }
    
}


///是否能打开微信
+ (BOOL)isCanOpenWeixin{
    
    BOOL isCanOpen = [WXApi isWXAppInstalled];
    
    return isCanOpen;
}

#pragma mark - 统一支付接口
///支付统一接口
+ (void)paymentUnifiedWithPostPayams:(NSDictionary *)dicPayams payType:(NSInteger)payType consumeType:(NSInteger)consumeType resultBlock:(APPBackBlock)resultBlock{
    
    __weak typeof(self) weakSelf = self;
    
    NSString *url;
    switch (consumeType) {
        case 0:
        {
            //支付订单
            url = @"apppay_url";//_kNet_appPay;
        }
            break;
        case 1:
        {
            //支付小费
            url = @"xiaofei_url";//_kNet_addOrderTip;
        }
            break;
        default:
            break;
    }
    
    //赋值回调block
    [FSPayManager sharedManager].blockPayResult = resultBlock;
    
    [APPHttpTool postWithUrl:HTTPURL(url) params:dicPayams success:^(id response, NSInteger code) {
        
        NSString *message = [response objectForKey:@"msg"];
        id dataDic = [response objectForKey:@"data"];
        
        if (code == 200) {
            //请求成功
            [weakSelf requestNetDataSuccess:dataDic payType:payType];
        }else{
            // 错误处理
            if (resultBlock) {
                resultBlock(NO,message);
            }
        }
        
    } fail:^(NSError *error) {
        
        NSString *errorStr;
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            errorStr = @"网络连接失败...";
        }else{
            errorStr = @"网络不给力...";
        }
        
        if (resultBlock) {
            resultBlock(NO,errorStr);
        }
    }];
    
}


///请求成功数据处理  (这个方法要重写！！！)
+ (void)requestNetDataSuccess:(id)dicData payType:(NSInteger)payType{
    
    switch (payType) {
        case 1:
            //支付宝
            
            break;
        case 2:
            //微信公众号
            break;
        case 3:
            //微信APP支付
        {
            
            FSWXPayModel *model = [FSWXPayModel yy_modelWithJSON:dicData];
            if (model) {
                //调起微信APP支付
                [[FSPayManager sharedManager] payByWXPayWithOrderWxModel:model];
                
            }else{
                [FSPayManager sharedManager].blockPayResult(NO, @"获取支付信息失败,请重新支付");
            }
        }
            break;
        case 4:
            //银联
            
            break;
        case 5:
            //余额支付成功
            [FSPayManager sharedManager].blockPayResult(YES, dicData);
            break;
        case 6:
            //PC微信支付
            break;
            
        default:
            break;
    }
}


@end
