//
//  FRMapViewOfflineMapVC.m
//  FlashRider
//
//  Created by gaoyafeng on 2019/5/7.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "FRMapViewOfflineMapVC.h"

#import "GFSegmentedControl.h"

@interface FRMapViewOfflineMapVC ()<FSSegmentControlDelegate>

///按钮切换
@property (nonatomic,strong,nullable) GFSegmentedControl *btnSegmentControl;

///scrollview
@property (nonatomic,strong,nullable) UIScrollView *backScrollView;

///城市列表tableView
@property (nonatomic,strong,nullable) MapOfflineCityListView *leftListView;

///下载管理城市列表
@property (nonatomic,strong,nullable) MapOfflineDownManagerView *rightListView;

@end

@implementation FRMapViewOfflineMapVC


- (void)dealloc{
    NSLog(@"视图释放了");
}

#pragma mark - 页面初始化 && 基本页面设置
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建其他视图
    [self createView];
    
}

//初始化界面基础数据
- (void)initData {
    
    
}


///设置导航栏样式
- (void)setNaviBarStyle{
    
}

#pragma mark - Network Request  网络请求
- (void)requestNetData{
    
}


///请求成功数据处理  (这个方法要重写！！！)
- (void)requestNetDataSuccess:(id)dicData{
    
}

///请求数据失败处理
- (void)requestNetDataFail{
    
    
}





#pragma mark - 按钮点击事件

#pragma mark - 网络状态发生变化触发事件
- (void)reachabilityNetStateChanged:(NSNotification *)noti{
    
    /**
     StatusUnknown           = -1, //未知网络
     StatusNotReachable      = 0,    //没有网络
     StatusReachableViaWWAN  = 1,    //手机自带网络
     StatusReachableViaWiFi  = 2     //wifi
     */
    
    switch ([APPHttpTool sharedNetworking].networkStats) {
        case StatusUnknown:
            [self showMessage:@"未知网络"];
            break;
        case StatusNotReachable:
            [self showMessage:@"网络连接断开,已暂停地图下载"];
            //暂停所有下载
            [_rightListView suspendedAllDown];
            break;
        case StatusReachableViaWWAN:
            //[self showMessage:@"您正在使用2G/3G/4G网络"];
            break;
        case StatusReachableViaWiFi:
            //[self showMessage:@"您正在使用WiFi网络"];
            break;
            
        default:
            break;
    }
}

#pragma mark - 点击城市列表逻辑处理
- (void)segmentControlDidChangeValue:(NSInteger)index{
    
    switch (index) {
        case 0:
            _backScrollView.contentOffset = CGPointMake(0, 0);
            break;
        case 1:
            _backScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
            break;
        default:
            break;
    }
}

///点击下载
- (void)cityListCellActionDown:(MapOfflineCellModel *)cellModel{
    
    if ([APPHttpTool sharedNetworking].networkStats == StatusNotReachable || [APPHttpTool sharedNetworking].networkStats == StatusUnknown) {
        [self showMessage:@"暂无网络连接,请检查网络"];
    }else if ([APPHttpTool sharedNetworking].networkStats == StatusReachableViaWWAN){
        APPWeakSelf;
        [self showAlertCustomTitle:@"提示" message:@"您当前处于非WiFi网络，是否仍要下载？" okBlock:^(BOOL result, id idObject) {
            [weakSelf startDownOfflineMapWithModel:cellModel];
        }];
    }else{
        //WiFi网络
        [self startDownOfflineMapWithModel:cellModel];
    }
    
}

///开始下载
- (void)startDownOfflineMapWithModel:(MapOfflineCellModel *)cellModel{
    
    //未下载 || 已暂停 || 更新
    if (cellModel.downState == -1) {
        [MapOfflineCellModel addOneOfflineDownInfoWithInfoDic:(NSDictionary *)[cellModel yy_modelToJSONObject]];//添加下载信息
    }
    
    if (cellModel.downState == 5) {
        //更新
        [[FSBaiDuMapManager shareInstance] offlineMapHandleWithType:MapOfflineType_updateDownload bmkCityId:cellModel.cityID];
        
        //更新下载中 && 已下载
        [_rightListView refreshDowningData:YES];
    }else{
        [[FSBaiDuMapManager shareInstance] offlineMapHandleWithType:MapOfflineType_startDownload bmkCityId:cellModel.cityID];//开始下载
        //只更新 下载中数据
        [_rightListView refreshDowningData:NO];//下载管理刷新正在下载数据更新cell
    }
}

///正在下载过程吐字提示
- (void)showDownStateWithState:(NSInteger)state{
    
    switch (state) {
        case 1:
            //正在下载
            [self showMessage:@"该城市正在下载"];
            break;
        case 2:
            //等待下载
            [self showMessage:@"该城市正在等待下载"];
            break;
        case 3:
            //已暂停
            [self showMessage:@"该城市已暂停下载"];
            break;
        case 4:
            //完成
            [self showMessage:@"该城市已下载"];
            break;
            
        default:
            [self showMessage:@"该城市已暂停下载"];
            break;
    }
}

