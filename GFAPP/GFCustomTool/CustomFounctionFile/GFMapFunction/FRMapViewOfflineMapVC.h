//
//  FRMapViewOfflineMapVC.h
//  FlashRider
//  离线地图
//  Created by gaoyafeng on 2019/5/7.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPBaseViewController.h"

#import "FSBaiDuMapManager.h"

@class MapOfflineCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface FRMapViewOfflineMapVC : APPBaseViewController

@end


#pragma mark - ********************** 城市列表 **********************
///地图离线地图城市列表
@interface MapOfflineCityListView : UIView <UITableViewDelegate,UITableViewDataSource>

///tableView
@property (nonatomic,strong,nullable) UITableView *tableView;

///热门城市
@property (nonatomic,copy,nullable) NSArray *arrayHotCitys;

///所以省市
@property (nonatomic,strong,nullable) NSMutableArray *arrayAllCitys;

///点击cell回调
@property (nonatomic,copy,nullable) APPBackBlock blockActionCell;

///刷新某个城市变为下载状态
- (void)refreshOneCellWithCityId:(int)cityId;


@end

#pragma mark - ********************** 下载管理 **********************
///地图下载管理列表
@interface MapOfflineDownManagerView : UIView <UITableViewDelegate,UITableViewDataSource>

///tableView
@property (nonatomic,strong,nullable) UITableView *tableView;

///正在下载的离线城市
@property (nonatomic,strong,nullable) NSMutableArray *arrayDowning;

///已下载完成
@property (nonatomic,strong,nullable) NSMutableArray *arrayDowned;

///点击cell回调
@property (nonatomic,copy,nullable) APPBackBlock blockActionCell;

///刷新数据
- (void)refreshDowningData:(BOOL)isAll;

///暂停所有下载
- (void)suspendedAllDown;

///删除一个下载中数据
- (void)deleteOneModelFromDowningDataWithCityId:(int)cityId;

///删除一个已下载数据
- (void)deleteOneModelFromDownedDataWithCityId:(int)cityId;


@end

/**
 总体思路：通过 BMK离线下载代理 发送通知 ——> 每一个cell接受通知 ——> 查询该城市离线信息 ——> 展示对应下载状态
 
 页面交互逻辑  1、城市列表，通过城市类型 区别 省&市 ——> 点击进行不同的操作
             2、下载管理 通过下载存储信息 来获取 下载中 & 已下载 城市
 */
#pragma mark - ************************ 离线地图cell ************************
@interface MapOfflineCell : UITableViewCell

///cellmodel
@property (nonatomic,strong,nullable) MapOfflineCellModel *cellModel;

///左边label
@property (nonatomic,strong,nullable) UILabel *labelLeft;

///右边label
@property (nonatomic,strong,nullable) UILabel *labelRight;

///小箭头
@property (nonatomic,strong,nullable) UIImageView *imgJT;

///分割线
@property (nonatomic,strong,nullable) UIView *lineH;

///下载完成回调
@property (nonatomic,copy,nullable) APPBackBlock blockDownComplete;

///cell 位置
@property (nonatomic,assign) NSInteger cellRow;

///赋值cellmodel
- (void)setCellModel:(MapOfflineCellModel *)model;


@end


#pragma mark - ************************ 城市列表model ************************
@interface MapOfflineCellModel : NSObject

///城市名称
@property (nonatomic, strong) NSString* cityName;
///数据包总大小
@property (nonatomic) int64_t size;
///城市ID
@property (nonatomic) int cityID;
///城市类型 0：全国；1：省份；2：城市；如果是省份，可以通过childCities得到子城市列表
@property (nonatomic) int cityType;

///子城市列表 (数组类为BMKOLSearchRecord)
@property (nonatomic, strong) NSArray *childCities;

///下载状态, -1:未定义 1:正在下载　2:等待下载　3:已暂停　4:完成 5:校验失败 6:网络异常 7:读写异常 8:Wifi网络异常 9:离线包数据格式异常，需重新下载离线包 10:离线包导入中
@property (nonatomic) int status;//离线地图 下载过程所有状态

//cell样式控制字段

///是否为省 0：全国；1：省份；2：城市 (全国过滤掉)
@property (nonatomic,assign) NSInteger cellType;

///下载状态 -1:未下载 0:有下载记录  1:正在下载  2:等待下载  3:暂停  4:下载完成  5:有更新
@property (nonatomic,assign) NSInteger downState;//自己控制下载状态——> status:5/6/7/8/9 当做3暂停处理  10当做4完成处理


///添加一个下载信息
+ (void)addOneOfflineDownInfoWithInfoDic:(NSDictionary *)downDic;

///删除一个下载信息
+ (void)removeOneOfflineDownInfoWithCityId:(int)cityId;

///查询是否有下载
+ (BOOL)getOneOfflineDownInfoWithCityId:(int)cityId;

///获取一个cellModel
+ (MapOfflineCellModel *)getOneOfflineCellModelWithCityModel:(BMKOLSearchRecord *)cityModel;

///获取热门城市model数组
+ (NSArray *)getHotCityCellModelArrayData;

///获取所有省市
+ (NSMutableArray *)getAllCityCellModelArrayData;

///获取正在下载的城市
+ (NSMutableArray *)getDowningCitysArrayData;

///获取已下载的城市
+ (NSMutableArray *)getDownedCitysArrayData;

///获取省中城市列表数组
+ (NSArray *)getCityListFormProvinceModel:(MapOfflineCellModel *)provinceModel;

@end

NS_ASSUME_NONNULL_END
