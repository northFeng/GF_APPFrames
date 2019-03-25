//
//  FSCitySelectVC.m
//  FlashSend
//
//  Created by gaoyafeng on 2019/3/7.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "FSCitySelectVC.h"


@interface FSCitySelectVC ()<GFIndexViewDelegate>

///索引视图
@property (nonatomic,strong,nullable) GFIndexView *indexView;

///定位城市model信息
@property (nonatomic,strong,nullable) FSCityListModel *locationCityModel;

@end

@implementation FSCitySelectVC
{
    NSArray *_arrayByte;
}

#pragma mark - 页面初始化 && 基本页面设置
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建其他视图
    [self createView];
    
    //[self.tableView.mj_header beginRefreshing];
    [self requestNetData];
}

//初始化界面基础数据
- (void)initData {
    
    _locationCityModel = [[FSCityListModel alloc] init];
}



///设置导航栏样式
- (void)setNaviBarStyle{
    //设置状态栏样式
}

#pragma mark - Network Request  网络请求
- (void)requestNetData{
    NSLog(@"请求数据");
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
}


///请求成功数据处理  (这个方法要重写！！！)
- (void)requestNetDataSuccess:(id)dicData{
    
    if ([dicData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicJson = (NSDictionary *)dicData;
        
        if (kObjectEntity(dicJson)) {
            
            NSArray *keyArray = [dicJson allKeys];
            
            _arrayByte = [GFFunctionMethod array_alphabetizeWithArray:[keyArray mutableCopy]];
            
            //遍历所有的数据进行model转化
            for (NSString *key in _arrayByte) {
                
                NSArray *arrayJson = dicJson[key];
                
                NSMutableArray *arrayModel = [NSMutableArray array];
                
                for (NSDictionary *dicModel in arrayJson) {
                    
                    FSCityListModel *model = [FSCityListModel yy_modelWithDictionary:dicModel];
                    
                    [arrayModel gf_addObject:model];
                }
                
                [self.arrayDataList gf_addObject:arrayModel];
            }
            
            [self.tableView reloadData];
            
            //创建索引视图
            [self createIndexView];
        }else{
            [self showMessage:@"获取城市信息失败,请再次刷新"];
        }
    }else{
        
        [self showMessage:@"获取城市信息失败,请再次刷新"];
    }
}


///请求数据失败处理
- (void)requestNetDataFail{
    
    
}

#pragma mark - UITableView&&代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrayByte.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *array = [self.arrayDataList gf_getItemWithIndex:section];
    
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CityInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityInfoCell" forIndexPath:indexPath];
    
    NSMutableArray *arraySection = [self.arrayDataList gf_getItemWithIndex:indexPath.section];
    
    FSCityListModel *model = [arraySection gf_getItemWithIndex:indexPath.row];
    
    cell.labelTitle.text = model.name;
    
    if (indexPath.section == _arrayByte.count - 1 && indexPath.row == arraySection.count - 1) {
        
        [GFFunctionMethod view_addRoundedCornersOnView:cell.backView viewFrame:CGRectMake(0, 0, kScreenWidth - 20, 45) cornersPosition:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornersWidth:5];
    }else{
        cell.backView.layer.mask = nil;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (_arrayByte.count) {
        if (section == _arrayByte.count - 1) {
            if (kStatusBarHeight > 20) {
                return kTabBarBottomHeight;
            }else{
                return 0.1;
            }
        }else{
            return 0.1;
        }
    }else{
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (_arrayByte.count) {
        if (section == _arrayByte.count - 1) {
            UIView *backView = [[UIView alloc] init];
            
            return backView;
        }else{
            
            return nil;
        }
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor grayColor];
    
    UILabel *labelTitle = [GFFunctionMethod view_createLabelWith:[_arrayByte gf_getItemWithIndex:section] textFont:kFontOfSystem(16) textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [backView addSubview:labelTitle];
    labelTitle.sd_layout.leftSpaceToView(backView, 14).centerYEqualToView(backView).widthIs(100).heightIs(22);
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *arraySection = [self.arrayDataList gf_getItemWithIndex:indexPath.section];
    
    FSCityListModel *model = [arraySection gf_getItemWithIndex:indexPath.row];
    
    [self selectCityHandleWithModel:model];
}

/**
#pragma mark - tableView的索引代理
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    //自定义索引属性
    _tableView.sectionIndexColor = [UIColor blueColor];／／设置默认时索引值颜色
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor grayColor];／／设置选中时，索引背景颜色
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];／／ 设置默认时，索引的背景颜色
    
    return _arrayByte;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    
}
 */

#pragma mark - 自定义索引代理
- (void)scrollTableViewForSectionIndexTitle:(NSString *)title atIndex:(NSIndexPath *)indexPath{
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - 特殊设置
///滑动监测
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
}


#pragma mark - 按钮点击事件
///点击头部定位城市
- (void)onClickBtnHead{
    

    [self selectCityHandleWithModel:_locationCityModel];
}

#pragma mark - 逻辑处理
///选取城市进行操作处理
- (void)selectCityHandleWithModel:(FSCityListModel *)model{
    
    
}


#pragma mark - Init View  初始化一些视图之类的
- (void)createView{
    
    self.view.backgroundColor = [UIColor grayColor];
    
    //创建头部视图
    self.headView = [[UIView alloc] init];
    self.headView.backgroundColor = [UIColor whiteColor];
    [GFFunctionMethod view_addRoundedCornersOnView:self.headView viewFrame:CGRectMake(0, 0, kScreenWidth - 20, 45) cornersPosition:(UIRectCornerTopLeft | UIRectCornerTopRight) cornersWidth:5];
    [self.view addSubview:self.headView];
    
    self.headLabelTitle = [GFFunctionMethod view_createLabelWith:@"" textFont:kFontOfSystem(16) textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    self.headLabelTitle.userInteractionEnabled = YES;
    [self.headLabelTitle set_placeholderText:@"定位城市：%@" withText:@"北京" nodataStr:@"定位失败.."];
    [self.headView addSubview:self.headLabelTitle];
    
    UIButton *btnHead = [[UIButton alloc] init];
    [self btnAddEventControlWithBtn:btnHead action:@selector(onClickBtnHead)];
    [self.headLabelTitle addSubview:btnHead];
    
    self.headView.sd_layout.leftSpaceToView(self.view, 10).topSpaceToView(self.naviBar, 10).rightSpaceToView(self.view, 10).heightIs(45);
    self.headLabelTitle.sd_layout.leftSpaceToView(self.headView, 14).centerYEqualToView(self.headView).rightSpaceToView(self.headView, 14).heightIs(22);
    btnHead.sd_layout.leftEqualToView(self.headLabelTitle).topEqualToView(self.headLabelTitle).rightEqualToView(self.headLabelTitle).bottomEqualToView(self.headLabelTitle);
    
    //创建tableView
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kTopNaviBarHeight + 55, kScreenWidth - 20, kScreenHeight - (kTopNaviBarHeight + 55)) style:UITableViewStylePlain];
    //背景颜色
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //防止UITableView被状态栏压下20
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.tableView];
    
    self.tableView.sd_layout.leftSpaceToView(self.view, 10).topSpaceToView(self.view, kTopNaviBarHeight + 55).bottomEqualToView(self.view).rightSpaceToView(self.view, 10);
    
    //注册cell
    [self.tableView registerClass:[CityInfoCell class] forCellReuseIdentifier:@"CityInfoCell"];//非Xib
}


///创建索引视图
- (void)createIndexView{
    
    //创建索引视图
    [self.indexView setArrayData:_arrayByte];
    self.indexView.center = CGPointMake(kScreenWidth - 15, (kScreenHeight - kTopNaviBarHeight) / 2.);
    [self.view addSubview:self.indexView];
}

- (GFIndexView *)indexView{
    
    if (!_indexView) {
        
        _indexView = [[GFIndexView alloc] init];
        _indexView.delegate = self;
    }
    
    return _indexView;
}

@end

#pragma mark - ***************** 自定制城市信息cell *****************

@implementation CityInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self createView];
    }
    
    return self;
}


