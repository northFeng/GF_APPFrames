//
//  FSBaiDuMapManager.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/8/30.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSBaiDuMapManager.h"

//BMKPoiSearchDelegate——>百度检索代理  BMKSuggestionSearchDelegate——>百度关键词匹配搜索  BMKCloudSearchDelegate——>百度云检索代理
@interface FSBaiDuMapManager () <BMKGeneralDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate,BMKPoiSearchDelegate,BMKSuggestionSearchDelegate,BMKCloudSearchDelegate>//遵守百度定位代理

///百度地图管理者
@property (nonatomic,strong) BMKMapManager *mapManager;

///定位管理者
@property (nonatomic,strong) BMKLocationManager *locationManager;

///block
@property (nonatomic,copy) BlockInfo blockinfo;

///位置字符串
@property (nonatomic,copy) NSString *localCodeString;

///位置地名
@property (nonatomic,copy) NSString *localNameString;

///回调
@property (nonatomic,copy,nullable) APPBackBlock blockResult;


@end

@implementation FSBaiDuMapManager


///获取地图管理者
+(instancetype)shareInstance
{
    static FSBaiDuMapManager *mapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapManager = [[self alloc] init];
    });
    return mapManager;
}

- (instancetype)init{
    
    if ([super init]) {
        
        [self configurationInformation];
    }
    return self;
}


///配置地图信息
- (void)configurationInformation{
    
    //地图管理
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:[APPKeyInfo getBaiDuAK]  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //定位管理
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:[APPKeyInfo getBaiDuAK] authDelegate:self];
    
    
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    //_locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 6;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 4;
    
}


#pragma mark - ********************* 百度地图管理者 BMKGeneralDelegate *********************
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


#pragma mark - ********************* 百度授权验证代理BMKLocationAuthDelegate *********************
/**
 *@brief 返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKLocationAuthErrorCode
 */
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    
}


#pragma mark - ********************* 百度定位代理 BMKLocationManagerDelegate *********************
/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error{
    NSLog(@"定位发生错误");
}


/**
 *  @brief 连续定位回调函数。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param location 定位结果，参考BMKLocation。
 *  @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    NSLog(@"连续定位回调函数");
}

/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 BMKLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"定位权限状态改变");
    
}


/**
 * @brief 该方法为BMKLocationManager提示需要设备校正回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例。
 */
- (BOOL)BMKLocationManagerShouldDisplayHeadingCalibration:(BMKLocationManager * _Nonnull)manager{
    
    
    return YES;
}

