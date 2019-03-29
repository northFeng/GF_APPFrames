//
//  FSCitySelectVC.h
//  FlashSend
//  城市选择VC
//  Created by gaoyafeng on 2019/3/7.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "APPBaseViewController.h"

@class FSSearchLocalModel;

NS_ASSUME_NONNULL_BEGIN

@interface FSCitySelectVC : APPBaseViewController

///来自哪里 0:商户认证  1:地址搜索
@property (nonatomic,assign) NSInteger formType;

///店铺地址搜索结果model
@property (nonatomic,strong,nullable) FSSearchLocalModel *mapAddressModel;

///回调
@property (nonatomic,copy,nullable) APPBackBlock blockAddress;

///从地址搜索进来的回调处理
@property (nonatomic,copy,nullable) APPBackBlock blockSearch;

@end

///自制cell
@interface CityInfoCell : UITableViewCell

///背景图
@property (nonatomic,strong,nullable) UIView *backView;

///标题
@property (nonatomic,strong,nullable) UILabel *labelTitle;

@end

#pragma mark - 自定义索引视图

@protocol GFIndexViewDelegate <NSObject>

///触摸索引触发代理
- (void)scrollTableViewForSectionIndexTitle:(NSString *)title atIndex:(NSIndexPath *)indexPath;

@end

@interface GFIndexView : UIView

///字母字体
@property (nonatomic,strong,nullable) UIFont *labelFont;

///导航条代理
@property (nonatomic,weak) id <GFIndexViewDelegate> delegate;

///是否显示Label
@property (nonatomic,assign) BOOL isShowTipView;


///设置数据源
- (void)setArrayData:(NSArray<NSString *> *)arrayData;


@end


@interface FSSearchLocalModel : NSObject

///标题
@property (nonatomic,copy) NSString *title;

///副标题
@property (nonatomic,copy) NSString *brief;

///纬度
@property (nonatomic,copy) NSString *latitude;

///经度
@property (nonatomic,copy) NSString *longitude;

///距离
@property (nonatomic,copy) NSString *extra;

///城市ID
@property (nonatomic,copy,nullable) NSString *cityId;

///城市名字
@property (nonatomic,copy,nullable) NSString *cityName;

///处理数据列表
+ (NSMutableArray *)hanndleDataListWithData:(id)dicData;


@end



@interface FSCityListModel : NSObject

///城市ID
@property (nonatomic,copy,nullable) NSString *cityId;

///是否开通 0未开通 1开通
@property (nonatomic,assign) BOOL isBusinessOpen;

///城市名字
@property (nonatomic,copy,nullable) NSString *bdName;

///
@property (nonatomic,copy,nullable) NSString *areaId;

///
@property (nonatomic,copy,nullable) NSString *utime;

///招募是否开通
@property (nonatomic,assign) BOOL isRecruitOpen;


@property (nonatomic,assign) NSInteger status;

///
@property (nonatomic,copy,nullable) NSString *oldCityId;

///
@property (nonatomic,assign) NSInteger areaType;


///
@property (nonatomic,copy,nullable) NSString *businessOpenTime;

///
@property (nonatomic,copy,nullable) NSString *parentCityId;


@property (nonatomic,copy,nullable) NSString *code;


@property (nonatomic,copy,nullable) NSString *ctime;

///城市名字
@property (nonatomic,copy,nullable) NSString *name;




@end




NS_ASSUME_NONNULL_END