///创建视图
- (void)createView{
    
    self.contentView.backgroundColor = [UIColor grayColor];
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    
    _labelTitle = [GFFunctionMethod view_createLabelWith:@"北京市" textFont:kFontOfSystem(16) textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [_backView addSubview:_labelTitle];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [_backView addSubview:line];
    
    //约束
    _backView.sd_layout.leftSpaceToView(self.contentView, 0).topEqualToView(self.contentView).rightSpaceToView(self.contentView, 0).bottomEqualToView(self.contentView);
    _labelTitle.sd_layout.leftSpaceToView(_backView, 14).centerYEqualToView(_backView).rightSpaceToView(_backView, 35).heightIs(22);
    line.sd_layout.leftEqualToView(_backView).bottomEqualToView(_backView).rightEqualToView(_backView).heightIs(1);
    
}


@end


#pragma mark - ****************** 自定义索引视图 ************************

@interface GFIndexView ()

///第一个字母距离上边距
@property (nonatomic,assign) CGFloat upMargin;

///字母label宽度
@property (nonatomic,assign) CGFloat labelWidth;

///字母高度
@property (nonatomic,assign) CGFloat labelHeight;

///self的宽度
@property (nonatomic,assign) CGFloat selfWidth;

///字母字体
@property (nonatomic,strong,nullable) UIFont *labelFont;

///字母颜色
@property (nonatomic,strong,nullable) UIColor *labelColor;

///显示字母字体
@property (nonatomic,strong,nullable) UIFont *showLabelFont;

///显示字母X方向坐标
@property (nonatomic,assign) CGFloat showLabelX;

@end

@implementation GFIndexView
{
    UILabel *_labelShow;//显示字母
    
    NSArray <NSString *> *_arrayData;//数据源
    
    ///touches事件是否移动超出当前view
    BOOL _isMoveOutView;
    
    NSInteger _indexSelect;//已选择的位置
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if ([super init]) {
        
        [self initData];//初始化数据
        
        [self createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        [self initData];//初始化数据
        
        [self createView];
    }
    
    return self;
}

///初始哈数据
- (void)initData{
    
    _upMargin = 0.;
    
    _selfWidth = 30.;
    
    ///字母label宽度
    _labelWidth = 15.;
    
    ///字母高度
    _labelHeight = 20.;
    
    ///字母字体
    _labelFont = [UIFont systemFontOfSize:10];
    
    ///字母颜色
    _labelColor = [UIColor blackColor];
    
    ///显示字母字体
    _showLabelFont = kFontOfCustom(kMediumFont, 25);
    
    ///是否显示Label
    _isShowTipView = YES;
    
    _showLabelX = -50.;
    
    _indexSelect = -1;
    
}

//创建视图
- (void)createView{
    
    self.backgroundColor = [UIColor clearColor];
    
    _labelShow = [[UILabel alloc] init];
    _labelShow.backgroundColor = [UIColor clearColor];
    _labelShow.font = _showLabelFont;
    _labelShow.textColor = _labelColor;
    _labelShow.textAlignment = NSTextAlignmentCenter;
    _labelShow.hidden = YES;
    [self addSubview:_labelShow];
    
    _labelShow.frame = CGRectMake(_showLabelX, 0, 30, 30);
}

///设置数据源
- (void)setArrayData:(NSArray<NSString *> *)arrayData{
    
    _arrayData = arrayData;
    
    //创建视图
    CGFloat heightSelf = _upMargin;
    
    for (int i = 0; i < arrayData.count ; i++) {
        NSString *title = [arrayData gf_getItemWithIndex:i];
        
        UILabel *labelTitle = [[UILabel alloc] init];
        labelTitle.userInteractionEnabled = YES;
        labelTitle.tag = 1000 + i;
        labelTitle.font = _labelFont;
        labelTitle.textColor = _labelColor;
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.text = title;
        labelTitle.frame = CGRectMake(0, _upMargin + (_labelHeight * i), _labelWidth, _labelHeight);
        [self addSubview:labelTitle];
        
        heightSelf += _labelHeight;
    }
    
    self.frame = CGRectMake(0, 0, _selfWidth, heightSelf);
}

#pragma mark - 触摸时间处理
/* 事件处理 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];//触摸颜色
    
    
    //NSLog(@"touchesBegan...%@",NSStringFromClass([self class]));
    _isMoveOutView = NO;
    
    UITouch *touch=[touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    //NSLog(@"touchesBegan..location = %@",NSStringFromCGPoint(location));
    [self indexTouchedInView:location.y];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //self.backgroundColor = [UIColor clearColor];//离开时候清空背景颜色
    
    
    //NSLog(@"touchesEnded...%@",NSStringFromClass([self class]));
    
    UITouch *touch=[touches anyObject];
    CGPoint location = [touch locationInView:self];
    //NSLog(@"touchesEnded..location = %@",NSStringFromCGPoint(location));
    
    if(!_isMoveOutView){//点击事件有效
        [self indexTouchedInView:location.y];
    }else{//点击事件无效
        
    }
    _labelShow.hidden = YES;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesMoved...%@",NSStringFromClass([self class]));
    
    UITouch *touch=[touches anyObject];
    
    CGPoint location = [touch locationInView:self];
    //NSLog(@"touchesMoved..location = %@",NSStringFromCGPoint(location));
    
    if (![self pointInside:[touch locationInView:self] withEvent:nil]) {
        //NSLog(@"touches moved outside the view");
        _isMoveOutView = YES;
    }else{
        //触摸没有超出边界
        _isMoveOutView = NO;
        
        /**
        UIView *hitView=[self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
        
        if (hitView==self){
            //NSLog(@"touches moved in the view");
        }else
        {
            //NSLog(@"touches moved in the subview");
        }
         */
        
        [self indexTouchedInView:location.y];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

    //NSLog(@"touchesCancelled...%@",NSStringFromClass([self class]));
    _labelShow.hidden = YES;
    
}

- (NSInteger)indexTouchedInView:(CGFloat)locationY{
    
    NSInteger index = [self getCurrentLabelWithLoactionY:locationY];
    
    if(index < 0){
        return index;
    }
    
    if (_indexSelect != index) {
        //每次改变只 触发一次
        _indexSelect = index;
        
        NSString *title = _arrayData[index];
        
        if(self.isShowTipView){
            _labelShow.hidden = NO;
            
            //更改显示label的位置 && text
            UILabel *labelSelct = [self viewWithTag:1000 + index];
            if (labelSelct) {
                _labelShow.center = CGPointMake(_showLabelX, labelSelct.center.y);
                _labelShow.text = title;
            }
            
            [APPLoacalInfo feedbackGenerator];//发生一次触感
        }else{
            _labelShow.hidden = YES;
        }
        
        [self tableViewSectionIndexTitle:title atIndex:index];
    }
    
    return index;
}

// tableView滚动到对应组
- (void)tableViewSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    if(_arrayData.count <= 0){
        
        return;
    }
    
    //滚动tableView
    //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    if (self.delegate) {
        [self.delegate scrollTableViewForSectionIndexTitle:title atIndex:indexPath];
    }
}

- (NSInteger)getCurrentLabelWithLoactionY:(CGFloat)locationY{
    
    NSInteger index = (locationY - _upMargin)/(_labelHeight);
    
    //NSLog(@"getCurrentLabelWithLoactionY..index = %ld",index);
    if(index >= _arrayData.count){
        
        index = _arrayData.count - 1;
    }
    if(index < 0){
        index = 0;
    }
    if(_arrayData.count == 0){
        return -1;
    }
    
    return index;
}



@end