/**
 * @brief 该方法为BMKLocationManager提供设备朝向的回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 * @param heading 设备的朝向结果
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
          didUpdateHeading:(CLHeading * _Nullable)heading{
    
    
}

/**
 * @brief 该方法为BMKLocationManager所在App系统网络状态改变的回调事件。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 * @param state 当前网络状态
 * @param error 错误信息
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
     didUpdateNetworkState:(BMKLocationNetworkState)state orError:(NSError * _Nullable)error{
    
    
}


#pragma mark - 自定义接口
///获取一次地理位置
- (void)getGeographicInformationWithCallback:(BlockInfo)blockInfo{
    
    
    [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        
        LocaleInfoModel *model;
        
        if (location) {
            //获取地理位置成功
            model = [[LocaleInfoModel alloc] init];
            
            //            //获取高德WGS84坐标 不用转换！！！
            //            CLLocationCoordinate2D wgs84j02Coord = CLLocationCoordinate2DMake(location.location.coordinate.latitude, location.location.coordinate.longitude);
            //            // 转为百度经纬度类型的坐标
            //            CLLocationCoordinate2D bd09Coord = BMKCoordTrans(wgs84j02Coord, BMK_COORDTYPE_GPS, BMK_COORDTYPE_BD09LL);
            
            
            model.latitude = [NSString stringWithFormat:@"%.8f",location.location.coordinate.latitude];
            model.longitude = [NSString stringWithFormat:@"%.8f",location.location.coordinate.longitude];
            
            
            model.country = location.rgcData.country;
            model.countryCode = location.rgcData.countryCode;
            model.province = location.rgcData.province;
            model.city = location.rgcData.city;
            model.district = location.rgcData.district;
            model.street = location.rgcData.street;
            model.streetNumber = location.rgcData.streetNumber;
            model.cityCode = location.rgcData.cityCode;
            model.adCode = location.rgcData.adCode;
            model.locationDescribe = location.rgcData.locationDescribe;
            
            if (blockInfo) {
                blockInfo(model,error);
            }
            
        }else{
            NSLog(@"获取位置失败：%@",error.description);
            if (blockInfo) {
                blockInfo(model,error);
            }
        }
    }];
    
}

#pragma mark - ************************ 百度检索 ************************


#pragma mark - 城市内检索
- (void)bmkSearchInCity:(NSString *)cityName keyWord:(NSString *)searchKey blockResult:(APPBackBlock)blockResult{
    _blockResult = blockResult;
    
    //初始化请求参数类BMKCitySearchOption的实例
    BMKPOICitySearchOption *cityOption = [[BMKPOICitySearchOption alloc]init];
    //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
    cityOption.city= cityName;
    //检索关键字
    cityOption.keyword = searchKey;
    cityOption.isCityLimit = YES;//只限制在本城市内搜索
    [self searchInCityData:cityOption];
}

- (void)searchInCityData:(BMKPOICitySearchOption *)option {
    //初始化BMKPoiSearch实例
    BMKPoiSearch *POISearch = [[BMKPoiSearch alloc] init];
    //设置POI检索的代理
    POISearch.delegate = self;
    //初始化请求参数类BMKCitySearchOption的实例
    BMKPOICitySearchOption *cityOption = [[BMKPOICitySearchOption alloc]init];
    //检索关键字，必选。举例：天安门
    cityOption.keyword = option.keyword;
    //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
    cityOption.city = option.city;
    //检索分类，与keyword字段组合进行检索，多个分类以","分隔。举例：美食,酒店
    cityOption.tags = option.tags;
    //区域数据返回限制，可选，为true时，仅返回city对应区域内数据
    cityOption.isCityLimit = option.isCityLimit;
    /**
     POI检索结果详细程度
     
     BMK_POI_SCOPE_BASIC_INFORMATION: 基本信息
     BMK_POI_SCOPE_DETAIL_INFORMATION: 详细信息
     */
    cityOption.scope = option.scope;
    //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
    cityOption.filter = option.filter;
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    cityOption.pageIndex = option.pageIndex;
    
    //单次召回POI数量，默认为10条记录，最大返回20条
    cityOption.pageSize = 20;//option.pageSize;
    /**
     城市POI检索：异步方法，返回结果在BMKPoiSearchDelegate的onGetPoiResult里
     
     cityOption 城市内搜索的搜索参数类（BMKCitySearchOption）
     成功返回YES，否则返回NO
     */
    BOOL flag = [POISearch poiSearchInCity:cityOption];
    if(flag) {
        NSLog(@"POI城市内检索成功");
    } else {
        NSLog(@"POI城市内检索失败");
        if (self.blockResult) {
            self.blockResult(NO, @"检索失败");
        }
    }
}


#pragma mark - 附近（周边）检索(POI圆形区域检索)
- (void)bmkSearchNearInCity:(NSString *)cityName locationCoord:(CLLocationCoordinate2D)localInfo keyWord:(NSString *)searchKey nearRadius:(int)radius blockResult:(APPBackBlock)blockResult{
    _blockResult = blockResult;
    
    //初始化请求参数类BMKNearbySearchOption的实例
    BMKPOINearbySearchOption *nearbyOption = [[BMKPOINearbySearchOption alloc]init];
    //检索关键字
    nearbyOption.keywords = searchKey.length ? @[searchKey] : @[];
    //检索的中心点
    nearbyOption.location = localInfo;
    
    //检索半径
    nearbyOption.radius = radius;
    
    //是否严格限定召回结果在设置检索半径范围内。默认值为false。
    nearbyOption.isRadiusLimit = YES;
    
    [self searchNearInCity:nearbyOption];
    
}

