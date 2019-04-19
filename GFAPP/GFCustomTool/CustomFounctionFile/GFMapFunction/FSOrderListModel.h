//
//  FSOrderListModel.h
//  FlashSend
//  订单cellModel
//  Created by gaoyafeng on 2018/9/8.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "APPBaseModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface ReceiverListModel : NSObject

///订单序号（本地存储时为时间戳）
@property (nonatomic,copy) NSString *serialNum;

///子订单号
@property (nonatomic,copy,nullable) NSString *orderDetailNum;

///取件码
@property (nonatomic,copy,nullable) NSString *receivePassword;

///取件码(新增)
@property (nonatomic,copy,nullable) NSString *receivePasswordCode;

///目的地
@property (nonatomic,strong) NSString *toAddress;

///详细地址——>楼牌号/门牌号
@property (nonatomic,copy) NSString *toAddressDetail;

///纬度
@property (nonatomic,copy) NSString *toLatitude;

///经度
@property (nonatomic,copy) NSString *toLongitude;

///收件人name
@property (nonatomic,copy) NSString *toName;

///收件人手机号
@property (nonatomic,copy) NSString *toMobile;

///电话分机号
@property (nonatomic,copy,nullable) NSString *privacyCode;

///快件类型
@property (nonatomic,copy) NSString *typeName;

///物品类型序号
@property (nonatomic,strong,nullable) NSString *goodType;

///重量
@property (nonatomic,copy) NSString *goodWeight;

///备注
@property (nonatomic,copy) NSString *remarks;

///备注标签，返回标签value
@property (nonatomic,copy,nullable) NSArray *remarksTag;

///保价价格(单位分)  valuation
@property (nonatomic,strong,nullable) NSString *insurance;

///支付时间
@property (nonatomic,copy,nullable) NSString *payTime;

///骑手距收件人距离
@property (nonatomic,copy) NSString *distance;

///物品名称(1.4新增)
@property (nonatomic,copy,nullable) NSString *goodsName;

///选择的骑手id(新增)
@property (nonatomic,copy,nullable) NSString *riderId;


@end

///骑手信息
@interface RiderInfo : NSObject

///骑手名字
@property (nonatomic,copy,nullable) NSString *name;

///骑手手机号
@property (nonatomic,copy) NSString *mobile;

///纬度
@property (nonatomic,copy,nullable) NSString *latitude;

///经度
@property (nonatomic,copy,nullable) NSString *longitude;

@end


///费用详情
@interface OrderPriceDetail : NSObject

///(实际支付)总费用
@property (nonatomic,copy,nullable) NSString *orderAmount;// realpayAmount

///优惠前的总价格
@property (nonatomic,copy,nullable) NSString *realpayAmount;

///里程费
@property (nonatomic,copy,nullable) NSString *distanceFee;

///续重费
@property (nonatomic,copy,nullable) NSString *overWeightFee;

///小费
@property (nonatomic,copy,nullable) NSString *additionFee;

///优惠费
@property (nonatomic,copy,nullable) NSString *couponPrice;

///保价费
@property (nonatomic,copy,nullable) NSString *premiumPrice;

//新添加费用

///订单总保费(保价费用)
@property (nonatomic,copy,nullable) NSString *insuranceTotal;

///跨江费
@property (nonatomic,copy,nullable) NSString *crossRiverFee;

///夜间费
@property (nonatomic,copy,nullable) NSString *nightFee;

///取消订单扣费金额
@property (nonatomic,copy,nullable) NSString *debit;



@end

///每一个状态订单数量 (都是当天的订单量)
@interface OrderStateCount : NSObject

///总页数
@property (nonatomic,assign) NSInteger totalPageNum;

///待支付数量
@property (nonatomic,assign) NSInteger waitPayCount;

///派单中数量
@property (nonatomic,assign) NSInteger distributeCount;

///待取货数量
@property (nonatomic,assign) NSInteger pickupCount;

///闪送中数量
@property (nonatomic,assign) NSInteger deliverCount;

///完成数量
@property (nonatomic,assign) NSInteger finishCount;

///已取消数量
@property (nonatomic,assign) NSInteger cancleCount;



@end


@interface FSOrderListModel : APPBaseModel

///添加一个是否为追单类型

///订单号
@property (nonatomic,copy) NSString *orderNum;

///订单状态
@property (nonatomic,assign) NSInteger orderStatus;

///预约时间
@property (nonatomic,copy,nullable) NSString *appointmentDate;

///创建订单时间
@property (nonatomic,copy) NSString *createTime;

///创建订单日期时间
@property (nonatomic,copy,nullable) NSString *orderDate;

///服务器当前时间
@property (nonatomic,copy,nullable) NSString *currentTime;

///逾期时间
@property (nonatomic,copy) NSString *expireTime;

///支付时间
@property (nonatomic,copy) NSString *payTime;

///0:全职单，1:众包单
@property (nonatomic,assign) NSInteger createOrderType;

///取件码
@property (nonatomic,copy,nullable) NSString *pickupPassword;

///收件码
@property (nonatomic,copy,nullable) NSString *receivePassword;

///费用详情
@property (nonatomic,strong,nullable) OrderPriceDetail *orderPriceDetail;

///追单列表
@property (nonatomic,copy) NSArray *receiverList;

///骑手信息
@property (nonatomic,strong) RiderInfo *courier;

///************ 新增1.4版本 ************

///接单时间
@property (nonatomic,copy,nullable) NSString *orderTakeTime;

///取货时间
@property (nonatomic,copy,nullable) NSString *goodsTakeTime;

///取消时间
@property (nonatomic,copy,nullable) NSString *cancelTime;





//cell状态控制
///cell高度
@property (nonatomic,assign) CGFloat cellHeight;

///cell位置
@property (nonatomic,assign) NSInteger section;

///cellrow
@property (nonatomic,assign) NSInteger row;


@end

NS_ASSUME_NONNULL_END