#pragma mark - 点击下载管理cell逻辑处理
///点击正在下载
- (void)actionDowningCellWithModel:(MapOfflineCellModel *)cellModel{
    
    APPWeakSelf;
    if (cellModel.downState == 3) {
        //暂停 ——> 下载
        [self showAlertListWithTitle:nil message:nil listTitleArray:@[@"开始下载",@"删除"] blockResult:^(BOOL result, id idObject) {
            switch ([(NSNumber *)idObject intValue]) {
                case 0:
                    //开始下载
                    [weakSelf cityListCellActionDown:cellModel];
                    break;
                case 1:
                    //删除
                    [weakSelf deleteOneOfflineInfoWithCityId:cellModel.cityID];
                    [weakSelf.rightListView deleteOneModelFromDowningDataWithCityId:cellModel.cityID];
                    break;
                    
                default:
                    break;
            }
        }];
    }else{
        //下载 ——> 暂停
        [self showAlertListWithTitle:nil message:nil listTitleArray:@[@"暂停下载",@"删除"] blockResult:^(BOOL result, id idObject) {
            switch ([(NSNumber *)idObject intValue]) {
                case 0:
                    //暂停下载
                    [[FSBaiDuMapManager shareInstance] offlineMapHandleWithType:MapOfflineType_pauseDownload bmkCityId:cellModel.cityID];
                    break;
                case 1:
                    //删除
                    [weakSelf deleteOneOfflineInfoWithCityId:cellModel.cityID];
                    [weakSelf.rightListView deleteOneModelFromDowningDataWithCityId:cellModel.cityID];
                    
                    break;
                    
                default:
                    break;
            }
        }];
    }
    
}

///点击已下载
- (void)actionDownedCellWithModel:(MapOfflineCellModel *)cellModel{
    
    APPWeakSelf;
    
    if (cellModel.downState == 5) {
        //有更新
        [self showAlertListWithTitle:nil message:nil listTitleArray:@[@"更新",@"删除"] blockResult:^(BOOL result, id idObject) {
            switch ([(NSNumber *)idObject intValue]) {
                case 0:
                    //更新 ——> 开始下载
                    [weakSelf cityListCellActionDown:cellModel];
                    break;
                case 1:
                    //删除
                    [weakSelf deleteOneOfflineInfoWithCityId:cellModel.cityID];
                    [weakSelf.rightListView deleteOneModelFromDownedDataWithCityId:cellModel.cityID];
                    break;
                    
                default:
                    break;
            }
        }];
    }else{
        //无更新
        [self showAlertListWithTitle:nil message:nil listTitleArray:@[@"删除"] blockResult:^(BOOL result, id idObject) {
            
            [weakSelf deleteOneOfflineInfoWithCityId:cellModel.cityID];
            [weakSelf.rightListView deleteOneModelFromDownedDataWithCityId:cellModel.cityID];
        }];
    }
    
}

///删除
- (void)deleteOneOfflineInfoWithCityId:(int)cityId{
    
    [[FSBaiDuMapManager shareInstance] offlineMapHandleWithType:MapOfflineType_remove bmkCityId:cityId];//删除离线地图包
    [MapOfflineCellModel removeOneOfflineDownInfoWithCityId:cityId];//删除本地存储信息
    
    [_leftListView refreshOneCellWithCityId:cityId];//刷新左边城市列表该城市为 未下载
}

#pragma mark - Init View  初始化一些视图之类的
- (void)createView{
    //防止UITableView被状态栏压下20
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //创建视图
    [self.naviBar addSubview:self.btnSegmentControl];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.leftListView];
    [self.backScrollView addSubview:self.rightListView];
    
    //约束
    self.btnSegmentControl.sd_layout.centerXEqualToView(self.naviBar).bottomSpaceToView(self.naviBar, 6).widthIs(83*2).heightIs(32);
    self.backScrollView.sd_layout.leftEqualToView(self.view).topSpaceToView(self.view, kTopNaviBarHeight).rightEqualToView(self.view).bottomEqualToView(self.view);
    self.leftListView.sd_layout.leftEqualToView(self.backScrollView).topEqualToView(self.backScrollView).bottomEqualToView(self.backScrollView).widthIs(kScreenWidth);
    //self.rightListView.sd_layout.leftSpaceToView(self.leftListView, 0).topEqualToView(self.backScrollView).rightEqualToView(self.backScrollView).bottomEqualToView(self.backScrollView);
    self.rightListView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kTopNaviBarHeight);
}