- (void)searchNearInCity:(BMKPOINearbySearchOption *)option {
    //初始化BMKPoiSearch实例
    BMKPoiSearch *POISearch = [[BMKPoiSearch alloc] init];
    //设置POI检索的代理
    POISearch.delegate = self;
    //初始化请求参数类BMKNearbySearchOption的实例
    BMKPOINearbySearchOption *nearbyOption = [[BMKPOINearbySearchOption alloc]init];
    /**
     检索关键字，必选。
     在周边检索中关键字为数组类型，可以支持多个关键字并集检索，如银行和酒店。每个关键字对应数组一个元素。
     最多支持10个关键字。
     */
    nearbyOption.keywords = option.keywords;
    //检索中心点的经纬度，必选
    nearbyOption.location = option.location;
    /**
     检索半径，单位是米。
     当半径过大，超过中心点所在城市边界时，会变为城市范围检索，检索范围为中心点所在城市
     */
    nearbyOption.radius = option.radius;
    /**
     检索分类，可选。
     该字段与keywords字段组合进行检索。
     支持多个分类，如美食和酒店。每个分类对应数组中一个元素
     */
    nearbyOption.tags = option.tags;
    /**
     是否严格限定召回结果在设置检索半径范围内。默认值为false。
     值为true代表检索结果严格限定在半径范围内；值为false时不严格限定。
     注意：值为true时会影响返回结果中total准确性及每页召回poi数量，我们会逐步解决此类问题。
     */
    nearbyOption.isRadiusLimit = option.isRadiusLimit;
    /**
     POI检索结果详细程度
     
     BMK_POI_SCOPE_BASIC_INFORMATION: 基本信息
     BMK_POI_SCOPE_DETAIL_INFORMATION: 详细信息
     */
    nearbyOption.scope = option.scope;
    //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
    nearbyOption.filter = option.filter;
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    nearbyOption.pageIndex = option.pageIndex;
    
    
    //单次召回POI数量，默认为10条记录，最大返回20条。
    nearbyOption.pageSize = 20;//option.pageSize;
    /**
     根据中心点、半径和检索词发起周边检索：异步方法，返回结果在BMKPoiSearchDelegate
     的onGetPoiResult里
     
     nearbyOption 周边搜索的搜索参数类
     成功返回YES，否则返回NO
     */
    BOOL flag = [POISearch poiSearchNearBy:nearbyOption];
    if(flag) {
        NSLog(@"POI周边检索成功");
    } else {
        NSLog(@"POI周边检索失败");
        if (self.blockResult) {
            self.blockResult(NO, @"检索失败");
        }
    }
}



#pragma mark - POI检索结果回调
/**
 POI检索返回结果回调
 
 @param searcher 检索对象
 @param poiResult POI检索结果列表
 @param error 错误码
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)error {
    
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        for (NSUInteger i = 0; i < poiResult.poiInfoList.count; i ++) {
            //POI信息类的实例
            BMKPoiInfo *POIInfo = poiResult.poiInfoList[i];
            
            /**
             if ([POIInfo.city isEqualToString:APPManagerUserInfo.cityName]) {
             //同一城市
             NSMutableDictionary *dicLoacalInfo = [NSMutableDictionary dictionary];
             [dicLoacalInfo gf_setObject:POIInfo.name withKey:@"title"];
             [dicLoacalInfo gf_setObject:POIInfo.address withKey:@"brief"];
             [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%.f",POIInfo.pt.latitude] withKey:@"latitude"];
             [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%.f",POIInfo.pt.longitude] withKey:@"longitude"];
             [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%ld",POIInfo.distance] withKey:@"distance"];
             
             [annotations addObject:dicLoacalInfo];
             }
             */
            
            NSMutableDictionary *dicLoacalInfo = [NSMutableDictionary dictionary];
            [dicLoacalInfo gf_setObject:POIInfo.name withKey:@"title"];
            [dicLoacalInfo gf_setObject:POIInfo.address withKey:@"brief"];
            [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%f",POIInfo.pt.latitude] withKey:@"latitude"];
            [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%f",POIInfo.pt.longitude] withKey:@"longitude"];
            [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%ld",POIInfo.distance] withKey:@"distance"];
            
            [annotations addObject:dicLoacalInfo];
        }
        
        if (self.blockResult) {
            self.blockResult(YES, annotations);
        }
    }else{
        
        //解析错误码
        [self handleErrorCodeWithCode:error];
    }
}

