//
//  FSWXPayModel.h
//  FlashSend
//  微信支付model
//  Created by gaoyafeng on 2018/8/28.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "APPBaseModel.h"

@interface FSWXPayModel : APPBaseModel


///APPID
@property (nonatomic,copy) NSString *appId;

///商户号
@property (nonatomic,copy) NSString *partnerId;

///预支付订单ID
@property (nonatomic,copy) NSString *prepayId;

///填写固定值Sign=WXPay
@property (nonatomic,copy) NSString *packageValue;

///随机字符串
@property (nonatomic,copy) NSString *nonceStr;

///时间戳
@property (nonatomic,copy) NSString *timeStamp;

///签名
@property (nonatomic,copy) NSString *sign;



@end