- (GFSegmentedControl *)btnSegmentControl{
    if (!_btnSegmentControl) {
        _btnSegmentControl = [[GFSegmentedControl alloc] initWithItems:@[@"城市列表",@"下载管理"]];
        _btnSegmentControl.delegate = self;
        [_btnSegmentControl setTitleTextAttributes:@{NSFontAttributeName:kFontOfSystem(14),NSForegroundColorAttributeName:APPColor_Gray} forState:UIControlStateNormal];
        [_btnSegmentControl setTitleTextAttributes:@{NSFontAttributeName:kFontOfSystem(14),NSForegroundColorAttributeName:APPColor_White} forState:UIControlStateSelected];
        _btnSegmentControl.tintColor = RGBX(0x20A8FF);
        _btnSegmentControl.backgroundColor = RGBX(0xF6F5F8);
        _btnSegmentControl.layer.cornerRadius = 2;
        _btnSegmentControl.layer.masksToBounds = YES;
    }
    
    return _btnSegmentControl;
}

- (UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] init];
        _backScrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kTopNaviBarHeight);
        _backScrollView.bounces = NO;
        _backScrollView.scrollEnabled = NO;
    }
    
    return _backScrollView;
}

- (MapOfflineCityListView *)leftListView{
    if (!_leftListView) {
        //创建tableView
        _leftListView = [[MapOfflineCityListView alloc] init];
        APPWeakSelf;
        _leftListView.blockActionCell = ^(BOOL result, id idObject) {
            if (result) {
                //下载
                [weakSelf cityListCellActionDown:(MapOfflineCellModel *)idObject];
            }else{
                [weakSelf showDownStateWithState:[(NSNumber *)idObject integerValue]];
            }
        };
    }
    return _leftListView;
}


- (MapOfflineDownManagerView *)rightListView{
    
    if (!_rightListView) {
        //创建tableView
        _rightListView = [[MapOfflineDownManagerView alloc] init];
        APPWeakSelf;
        _rightListView.blockActionCell = ^(BOOL result, id idObject) {
            if (result) {
                //正在下载
                [weakSelf actionDowningCellWithModel:(MapOfflineCellModel *)idObject];
            }else{
                //已下载
                [weakSelf actionDownedCellWithModel:(MapOfflineCellModel *)idObject];
            }
        };
    }
    return _rightListView;
}


@end


#pragma mark - ********************** 城市列表 **********************

@implementation MapOfflineCityListView
{
    MapOfflineCellModel *_locationModel;//定位model
    
    NSArray *_arrayProvinceCityList;//省中的城市
    NSMutableArray *_arrayIndexNewAdd;//添加cell的位置数组
    NSIndexPath *_indexPathAction;//点击的cell的位置
}

- (instancetype)init{
    if (self = [super init]) {
        
        [self createView];
    }
    
    return self;
}


- (void)createView{
    
    //获取数据
    NSArray *localArray = [[FSBaiDuMapManager shareInstance] getOfflineMapInfoWithCityName:APPManagerObject.localCityName];
    if (localArray.count) {
        BMKOLSearchRecord *localCityInfo = localArray[0];//定位城市
        _locationModel = [MapOfflineCellModel getOneOfflineCellModelWithCityModel:localCityInfo];
        _locationModel.cellType = 2;
    }
    //热门城市
    _arrayHotCitys = [MapOfflineCellModel getHotCityCellModelArrayData];
    //所有城市
    _arrayAllCitys = [MapOfflineCellModel getAllCityCellModelArrayData];
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopNaviBarHeight, kScreenWidth, kScreenHeight - kTopNaviBarHeight) style:UITableViewStylePlain];
    //背景颜色
    _tableView.backgroundColor = APPColor_Gray_tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[MapOfflineCell class] forCellReuseIdentifier:@"MapOfflineCell"];
    
    [self addSubview:_tableView];
    _tableView.sd_layout.leftEqualToView(self).topEqualToView(self).rightEqualToView(self).bottomEqualToView(self);
}

///刷新某个城市变为下载状态
- (void)refreshOneCellWithCityId:(int)cityId{
    
    if (_locationModel.cityID == cityId) {
        _locationModel.downState = -1;//未下载
    }
    for (MapOfflineCellModel *model in _arrayHotCitys) {
        if (model.cityID == cityId) {
            model.downState = -1;
        }
    }
    for (MapOfflineCellModel *model in _arrayAllCitys) {
        if (model.cityID == cityId) {
            model.downState = -1;
        }
    }
    for (MapOfflineCellModel *model in _arrayProvinceCityList) {
        if (model.cityID == cityId) {
            model.downState = -1;
        }
    }
    [_tableView reloadData];
}