#pragma mark - 解析错误码
///解析错误码
- (void)handleErrorCodeWithCode:(BMKSearchErrorCode)errorCode{
    
    if (self.blockResult) {
        
        //错误码解析
        NSString *errorDes;
        switch (errorCode) {
            case BMK_SEARCH_NO_ERROR:
                errorDes = @"检索成功";
                break;
            case BMK_SEARCH_AMBIGUOUS_KEYWORD:
                errorDes = @"检索词有岐义";
                break;
            case BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
                errorDes = @"检索地址有岐义";
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS:
                errorDes = @"该城市不支持公交搜索";
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
                errorDes = @"不支持跨城市公交";
                break;
            case BMK_SEARCH_RESULT_NOT_FOUND:
                errorDes = @"没有找到检索结果";
                break;
            case BMK_SEARCH_ST_EN_TOO_NEAR:
                errorDes = @"起终点太近";
                break;
            case BMK_SEARCH_KEY_ERROR:
                errorDes = @"搜索词错误";
                break;
            case BMK_SEARCH_NETWOKR_ERROR:
                errorDes = @"网络连接错误";
                break;
            case BMK_SEARCH_NETWOKR_TIMEOUT:
                errorDes = @"网络连接超时";
                break;
            case BMK_SEARCH_PERMISSION_UNFINISHED:
                errorDes = @"检索失败";
                break;
            case BMK_SEARCH_INDOOR_ID_ERROR:
                errorDes = @"检索失败";
                break;
            case BMK_SEARCH_FLOOR_ERROR:
                errorDes = @"室内图检索楼层错误";
                break;
            case BMK_SEARCH_INDOOR_ROUTE_NO_IN_BUILDING:
                errorDes = @"起终点不在支持室内路线的室内图内";
                break;
            default:
                errorDes = @"检索失败";
                break;
        }
        self.blockResult(NO, errorDes);
    }
}



#pragma mark - 城市关键词匹配检索
- (void)bmkSearchSuggestioInCity:(NSString *)cityName keyWord:(NSString *)searchKey blockResult:(APPBackBlock)blockResult{
    _blockResult = blockResult;
    
    BMKSuggestionSearchOption* suggestionOption = [[BMKSuggestionSearchOption alloc] init];
    //检索关键字
    suggestionOption.keyword = searchKey;
    //区域名称(市或区的名字，如北京市，海淀区)
    suggestionOption.cityname = cityName;
    
    //只限制在本城市内搜索
    suggestionOption.cityLimit = YES;
    
    [self suggestiosearchData:suggestionOption];
}

