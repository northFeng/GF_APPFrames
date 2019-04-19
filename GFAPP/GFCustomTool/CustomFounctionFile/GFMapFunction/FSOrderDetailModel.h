//
//  FSOrderDetailModel.h
//  FlashSend
//
//  Created by gaoyafeng on 2018/9/28.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "APPBaseModel.h"

#import "FSOrderListModel.h"//订单列表model

NS_ASSUME_NONNULL_BEGIN

//骑手信息
@interface Rider : NSObject

///骑手名字
@property (nonatomic,copy) NSString *name;

///骑手头像地址
@property (nonatomic,copy,nullable) NSString *headIcon;

///骑手类型
@property (nonatomic,assign) NSInteger type;

///骑手接单数量
@property (nonatomic,copy,nullable) NSString *orderCount;

///骑手电话
@property (nonatomic,copy) NSString *mobile;

///纬度
@property (nonatomic,copy) NSString *latitude;

///经度
@property (nonatomic,copy) NSString *longitude;

@end

//发件信息
@interface SenderInfo : NSObject

///主地址
@property (nonatomic,copy) NSString *fromAddress;

///详细地址
@property (nonatomic,copy) NSString *fromAddressDetail;

///发件纬度
@property (nonatomic,copy) NSString *fromLatitude;

///发件经度
@property (nonatomic,copy) NSString *fromLongitude;

///发件人姓名
@property (nonatomic,copy) NSString *fromName;

///发件人电话
@property (nonatomic,copy) NSString *fromMobile;

///骑手距发件人距离
@property (nonatomic,copy) NSString *distance;


@end

//收件信息(暂时不用了)
@interface ReceiverInfo : NSObject

///-----订单序号
@property (nonatomic,copy) NSString *serialNum;

///-----收件订单号
@property (nonatomic,copy) NSString *orderDetailNum;

///-----取件码
@property (nonatomic,copy,nullable) NSString *receivePassword;

///收件主地址
@property (nonatomic,copy) NSString *toAddress;

///收件详细地址
@property (nonatomic,copy) NSString *toAddressDetail;

///收件纬度
@property (nonatomic,copy) NSString *toLatitude;

///收件经度
@property (nonatomic,copy) NSString *toLongitude;

///收件人姓名
@property (nonatomic,copy) NSString *toName;

///收件人电话
@property (nonatomic,copy) NSString *toMobile;

///电话分机号
@property (nonatomic,copy,nullable) NSString *privacyCode;

///快件类型
@property (nonatomic,copy) NSString *typeName;

///物品类型序号
@property (nonatomic,strong,nullable) NSString *goodType;

///物品名称
@property (nonatomic,copy,nullable) NSString *goodsName;

///快件重量
@property (nonatomic,copy) NSString *goodWeight;

///备注
@property (nonatomic,copy) NSString *remarks;

///支付时间
@property (nonatomic,copy) NSString *payTime;

///骑手距收件人距离
@property (nonatomic,copy) NSString *distance;

///保费（分）
@property (nonatomic,copy,nullable) NSString *insurance;

///备注标签，返回标签value
@property (nonatomic,copy,nullable) NSArray *remarksTag;


@end




@interface FSOrderDetailModel : APPBaseModel


///订单号
@property (nonatomic,copy) NSString *orderNum;

///0：即时单 1：预约单
@property (nonatomic,copy) NSString *appointType;

///0:正常单  1:追单
@property (nonatomic,assign) NSInteger is_append;

///10:常规配送，20:汽车配送
@property (nonatomic,assign) NSInteger vehicle;

///true:重新下单到众包，false:重新下单到全职
@property (nonatomic,copy,nullable) NSString *distributeCrowd;

///0:全职单，1:众包单
@property (nonatomic,assign) NSInteger createOrderType;

///取件码
@property (nonatomic,copy,nullable) NSString *pickupPassword;

///移动端取件码
@property (nonatomic,copy,nullable) NSString *pickupPasswordCode;


///10："待支付"、20:“派件中”, 30："待取货"、40："闪送中"、50： "已完成" 、60： "已取消"
@property (nonatomic,assign) NSInteger orderStatus;

///订单创建时间
@property (nonatomic,copy) NSString *createTime;

///服务器当前时间
@property (nonatomic,copy) NSString *currentTime;

///订单过期时间
@property (nonatomic,copy) NSString *expireTime;

/***********  新增  ********************/
///支付时间（1.4添加）
@property (nonatomic,copy) NSString *payTime;

///接单时间
@property (nonatomic,copy,nullable) NSString *orderTakeTime;

///到店时间
@property (nonatomic,copy,nullable) NSString *arriveShopTime;

///取货时间
@property (nonatomic,copy,nullable) NSString *goodsTakeTime;

///送达时间
@property (nonatomic,copy,nullable) NSString *deliverTime;

///取消时间
@property (nonatomic,copy,nullable) NSString *cancelTime;

/***********  新增  ********************/

///闪送员位置信息
@property (nonatomic,strong) Rider *courier;

///发件信息
@property (nonatomic,strong) SenderInfo *sender;

///收件信息列表
@property (nonatomic,copy) NSArray *receivers;

///订单取消原因
@property (nonatomic,copy) NSString *cancelReason;


//费用

///支付方式
@property (nonatomic,assign) NSInteger payMethod;

///里程费
@property (nonatomic,copy,nullable) NSString *distanceFee;

///续重费
@property (nonatomic,copy,nullable) NSString *overWeightFee;

///上门费
@property (nonatomic,copy,nullable) NSString *visitCharge;

///溢价费
@property (nonatomic,copy,nullable) NSString *premiumFee;

///夜间费
@property (nonatomic,copy,nullable) NSString *nightFee;

///跨江费
@property (nonatomic,copy,nullable) NSString *crossRiverFee;

///小费（单位：分）
@property (nonatomic,copy) NSString *additionFee;

///优惠费
@property (nonatomic,copy,nullable) NSString *couponPrice;

///(实际支付)订单总价（单位：分）
@property (nonatomic,copy) NSString *orderAmount;// realpayAmount

///优惠前的总价格
@property (nonatomic,copy,nullable) NSString *realpayAmount;


@end

NS_ASSUME_NONNULL_END