#pragma mark - UITableView&&代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;//定位城市
            break;
        case 1:
            return _arrayHotCitys.count;
            break;
        case 2:
            if (_arrayProvinceCityList.count) {
                return _arrayAllCitys.count + _arrayProvinceCityList.count;
            }else{
                return _arrayAllCitys.count;
            }
            break;
            
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MapOfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapOfflineCell" forIndexPath:indexPath];
    
    cell.lineH.hidden = NO;
    cell.contentView.backgroundColor = APPColor_White;
    switch (indexPath.section) {
        case 0:
            //定位城市
            if (_locationModel) {
                [cell setCellModel:_locationModel];
            }else{
                //定位失败
                cell.labelLeft.text = @"定位失败";
                cell.imgJT.hidden = YES;
                cell.labelRight.hidden = YES;
            }
            
            cell.lineH.hidden = YES;
            break;
        case 1:
            //热门城市
            [cell setCellModel:_arrayHotCitys[indexPath.row]];
            if (indexPath.row == _arrayHotCitys.count - 1) {
                cell.lineH.hidden = YES;
            }
            break;
        case 2:
            //全国城市
            if (_arrayProvinceCityList.count) {
                //点击了省
                if (indexPath.row > _indexPathAction.row && indexPath.row <= _indexPathAction.row + _arrayProvinceCityList.count) {
                    //插入的 市列表 中间部分
                    [cell setCellModel:_arrayProvinceCityList[indexPath.row - _indexPathAction.row - 1]];
                    cell.contentView.backgroundColor = APPColor_Gray_tableView;
                }else{
                    if (indexPath.row <= _indexPathAction.row) {
                        [cell setCellModel:_arrayAllCitys[indexPath.row]];
                    }else{
                        [cell setCellModel:_arrayAllCitys[indexPath.row - _arrayProvinceCityList.count]];
                    }
                }
            }else{
                [cell setCellModel:_arrayAllCitys[indexPath.row]];
                if (indexPath.row == _arrayAllCitys.count - 1) {
                    cell.lineH.hidden = YES;
                }
            }
            
            break;
            
        default:
            break;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = APPColor_Gray_tableView;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = APPColor_Gray;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentLeft;
    switch (section) {
        case 0:
            label.text = @"当前定位城市";
            break;
        case 1:
            label.text = @"热门城市";
            break;
        case 2:
            label.text = @"全部地区";
            break;
            
        default:
            break;
    }
    
    [backView addSubview:label];
    label.sd_layout.leftSpaceToView(backView, 20).centerYEqualToView(backView).rightSpaceToView(backView, 20).heightIs(18);
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            //定位城市
            [self startDownOfflineMapWithModel:_locationModel];
            break;
        case 1:
            //热门城市
        {
            MapOfflineCellModel *hotModel = _arrayHotCitys[indexPath.row];
            [self startDownOfflineMapWithModel:hotModel];
        }
            break;
        case 2:
            //省市
        {
            MapOfflineCell *currentCell = (MapOfflineCell *)[_tableView cellForRowAtIndexPath:indexPath];
            MapOfflineCellModel *cityModel = currentCell.cellModel;
            if (cityModel.cellType == 1) {
                //省 ——> 展开城市列表
                [self actionProvinceCellHandleIndexPath:indexPath cityModel:cityModel];
                
            }else{
                //市
                [self startDownOfflineMapWithModel:cityModel];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 业务逻辑处理
- (void)startDownOfflineMapWithModel:(MapOfflineCellModel *)model{
    //未下载 || 暂停 || 有更新
    if (model.downState == -1 || model.downState == 3 || model.downState == 5) {
        
        if (self.blockActionCell) {
            self.blockActionCell(YES, model);//下载
        }
    }else{
        //吐字提示
        if (self.blockActionCell) {
            self.blockActionCell(NO, [NSNumber numberWithInteger:model.downState]);
        }
    }
}

///选择省份处理
- (void)actionProvinceCellHandleIndexPath:(NSIndexPath *)indexPath cityModel:(MapOfflineCellModel *)cityModel{
    
    //由于可能点击过——>省市下面的省点击位置会靠下，不是正常位置
    NSIndexPath *provinceIndexPath;
    if (indexPath.row > _indexPathAction.row && _indexPathAction) {
        //点击过 && 在上次位置下面 ——>换算成 去掉市列表 后的位置
        provinceIndexPath = [NSIndexPath indexPathForRow:(indexPath.row - _arrayIndexNewAdd.count) inSection:indexPath.section];
    }else{
        //点击位置在 上次的上面 || 没有点击过
        provinceIndexPath = indexPath;
    }
    
    //判断点击的省 是否为同一个
    //删除旧的省 ——> 市
    if (_arrayProvinceCityList.count) {
        _arrayProvinceCityList = nil;//先处理数组数据——>再处理cell
        [_tableView deleteRowsAtIndexPaths:_arrayIndexNewAdd withRowAnimation:UITableViewRowAnimationFade];
        _arrayIndexNewAdd = nil;
    }
    
    if (provinceIndexPath.row == _indexPathAction.row && provinceIndexPath.section == _indexPathAction.section) {
        //点击同一个省 ——> 箭头朝下
        _indexPathAction = nil;
    }else{
        //点击不同的省 ——> 删除多余的cell ——> 箭头朝上 & 吸顶 & 添加cell
        _indexPathAction = provinceIndexPath;
        _arrayProvinceCityList = [MapOfflineCellModel getCityListFormProvinceModel:cityModel];
        
        //刷新列表 ——> 该组吸顶 && 添加新的cell
        [_tableView scrollToRowAtIndexPath:provinceIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        _arrayIndexNewAdd = [NSMutableArray array];
        for (NSInteger i = 1; i <= _arrayProvinceCityList.count ; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_indexPathAction.row + i inSection:_indexPathAction.section];
            [_arrayIndexNewAdd addObject:indexPath];
        }
        [_tableView insertRowsAtIndexPaths:_arrayIndexNewAdd withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end


#pragma mark - ********************** 下载管理 **********************
@implementation MapOfflineDownManagerView

- (instancetype)init{
    if (self = [super init]) {
        
        [self createView];
    }
    
    return self;
}


- (void)createView{
    
    //获取数据
    _arrayDowning = [MapOfflineCellModel getDowningCitysArrayData];//正在下载
    _arrayDowned = [MapOfflineCellModel getDownedCitysArrayData];//已下载
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopNaviBarHeight, kScreenWidth, kScreenHeight - kTopNaviBarHeight) style:UITableViewStylePlain];
    //背景颜色
    _tableView.backgroundColor = APPColor_Gray_tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[MapOfflineCell class] forCellReuseIdentifier:@"MapOfflineCell"];
    [self addSubview:_tableView];
    _tableView.sd_layout.leftEqualToView(self).topEqualToView(self).rightEqualToView(self).bottomEqualToView(self);
}

///刷新数据
- (void)refreshDowningData:(BOOL)isAll{
    
    _arrayDowning = [MapOfflineCellModel getDowningCitysArrayData];//正在下载
    if (isAll) {
        _arrayDowned = [MapOfflineCellModel getDownedCitysArrayData];//已下载
    }
    
    [_tableView reloadData];//刷新数据
}

///暂停所有下载
- (void)suspendedAllDown{
    
    for (MapOfflineCellModel *model in _arrayDowning) {
        
        [[FSBaiDuMapManager shareInstance] offlineMapHandleWithType:MapOfflineType_pauseDownload bmkCityId:model.cityID];
    }
}

///删除一个下载中数据
- (void)deleteOneModelFromDowningDataWithCityId:(int)cityId{
    
    for (MapOfflineCellModel *model in _arrayDowning) {
        
        if (model.cityID == cityId) {
            
            [_arrayDowning removeObject:model];
            
            [_tableView reloadData];
            break;
        }
    }
    
}

///删除一个已下载数据
- (void)deleteOneModelFromDownedDataWithCityId:(int)cityId{
    
    for (MapOfflineCellModel *model in _arrayDowned) {
        
        if (model.cityID == cityId) {
            
            [_arrayDowned removeObject:model];
            [_tableView reloadData];
            
            break;
        }
    }
    
}

#pragma mark - UITableView&&代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_arrayDowning.count) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            if (_arrayDowning.count) {
                return _arrayDowning.count;
            }else{
                return _arrayDowned.count;
            }
            break;
        case 1:
            return _arrayDowned.count;
            break;
            
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MapOfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapOfflineCell" forIndexPath:indexPath];
    
    cell.lineH.hidden = NO;
    
    switch (indexPath.section) {
        case 0:
            if (_arrayDowning.count) {
                //正在下载
                [cell setCellModel:_arrayDowning[indexPath.row]];
                if (indexPath.row == _arrayDowning.count - 1) {
                    cell.lineH.hidden = YES;
                }
                cell.cellRow = indexPath.row;
                APPWeakSelf;
                cell.blockDownComplete = ^(BOOL result, id idObject) {
                    NSInteger indexCell = [(NSNumber *)idObject integerValue];
                    [weakSelf downCompleteHandleWithCellIndex:indexCell];
                };
            }else{
                //已下载
                [cell setCellModel:_arrayDowned[indexPath.row]];
                if (indexPath.row == _arrayDowned.count - 1) {
                    cell.lineH.hidden = YES;
                }
            }
            
            break;
        case 1:
            //已下载
            [cell setCellModel:_arrayDowned[indexPath.row]];
            if (indexPath.row == _arrayDowned.count - 1) {
                cell.lineH.hidden = YES;
            }
            break;
            
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = APPColor_Gray_tableView;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = APPColor_Gray;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentLeft;
    switch (section) {
        case 0:
            if (_arrayDowning.count) {
                label.text = @"正在下载";
            }else{
                label.text = @"已下载";
            }
            break;
        case 1:
            label.text = @"已下载";
            break;
            
        default:
            break;
    }
    
    [backView addSubview:label];
    label.sd_layout.leftSpaceToView(backView, 20).centerYEqualToView(backView).rightSpaceToView(backView, 20).heightIs(18);
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击处理
    MapOfflineCellModel *cellModel;
    if (_arrayDowning.count) {
        switch (indexPath.section) {
            case 0:
                //正在下载
                cellModel = _arrayDowning[indexPath.row];
                if (self.blockActionCell) {
                    self.blockActionCell(YES, cellModel);
                }
                break;
            case 1:
                //下载完
                cellModel = _arrayDowned[indexPath.row];
                if (self.blockActionCell) {
                    self.blockActionCell(NO, cellModel);
                }
                break;
                
            default:
                break;
        }
    }else{
        //下载完
        cellModel = _arrayDowned[indexPath.row];
        if (self.blockActionCell) {
            self.blockActionCell(NO, cellModel);
        }
    }
}

#pragma mark - 业务逻辑处理
///下载完回调
- (void)downCompleteHandleWithCellIndex:(NSInteger)indexCell{
    
    if (indexCell < _arrayDowning.count && indexCell >= 0) {
        
        [_arrayDowning removeObjectAtIndex:indexCell];//删除数据
        
        _arrayDowned = [MapOfflineCellModel getDownedCitysArrayData];//从新获取 已下载 数据

        [_tableView reloadData];//刷新列表
    }
}

@end

#pragma mark - ************************ 离线地图cell ************************
@implementation MapOfflineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
    }
    
    return self;
}