- (void)suggestiosearchData:(BMKSuggestionSearchOption *)option {
    //初始化BMKSuggestionSearch实例
    BMKSuggestionSearch *suggestionSearch = [[BMKSuggestionSearch alloc] init];
    //设置关键词检索的代理
    suggestionSearch.delegate = self;
    //初始化请求参数类BMKSuggestionSearchOption的实例
    BMKSuggestionSearchOption* suggestionOption = [[BMKSuggestionSearchOption alloc] init];
    //城市名
    suggestionOption.cityname = option.cityname;
    //检索关键字
    suggestionOption.keyword  = option.keyword;
    //是否只返回指定城市检索结果，默认为NO（海外区域暂不支持设置cityLimit）
    suggestionOption.cityLimit = option.cityLimit;
    /**
     关键词检索，异步方法，返回结果在BMKSuggestionSearchDelegate
     的onGetSuggestionResult里
     
     suggestionOption sug检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [suggestionSearch suggestionSearch:suggestionOption];
    if(flag) {
        NSLog(@"POI城市内检索成功");
    } else {
        NSLog(@"POI城市内检索失败");
        if (self.blockResult) {
            self.blockResult(NO, @"检索失败");
        }
    }
}


#pragma mark - 关键字检索结果回调
/**
 关键字检索结果回调
 
 @param searcher 检索对象
 @param result 关键字检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        
        for (BMKSuggestionInfo *sugInfo in result.suggestionList) {
            
            //同一城市
            NSMutableDictionary *dicLoacalInfo = [NSMutableDictionary dictionary];
            [dicLoacalInfo gf_setObject:sugInfo.key withKey:@"title"];
            [dicLoacalInfo gf_setObject:sugInfo.address withKey:@"brief"];
            [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%.f",sugInfo.location.latitude] withKey:@"latitude"];
            [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%.f",sugInfo.location.longitude] withKey:@"longitude"];
            //[dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%ld",sugInfo.distance] withKey:@"distance"];
            
            [annotations addObject:dicLoacalInfo];
        }
        
        if (self.blockResult) {
            self.blockResult(YES, annotations);
        }
        
    }else{
        
        //解析错误码
        [self handleErrorCodeWithCode:error];
    }
}




#pragma mark - 附近（周边）云检索
- (void)bmkCloudNearSearchInCity:(NSString *)cityName locationCoord:(NSString *)localInfo nearRadius:(int)radius blockResult:(APPBackBlock)blockResult{
    _blockResult = blockResult;
    
    //初始化请求参数类BMKCloudNearbySearchInfo的实例
    BMKCloudNearbySearchInfo *cloudNearbyInfo = [[BMKCloudNearbySearchInfo alloc]init];
    //access_key，最大长度50，必选
    cloudNearbyInfo.ak = @"4o6KrPUQolLwrhub1OYgNm9ykWz18fhM";//[APPKeyInfo getBaiDuAK];
    //geo table表主键，必选
    cloudNearbyInfo.geoTableId = 8295912;
    //检索的中心点，逗号分隔的经纬度(116.4321,38.76623)，最长不超过25个字符，必选
    cloudNearbyInfo.location = localInfo;
    //周边检索半径，必选
    cloudNearbyInfo.radius = radius;
    
    [self cloudNNearSearch:cloudNearbyInfo];
    
}

- (void)cloudNNearSearch:(BMKCloudNearbySearchInfo *)info {
    //初始化BMKBMKCloudSearch实例
    BMKCloudSearch *cloudSearch = [[BMKCloudSearch alloc]init];
    //设置周边云检索的代理
    cloudSearch.delegate = self;
    //初始化请求参数类BMKCloudNearbySearchInfo的实例
    BMKCloudNearbySearchInfo *cloudNearbyInfo = [[BMKCloudNearbySearchInfo alloc]init];
    //access_key，最大长度50，必选
    cloudNearbyInfo.ak = info.ak;
    //用户的权限签名，最大长度50，可选
    cloudNearbyInfo.sn = info.sn;
    //geo table表主键，必选
    cloudNearbyInfo.geoTableId = info.geoTableId;
    //检索关键字
    cloudNearbyInfo.keyword = info.keyword;
    //标签，空格分隔的多字符串，最长45个字符，样例：美食 小吃，可选
    cloudNearbyInfo.tags = info.tags;
    /**
     排序字段，可选： sortby={keyname}:1 升序；sortby={keyname}:-1 降序
     以下keyname为系统预定义的：
     1.distance 距离排序
     2.weight 权重排序
     默认为按weight排序
     如果需要自定义排序则指定排序字段，样例：按照价格由便宜到贵排序sortby=price:1
     */
    //排序字段，可选： sortby={keyname}:1 升序；sortby={keyname}:-1 降序
    cloudNearbyInfo.sortby = info.sortby;
    /**
     过滤条件，可选
     '|'竖线分隔的多个key-value对
     key为筛选字段的名称(存储服务中定义)
     value可以是整形或者浮点数的一个区间：格式为“small,big”逗号分隔的2个数字
     样例：筛选价格为9.99到19.99并且生产时间为2013年的项：price:9.99,19.99|time:2012,2012
     */
    //过滤条件，可选:'|'竖线分隔的多个key-value对,price:9.99,19.99|time:2012,2012
    cloudNearbyInfo.filter = info.filter;
    //分页索引，默认为0，可选
    cloudNearbyInfo.pageIndex = info.pageIndex;
    
    //分页数量，默认为10，最多为50，可选
    cloudNearbyInfo.pageSize = 20;//info.pageSize;
    
    
    //检索的中心点，逗号分隔的经纬度(116.4321,38.76623)，最长不超过25个字符
    cloudNearbyInfo.location = info.location;
    //周边检索半径
    cloudNearbyInfo.radius = info.radius;
    /**
     周边云检索，异步方法，返回结果在BMKCloudSearchDelegate的
     onGetCloudPoiResult里
     
     cloudNearbyInfo 周边云检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [cloudSearch nearbySearchWithSearchInfo:cloudNearbyInfo];
    if(flag) {
        NSLog(@"周边云检索成功");
    } else {
        NSLog(@"周边云检索失败");
        if (self.blockResult) {
            self.blockResult(NO, @"检索失败");
        }
    }
}

#pragma mark - BMKCloudSearchDelegate
/**
 POI云检索结果回调
 
 @param poiResultList POI云检索结果列表
 @param type 返回结果类型：BMK_CLOUD_LOCAL_SEARCH,BMK_CLOUD_NEARBY_SEARCH,BMK_CLOUD_BOUND_SEARCH
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetCloudPoiResult:(NSArray *)poiResultList searchType:(int)type errorCode:(int)error {
    
    //云检索结果列表类
    BMKCloudPOIList *cloudPOI = poiResultList[0];
    
    /**
     //云检索结果信息类
     BMKCloudPOIInfo *POIInfo = cloudPOI.POIs[0];
     */
    
    if (error == 0) {
        
        NSMutableArray *annotations = [NSMutableArray array];
        
        for (NSUInteger i = 0; i < cloudPOI.POIs.count ; i ++) {
            //POI信息类的实例
            BMKCloudPOIInfo *POIInfo = cloudPOI.POIs[i];
            
            if ([POIInfo.city isEqualToString:@"北京市"]) {
                
                NSMutableDictionary *dicLoacalInfo = [NSMutableDictionary dictionary];
                [dicLoacalInfo gf_setObject:POIInfo.title withKey:@"title"];
                [dicLoacalInfo gf_setObject:POIInfo.address withKey:@"brief"];
                [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%.f",POIInfo.latitude] withKey:@"latitude"];
                [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%.f",POIInfo.longitude] withKey:@"longitude"];
                [dicLoacalInfo gf_setObject:[NSString stringWithFormat:@"%.f",POIInfo.distance] withKey:@"distance"];
                
                [annotations addObject:dicLoacalInfo];
            }
        }
        
        if (self.blockResult) {
            self.blockResult(YES, annotations);
        }
    }else{
        NSString *errorDes;
        
        switch (error) {
            case BMK_CLOUD_PERMISSION_UNFINISHED:
                errorDes = @"检索失败";
                break;
            case BMK_CLOUD_NETWOKR_ERROR:
                errorDes = @"网络连接错误";
                break;
            case BMK_CLOUD_NETWOKR_TIMEOUT:
                errorDes = @"网络连接超时";
                break;
            case BMK_CLOUD_RESULT_NOT_FOUND:
                errorDes = @"没有找到检索结果";
                break;
            case BMK_CLOUD_NO_ERROR:
                errorDes = @"检索结果正常返回";
                break;
            case BMK_CLOUD_SERVER_ERROR:
                errorDes = @"检索失败";
                break;
            case BMK_CLOUD_PARAM_ERROR:
                errorDes = @"检索失败";
                break;
                
            default:
                errorDes = @"检索失败";
                break;
        }
        
        if (self.blockResult) {
            self.blockResult(NO, errorDes);
        }
    }
}


#pragma mark - 计算两点之间的距离

+ (double)calculateTheDistanceBetweenTwoPoints:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint{
    
    BMKMapPoint pointStart = BMKMapPointForCoordinate(startPoint);//将 经纬度坐标  转换为 投影后的  直角地理坐标(这个类里都是 转换/判断矩形、点与点 API)
    
    BMKMapPoint pointEnd = BMKMapPointForCoordinate(endPoint);//BMKGeometry.h 文件中各种判断地图上的点与点，矩形与矩形。。。等比对与计算
    
    CLLocationDistance distance = BMKMetersBetweenMapPoints(pointStart, pointEnd);
    
    return distance;
}


///计算两点之间的角度
+ (CGFloat)computingAngleWithStart:(CLLocationCoordinate2D)pointStart end:(CLLocationCoordinate2D)pointEnd{
    
    /**
     M_PI 表示的是弧度
     
     atan2()如何转换为角度
     Math.atan2()函数返回点(x,y)和原点(0,0)之间直线的倾斜角.那么如何计算任意两点间直线的倾斜角呢?只需要将两点x,y坐标分别相减得到一个新的点(x2-x1,y2-y1).然后利用他求出角度就可以了.使用下面的一个转换可以实现计算出两点间连线的夹角.Math.atan2(y2-y1,x2-x1)
     
     不过这样我们得到的是一个弧度值,在一般情况下我们需要把它转换为一个角度.
     
     下面我们用一段代码来测试一下这样的转换.
     
     //测试,计算点(3,3)和(5,5)构成的连线的夹角
     
     x=Math.atan2(5-3,5-3)
     
     trace(x)//输出0.785398163397448
     
     x=x*180/Math.PI//转换为角度
     */
    
    
    CGFloat angle = 0.;
    
    /**
     将 经纬度坐标  转换为 投影后的  直角地理坐标(这个类里都是 转换/判断矩形、点与点 API)
     直接坐标系，左上角为(0,0) 坐标系跟视图坐标系一样
     */
    BMKMapPoint start = BMKMapPointForCoordinate(pointStart);
    BMKMapPoint end = BMKMapPointForCoordinate(pointEnd);
    
    //计算夹角的角度 360度分四种情况
    if (end.x == start.x) {
        if (end.y > start.y) {
            angle = 0.;
        }else{
            angle = M_PI;
        }
    }else if (end.x > start.x){
        if (end.y > start.y) {
            //右下
            angle = atan2((end.y - start.y), (end.x - start.x));
            angle = angle + M_PI_2;
        }else{
            //右上
            angle = atan2((start.y - end.y), (end.x - start.x));
            angle = M_PI_2 - angle;
        }
    }else if (end.x < start.x){
        if (end.y > start.y) {
            //左下
            angle = atan2((end.y - start.y), (start.x - end.x));
            angle = -(M_PI_2 + angle);
        }else{
            //左上
            angle = atan2((start.y - end.y), (start.x - end.x));
            angle = -(M_PI_2 - angle);
        }
    }
    
    return angle;
}


@end




#pragma mark - 位置信息model

@implementation LocaleInfoModel



@end







