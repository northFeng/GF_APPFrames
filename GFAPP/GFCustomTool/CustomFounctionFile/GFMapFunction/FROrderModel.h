//
//  FROrderModel.h
//  FlashRider
//
//  Created by gaoyafeng on 2018/12/21.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 取消订单model
@interface CancleOrderModel : NSObject

///系统取消（商家）
@property (nonatomic,copy,nullable) NSArray *arraySystem;

///转派
@property (nonatomic,copy,nullable) NSArray *arraySendOther;

@end

#pragma mark - 收件信息
@interface OrderChildModel : NSObject

///订单序号
@property (nonatomic,strong,nullable) NSString *serialNum;

///子订单号
@property (nonatomic,strong,nullable) NSString *detailNum;

///派送状态
@property (nonatomic,assign) NSInteger distributeStatus;

///纬度
@property (nonatomic,strong,nullable) NSString *latitude;

///经度
@property (nonatomic,strong,nullable) NSString *longitude;

///收件地址
@property (nonatomic,strong,nullable) NSString *targetAddress;

///收件详情地址
@property (nonatomic,strong,nullable) NSString *addressDetail;

///收件人名字
@property (nonatomic,strong,nullable) NSString *cutomerName;

///收件人手机号
@property (nonatomic,strong,nullable) NSString *cutomerMobile;

///快件重量
@property (nonatomic,copy,nullable) NSString *goodWeight;

///物品类型
@property (nonatomic,copy,nullable) NSString *typeName;

///备注
@property (nonatomic,copy,nullable) NSString *remarks;

///备注标签 "保温箱","14寸及以上"
@property (nonatomic,copy,nullable) NSArray *remarksTag;

///隐私号
@property (nonatomic,copy,nullable) NSString *privacyCode;

#pragma mark - 自己添加的控制字段
///自己到下个地址的距离
@property (nonatomic,copy,nullable) NSString *distanceToNext;


@end

#pragma mark - 订单列表
@interface OrderListModel : NSObject

///通知Id(自添)
@property (nonatomic,copy,nullable) NSString *localNotiId;

///本地存储订单ID(自添)
@property (nonatomic,copy,nullable) NSString *localStoreId;

///cell类型(自添)
@property (nonatomic,assign) NSInteger cellType;


///订单ID(后台数据)
@property (nonatomic,copy,nullable) NSString *idNum;

///贸易区Id
@property (nonatomic,copy,nullable) NSString *tradeAreaId;

///订单状态
@property (nonatomic,assign) NSInteger status;

///分发状态
@property (nonatomic,assign) NSInteger distributeStatus;

///骑手
@property (nonatomic,copy,nullable) NSString *courierId;

///是否追单
@property (nonatomic,assign) BOOL isAppend;

///取件烦方式 1:立即取件  2:预约取件
@property (nonatomic,assign) NSInteger pickupMethod;

///店铺id
@property (nonatomic,copy,nullable) NSString *shopId;

///店铺名称
@property (nonatomic,copy,nullable) NSString *shopName;

///店铺发单人手机号
@property (nonatomic,copy,nullable) NSString *mobile;

///店铺地址
@property (nonatomic,copy,nullable) NSString *address;

///店铺详情地址
@property (nonatomic,copy,nullable) NSString *addressDetail;

///店铺经纬度[116.2894390960784,40.0549524627331],
@property (nonatomic,copy,nullable) NSArray *location;

///小费(分)
@property (nonatomic,copy,nullable) NSString *additionFee;

///距离
@property (nonatomic,copy,nullable) NSArray *distances;

#pragma mark - ************** 时间参数 ***************
///到达时间(里面时间是秒，进行全部累加) 骑手位置到店1+送货1+送货2+送货3
@property (nonatomic,copy,nullable) NSArray *durations;

///骑手心跳收到订单时！骑手到店铺需要的时间（单位秒）
@property (nonatomic,copy,nullable) NSString *arriveShopDurations;


///创建时间(这个字段来自后台 订单创建时间（中间有支付时间差！）)
@property (nonatomic,copy,nullable) NSString *createTime;

///发单时间（这个字段来自后台，精确度毫秒）
@property (nonatomic,copy,nullable) NSString *distributeTime;

//下面这四个字段 精确度都是 秒！！
///接单时间
@property (nonatomic,copy,nullable) NSString *pickupTime;

///到店时间
@property (nonatomic,copy,nullable) NSString *arriveShopTime;

///取货时间(自添)
@property (nonatomic,copy,nullable) NSString *takeGoodTime;

///交付时间
@property (nonatomic,copy,nullable) NSString *deliverTime;


///子订单列表
@property (nonatomic,copy,nullable) NSArray *orderDetailResults;

///上报异常文字！！(自添)
@property (nonatomic,copy,nullable) NSString *abnormalInfo;


#pragma mark - 自己添加的本地控制字段

///预计送达时间时间戳(精度为秒)（这个字段是自己添加的对上面的时间数组进行计算出来的）
@property (nonatomic,copy,nullable) NSString *orderCompleteTime;

///店铺到第一单的距离
@property (nonatomic,copy,nullable) NSString *distanceShopToFirstOrder;

///取货照片OSS服务器 照片Id
@property (nonatomic,copy,nullable) NSString *goodPhotoOssId;

///后台转派订单后心跳的次数
@property (nonatomic,assign) NSInteger countSendOther;


///cell位置
///组位置
@property (nonatomic,assign) NSInteger sectionCell;

///行位置
@property (nonatomic,assign) NSInteger rowCell;

///cell高度
@property (nonatomic,assign) CGFloat cellHeight;


@end





@interface FROrderModel : NSObject

///订单列表
@property (nonatomic,copy,nullable) NSArray *orderResults;

///取消订单id(后台传过来的)
@property (nonatomic,copy,nullable) NSArray *cancleOrderNums;

///当前时间
@property (nonatomic,copy,nullable) NSString *timeSpan;


///手动取消的订单Model数组(自添)
@property (nonatomic,copy,nullable) NSArray *autoCancleArray;


@end


/**
 
 数据管理类（单利）
 来数据了就进行存储 ——> 到本地
 
 
 */


NS_ASSUME_NONNULL_END