- (void)dealloc{
    
    [APPNotificationCenter removeObserver:self];//移除观察者
}

- (void)createView{
    
    _labelLeft = [[UILabel alloc] init];
    _labelLeft.text = @"北京市(20.2M)";
    _labelLeft.font = [UIFont systemFontOfSize:14];
    _labelLeft.textColor = APPColor_BlackDeep;
    _labelLeft.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_labelLeft];
    
    _labelRight = [[UILabel alloc] init];
    _labelRight.text = @"下载";
    _labelRight.font = [UIFont systemFontOfSize:14];
    _labelRight.textColor = APPColor_Blue;
    _labelRight.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_labelRight];
    
    _imgJT = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_jt"]];
    _imgJT.hidden = YES;
    [self.contentView addSubview:_imgJT];
    
    _lineH = [[UIView alloc] init];
    _lineH.backgroundColor = APPColor_lightGray;
    [self.contentView addSubview:_lineH];
    
    //约束
    _labelRight.sd_layout.rightSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).widthIs(kScreenWidth / 3.).heightIs(20);
    _labelLeft.sd_layout.leftSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).rightSpaceToView(_labelRight, 20).heightIs(20);
    _imgJT.sd_layout.rightSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).widthIs(10).heightIs(7);
    _lineH.sd_layout.leftSpaceToView(self.contentView, 20).bottomEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(1);
    
    [APPNotificationCenter addObserver:self selector:@selector(notificationDownOfflineMap:) name:kBMKOfflineDownloadNotification object:nil];
}

///离线地图下载
- (void)notificationDownOfflineMap:(NSNotification *)noti{
    
    NSDictionary *downInfo = (NSDictionary *)noti.userInfo;//下载信息
    
    int cityIdNoti = [downInfo[@"cityID"] intValue];
    
    //通知的城市ID && 下载状态已完成不接受通知
    if (_cellModel.cityID == cityIdNoti && _cellModel.downState != 4) {
        
        [self refreshCellDownState];//更新下载状态
    }
    
    /**
    NSDictionary *downInfo = (NSDictionary *)noti.object;//下载信息
    
    BMKOLUpdateElement *downModel = [BMKOLUpdateElement yy_modelWithJSON:downInfo];
    
    if (downModel) {
        
        switch (downModel.status) {
            case 1:
                //正在下载
                _labelRight.text = [NSString stringWithFormat:@"正在下载 %d",downModel.ratio];
                _labelRight.textColor = APPColor_Blue;
                break;
            case 2:
                //等待下载
                _labelRight.text = [NSString stringWithFormat:@"等待下载 %d",downModel.ratio];
                _labelRight.textColor = APPColor_Blue;
                break;
            case 3:
                //已暂停
                _labelRight.text = [NSString stringWithFormat:@"已暂停 %d",downModel.ratio];
                _labelRight.textColor = APPColor_red;
                break;
            case 4:
                //完成
                if (downModel.update) {
                    //有更新
                    _labelRight.text = [NSString stringWithFormat:@"有更新 %@",[[FSBaiDuMapManager shareInstance] getDataSizeString:downModel.serversize]];
                    _labelRight.textColor = APPColor_Blue;
                }else{
                    _labelRight.text = @"已下载";
                    _labelRight.textColor = APPColor_Gray;
                }
                break;
                
            default:
            break;
                
        }
    }
     */
}

///赋值cellmodel
- (void)setCellModel:(MapOfflineCellModel *)model{
    
    _cellModel = model;
    
    switch (model.cellType) {
        case 0:
            //全国
            break;
        case 1:
            //省
            _labelLeft.text = model.cityName;
            _imgJT.hidden = NO;
            _labelRight.hidden = YES;
            break;
        case 2:
            //市
            _labelLeft.text = [NSString stringWithFormat:@"%@(%@)",model.cityName,[[FSBaiDuMapManager shareInstance] getDataSizeString:model.size]];
            _imgJT.hidden = YES;
            _labelRight.hidden = NO;
            break;
            
        default:
            break;
    }
    
    //判断下载状态
    if (model.downState == -1) {
        //未下载
        _labelRight.text = @"下载";
        _labelRight.textColor = APPColor_Blue;
    }else{
        
        [self refreshCellDownState];
    }
    
}

///刷新cell 下载状态
- (void)refreshCellDownState{
    
    BMKOLUpdateElement *offlineInfo = [[FSBaiDuMapManager shareInstance] getOffLineMapInfoWithCityId:_cellModel.cityID];
    //-1:未定义 1:正在下载　2:等待下载　3:已暂停　4:完成 5:校验失败 6:网络异常 7:读写异常 8:Wifi网络异常 9:离线包数据格式异常，需重新下载离线包 10:离线包导入中
    _cellModel.status = offlineInfo.status;//及时更新状态
    _cellModel.downState = offlineInfo.status;
    switch (offlineInfo.status) {
        case -1:
            //未下载
            //_labelRight.text = @"下载";
            //_labelRight.textColor = APPColor_Blue;
            
            break;
        case 1:
            //正在下载
            _labelRight.text = [NSString stringWithFormat:@"正在下载 %d%%",offlineInfo.ratio];
            _labelRight.textColor = APPColor_Blue;
            break;
        case 2:
            //等待下载
            _labelRight.text = [NSString stringWithFormat:@"等待下载 %d%%",offlineInfo.ratio];
            _labelRight.textColor = APPColor_Blue;
            break;
        case 3:
            //已暂停
            _labelRight.text = [NSString stringWithFormat:@"已暂停 %d%%",offlineInfo.ratio];
            _labelRight.textColor = APPColor_red;
            break;
        case 4:
            //完成
            if (offlineInfo.update) {
                //有更新
                _labelRight.text = [NSString stringWithFormat:@"有更新 %@",[[FSBaiDuMapManager shareInstance] getDataSizeString:offlineInfo.serversize]];
                _labelRight.textColor = APPColor_Blue;
                
                _cellModel.downState = 5;//有更新
            }else{
                _labelRight.text = @"已下载";
                _labelRight.textColor = APPColor_Gray;
            }
            //删除已下载中cell ——> 已下载
            if (self.blockDownComplete) {
                self.blockDownComplete(YES, [NSNumber numberWithInteger:_cellRow]);
            }
            break;
        case 10:
            //下载离线包导入中
            _labelRight.text = @"已下载";
            _labelRight.textColor = APPColor_Gray;
            
            _cellModel.downState = 4;//10当做4完成处理
            
            //删除已下载中cell ——> 已下载
            if (self.blockDownComplete) {
                self.blockDownComplete(YES, [NSNumber numberWithInteger:_cellRow]);
            }
            break;
            
        default:
            _cellModel.downState = 3;//暂停下载 status:5/6/7/8/9 当做3暂停处理
            //有下载但没有完成 ——> 以暂停处理
            _labelRight.text = [NSString stringWithFormat:@"已暂停 %d%%",offlineInfo.ratio];
            _labelRight.textColor = APPColor_red;
            
            break;
    }
    
}






@end


#pragma mark - ************************ 城市列表model ************************

NSString * const kMapOfflineDownLocalInfo = @"kMapOfflineDownLocalInfo";

@implementation MapOfflineCellModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"childCities" : [BMKOLSearchRecord class]//这里存放这个类
             };
}

///获取本地离线地图下载信息
+ (NSMutableArray *)getLocalMapOfflineDownInfo{
    
    NSArray *localInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kMapOfflineDownLocalInfo];
    
    if (localInfo && [localInfo isKindOfClass:[NSArray class]]) {
        
        return [localInfo mutableCopy];
    }else{
        localInfo = [NSMutableArray array];
        
        return [localInfo mutableCopy];
    }
}

///存储本地离线地图下载信息
+ (void)updateLocalMapOfflineDownInfoWithDic:(NSArray *)arrayInfo{
    
    [[NSUserDefaults standardUserDefaults] setObject:arrayInfo forKey:kMapOfflineDownLocalInfo];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///添加一个下载信息
+ (void)addOneOfflineDownInfoWithInfoDic:(NSDictionary *)downDic{
    
    NSMutableArray *arrayLocalInfo = [self getLocalMapOfflineDownInfo];
    
    if (downDic) {
        [arrayLocalInfo insertObject:downDic atIndex:0];
    }
    
    [self updateLocalMapOfflineDownInfoWithDic:[arrayLocalInfo copy]];
}

///删除一个下载信息
+ (void)removeOneOfflineDownInfoWithCityId:(int)cityId{
    
    NSMutableArray *arrayLocalInfo = [self getLocalMapOfflineDownInfo];
    
    for (NSDictionary *dicInfo in arrayLocalInfo) {
        if ([dicInfo[@"cityID"] intValue] == cityId) {
            [arrayLocalInfo removeObject:dicInfo];
            break;
        }
    }
    
    [self updateLocalMapOfflineDownInfoWithDic:[arrayLocalInfo copy]];
}

///查询是否有下载
+ (BOOL)getOneOfflineDownInfoWithCityId:(int)cityId{
    
    NSMutableArray *arrayLocalInfo = [self getLocalMapOfflineDownInfo];
    
    NSDictionary *dicInfo;
    
    for (NSDictionary *dic in arrayLocalInfo) {
        if ([dic[@"cityID"] intValue] == cityId) {
            dicInfo = dic;
            
            break;
        }
    }
    
    if (dicInfo && [dicInfo isKindOfClass:[NSDictionary class]]) {
        
        return YES;
    }else{
        return NO;
    }
}

///获取一个cellModel
+ (MapOfflineCellModel *)getOneOfflineCellModelWithCityModel:(BMKOLSearchRecord *)cityModel{
    
    MapOfflineCellModel *cellModel = [MapOfflineCellModel yy_modelWithJSON:[cityModel yy_modelToJSONObject]];

    if ([MapOfflineCellModel getOneOfflineDownInfoWithCityId:cellModel.cityID]) {
        cellModel.downState = 0;
    }else{
        cellModel.downState = -1;
    }
    
    return cellModel;
}

///获取热门城市model数组
+ (NSArray *)getHotCityCellModelArrayData{
    
    NSArray *hotCityArray = [[FSBaiDuMapManager shareInstance] getHotOfflineCityList];
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    for (BMKOLSearchRecord *cityInfo in hotCityArray) {
        
        MapOfflineCellModel *cellModel = [self getOneOfflineCellModelWithCityModel:cityInfo];
        cellModel.cellType = 2;
        
        if (cellModel) {
            [arrayData addObject:cellModel];
        }
    }
    
    return [arrayData copy];
}

///获取所有省市
+ (NSMutableArray *)getAllCityCellModelArrayData{
    
    NSArray *allCityArray = [[FSBaiDuMapManager shareInstance] getAllOfflineCityList];
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    for (BMKOLSearchRecord *cityInfo in allCityArray) {
        //过滤全国地图
        if (cityInfo.cityType != 0) {
            
            MapOfflineCellModel *cellModel = [self getOneOfflineCellModelWithCityModel:cityInfo];
            cellModel.cellType = cityInfo.cityType;
            
            if (cellModel) {
                [arrayData addObject:cellModel];
            }
        }
    }
    
    return arrayData;
}

///获取正在下载的城市
+ (NSMutableArray *)getDowningCitysArrayData{
    
    NSMutableArray *arrayLocalInfo = [self getLocalMapOfflineDownInfo];
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    for (NSDictionary *cityInfo in arrayLocalInfo) {
        
        BMKOLUpdateElement *offlineInfo = [[FSBaiDuMapManager shareInstance] getOffLineMapInfoWithCityId:[cityInfo[@"cityID"] intValue]];
        
        if (offlineInfo.status != 4) {
            //未完成
            MapOfflineCellModel *model = [MapOfflineCellModel yy_modelWithJSON:[offlineInfo yy_modelToJSONObject]];
            model.cityType = 2;
            model.cellType = 2;
            model.downState = offlineInfo.status;
            
            //获取城市离线包大小BMKOLSearchRecord  BMKOLUpdateElement中的size属性是已下载包大小
            NSArray *array = [[FSBaiDuMapManager shareInstance] getOfflineMapInfoWithCityName:offlineInfo.cityName];
            if (array.count) {
                BMKOLSearchRecord *cityRecord = array[0];
                model.size = cityRecord.size;
            }
            
            if (model) {
                [arrayData addObject:model];
            }
        }
    }
    
    return arrayData;
}

///获取已下载的城市
+ (NSMutableArray *)getDownedCitysArrayData{
    
    NSMutableArray *arrayLocalInfo = [self getLocalMapOfflineDownInfo];
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    for (NSDictionary *cityInfo in arrayLocalInfo) {
        
        BMKOLUpdateElement *offlineInfo = [[FSBaiDuMapManager shareInstance] getOffLineMapInfoWithCityId:[cityInfo[@"cityID"] intValue]];
        
        if (offlineInfo.status == 4 || offlineInfo.status == 10) {
            //已下载完成
            MapOfflineCellModel *model = [MapOfflineCellModel yy_modelWithJSON:[offlineInfo yy_modelToJSONObject]];
            model.cityType = 2;
            model.cellType = 2;
            model.downState = 4;//offlineInfo.status;
            
            //获取城市离线包大小BMKOLSearchRecord
            NSArray *array = [[FSBaiDuMapManager shareInstance] getOfflineMapInfoWithCityName:offlineInfo.cityName];
            if (array.count) {
                BMKOLSearchRecord *cityRecord = array[0];
                model.size = cityRecord.size;
            }
            
            if (model) {
                [arrayData addObject:model];
            }
        }
    }
    
    return arrayData;
}

///获取省中城市列表数组
+ (NSArray *)getCityListFormProvinceModel:(MapOfflineCellModel *)provinceModel{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (BMKOLSearchRecord *model in provinceModel.childCities) {
        
        if (model.cityType == 2) {
            //城市
            MapOfflineCellModel *cellModel = [self getOneOfflineCellModelWithCityModel:model];
            cellModel.cellType = 2;
            
            if (cellModel) {
                [array addObject:cellModel];
            }
        }
    }
    
    return [array copy];
}


@end
