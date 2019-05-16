//
//  FSTimePickView.m
//  FlashSend
//
//  Created by gaoyafeng on 2019/4/11.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "FSTimePickView.h"

@implementation FSTimePickView

{
    UIButton *_backView;
    
    UILabel *_labelTitle;//标题
    
    /** 门店选择器 */
    UIPickerView *_pickerView;
    
    NSString *_selectStr;
    
    NSArray *_arrayData;
    
    NSInteger _indexOne;//第一轮选中位置
    NSInteger _indexTwo;//第二轮选中位置
    NSInteger _indexThr;//第二轮选中位置
}



#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if (self = [super init]) {
        _indexOne = 0;
        _indexTwo = 0;
        _indexThr = 0;
        self.backgroundColor = [RGBS(28) colorWithAlphaComponent:0.4];
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    _backView = [UIButton buttonWithType:UIButtonTypeCustom];
    _backView.backgroundColor = APPColor_White;
    [self addSubview:_backView];
    _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 317*KSCALE);
    
    _labelTitle = [GFFunctionMethod view_createLabelWith:@"选择取件时间" font:22*KSCALE textColor:APPColor_Black textAlignment:NSTextAlignmentCenter textWight:1];
    [_backView addSubview:_labelTitle];
    
    //取消按钮
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    //[cancle setTitle:@"取消" forState:UIControlStateNormal];
    //[cancle setTitleColor:APPColor_Gray forState:UIControlStateNormal];
    //cancle.titleLabel.font = kFontOfSystem(16*KSCALE);
    [cancle setImage:ImageNamed(@"mine_close") forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(onCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:cancle];
    
    
    //确定按钮
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:APPColor_Blue forState:UIControlStateNormal];
    confirm.titleLabel.font = kFontOfCustom(kMediumFont, 16*KSCALE);
    [confirm addTarget:self action:@selector(onConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:confirm];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBS(241);
    [_backView addSubview:line];
    
    
    //添加选择器
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = APPColor_White;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_backView addSubview:_pickerView];
    
    
    //约束
    _labelTitle.sd_layout.centerXEqualToView(_backView).topSpaceToView(_backView, 18*KSCALE).widthIs(160*KSCALE).heightIs(30*KSCALE);
    cancle.sd_layout.leftSpaceToView(_backView, 19).centerYEqualToView(_labelTitle).widthIs(28).heightIs(28);
    confirm.sd_layout.rightSpaceToView(_backView, 20).centerYEqualToView(_labelTitle).widthIs(34*KSCALE).heightIs(22*KSCALE);
    
    line.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).topSpaceToView(_labelTitle, 14*KSCALE).heightIs(1);
    
    _pickerView.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).bottomEqualToView(_backView).topSpaceToView(line, 0);
    
    
}


//约束布局
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self onCancleBtn];
}


///弹出选择器
+ (void)showAlertPickViewWithSuperVC:(UIViewController *)superVC showData:(NSArray *)arrayData alertTitle:(NSString *)title blockHandle:(APPBackBlock)blockHandle{
    
    //创建选择器
    FSTimePickView *pickView = [[FSTimePickView alloc] init];
    pickView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    pickView.hidden = YES;
    pickView.block = blockHandle;
    pickView.apendStringOne = @"点";
    pickView.apendStringTwo = @"分";
    
    [pickView setArrayData:arrayData withTitle:title];
    //弹出来
    [superVC.view.window addSubview:pickView];
}


///赋值
- (void)setArrayData:(NSArray *)arrayData withTitle:(NSString *)title{
    
    _labelTitle.text = title;
    _arrayData = [arrayData copy];
    
    [self showPickViewWithOneIndex:0 twoIndex:0 thrIndex:0];
}

///赋值
- (void)setArrayData:(NSArray *)arrayData withTitle:(NSString *)title indexOne:(NSInteger)indexOne indexTwo:(NSInteger)indexTwo thrIndex:(NSInteger)indexThr{
    
    _labelTitle.text = title;
    _arrayData = [arrayData copy];
    
    [self showPickViewWithOneIndex:indexOne twoIndex:indexTwo thrIndex:indexThr];
}

///显示选择器
- (void)showPickViewWithOneIndex:(NSInteger)indexOne twoIndex:(NSInteger)indexTwo thrIndex:(NSInteger)indexThr{
    
    //选中的滚轮位置
    _indexOne = indexOne;
    _indexTwo = indexTwo;
    _indexThr = indexThr;
    
    [_pickerView reloadAllComponents];
    
    //滚到指定位置
    [_pickerView selectRow:indexOne inComponent:0 animated:NO];
    [_pickerView selectRow:indexTwo inComponent:1 animated:NO];
    [_pickerView selectRow:indexThr inComponent:2 animated:NO];
    
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self->_backView.frame = CGRectMake(0, kScreenHeight - 317*KSCALE, kScreenWidth, 317*KSCALE);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 按钮点击事件

///点击取消按钮
- (void)onCancleBtn{
    
    [UIView animateWithDuration:0.2 animations:^{
        self->_backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 317*KSCALE);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
}

///点击确定按钮
- (void)onConfirmBtn{
    
    //回调
    if (self.block) {
        
        NSMutableArray *arrayBlock = [NSMutableArray array];
        
        NSArray *array1 = [self getComponentDataForComponent:0];
        NSArray *array2 = [self getComponentDataForComponent:1];
        NSArray *array3 = [self getComponentDataForComponent:2];
        
        NSString *str1 = [array1 gf_getItemWithIndex:_indexOne];
        NSString *str2 = [array2 gf_getItemWithIndex:_indexTwo];
        NSString *str3 = [array3 gf_getItemWithIndex:_indexThr];
        
        [arrayBlock gf_addObject:str1];
        [arrayBlock gf_addObject:str2];
        [arrayBlock gf_addObject:str3];
        
        NSArray *timeArray = [self analysTimeDataToTimeStrWithArrayData:arrayBlock];
        
        self.block(YES,timeArray);
    }
    
    [self onCancleBtn];//隐藏
    
}


#pragma mark - UIPickerView代理
//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _arrayData.count;
}
//指定每个表盘有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSArray *array = [self getComponentDataForComponent:component];
    
    return array.count;
}


//自定义cell
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
    
    //设置分割线的颜色
    for (UIView *singleLine in pickerView.subviews){
        
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = APPColor_Line;
        }
    }
    
    /*重新定义row 的UILabel*/
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [GFFunctionMethod view_createLabelWith:@"" font:14 textColor:APPColor_Black textAlignment:NSTextAlignmentCenter textWight:0];
    }
    
    
    pickerLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
    
    return pickerLabel;
}



//指定每行要展示的数据
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//
//    NSArray *array = _arrayData[component];
//
//    return array[row];
//}

//指定每行要展示的数据
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray *array = [self getComponentDataForComponent:component];
    
    NSAttributedString *attrbuteString;
    
    NSString *showString = [array gf_getItemWithIndex:row];
    
    switch (component) {
        case 0:
        {
            //******************** 第一轮 ********************
            
            //NSDictionary *dic = array[row];
            //dic[@"label"]
            
            if (row == _indexOne) {
                //选中
                attrbuteString = [[NSAttributedString alloc] initWithString:showString attributes:@{NSFontAttributeName:kFontOfCustom(kSemibold, 20),NSForegroundColorAttributeName:APPColor_Blue}];
            }else{
                //默认
                attrbuteString = [[NSAttributedString alloc] initWithString:showString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:APPColor_BlackDeep}];
            }
        }
            break;
        case 1:
        {
            //******************** 第二轮 ********************
            if (![showString isEqualToString:@"立即取件"]) {
                showString = [NSString stringWithFormat:@"%@点",showString];
            }
            if (row == _indexTwo) {
                attrbuteString = [[NSAttributedString alloc] initWithString:showString attributes:@{NSFontAttributeName:kFontOfCustom(kSemibold, 20),NSForegroundColorAttributeName:APPColor_Blue}];
            }else{
                //默认
                attrbuteString = [[NSAttributedString alloc] initWithString:showString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:APPColor_BlackDeep}];
            }
        }
            break;
        case 2:
        {
            //******************** 第三轮 ********************
            if (showString.length > 0) {
                showString = [NSString stringWithFormat:@"%@分",showString];
            }
            if (row == _indexThr) {
                attrbuteString = [[NSAttributedString alloc] initWithString:showString attributes:@{NSFontAttributeName:kFontOfCustom(kSemibold, 20),NSForegroundColorAttributeName:APPColor_Blue}];
            }else{
                //默认
                attrbuteString = [[NSAttributedString alloc] initWithString:showString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:APPColor_BlackDeep}];
            }
        }
            break;
            
        default:
            break;
    }
    
    
    return attrbuteString;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return kScreenWidth/3.;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 44.;
}

//选中时回调的委托方法，在此方法中实现联动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            _indexOne = row;
            break;
        case 1:
            _indexTwo = row;
            break;
        case 2:
            _indexThr = row;
            break;
            
        default:
            break;
    }
    
    //刷新picker
    [pickerView reloadComponent:component];
    
    switch (component) {
        case 0:
            //第一轮滚动处理————>联动第二轮
            [_pickerView selectRow:0 inComponent:1 animated:NO];
            //刷新第二轮数据
            _indexTwo = 0;
            [_pickerView reloadComponent:1];
            
            //第二轮滚动 联动第三轮
            [_pickerView selectRow:0 inComponent:2 animated:NO];
            //刷新第二轮数据
            _indexThr = 0;
            [_pickerView reloadComponent:2];
            
            break;
        case 1:
            //第二轮滚动 联动第三轮
            [_pickerView selectRow:0 inComponent:2 animated:NO];
            //刷新第二轮数据
            _indexThr = 0;
            [_pickerView reloadComponent:2];
            
            break;
            
        default:
            break;
    }
}


#pragma mark - 计算每组 对应的数组数据

- (NSArray *)getComponentDataForComponent:(NSInteger)component{
    
    NSArray *array;
    
    switch (component) {
        case 0:
        {
            //第一轮
            array = [_arrayData gf_getItemWithIndex:component];
        }
            break;
        case 1:
        {
            //第二轮 数组为多个数组
            NSArray *arrayTwo = [_arrayData gf_getItemWithIndex:component];
            array = [arrayTwo gf_getItemWithIndex:_indexOne];
        }
            break;
        case 2:
        {
            //第三轮
            NSArray *arrayThr = [_arrayData gf_getItemWithIndex:component];
            
            switch (_indexOne) {
                case 0:
                {
                    //今日
                    if (_indexTwo == 0) {
                        //立即取件
                        array = [arrayThr gf_getItemWithIndex:0];
                    }else if (_indexTwo == 1){
                        //两个小时后第一个 不完整时间
                        array = [arrayThr gf_getItemWithIndex:1];//不完整分钟
                    }else{
                        array = [arrayThr gf_getItemWithIndex:2];
                    }
                }
                    break;
                    
                case 1:
                {
                    //明天
                    if (_indexTwo == 0) {
                        //第一个 可能是不完整时间
                        NSArray *arrayTwo = [_arrayData gf_getItemWithIndex:1];
                        NSArray *arrayTwo1 = [arrayTwo gf_getItemWithIndex:0];
                        if (arrayTwo1.count == 1) {
                            //晚上22点后下的单
                            array = [arrayThr gf_getItemWithIndex:1];//不完整分钟
                        }else{
                            //22点之前下的单
                            array = [arrayThr gf_getItemWithIndex:2];
                        }
                    }else{
                        array = [arrayThr gf_getItemWithIndex:2];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    return array;
}

#pragma mark - 获取预约时间数据(当前此刻时间往后2小时，+10分钟)
+ (NSArray *)getFutureTimeChoseData{
    
    NSMutableArray *totalArray = [NSMutableArray array];
    
    NSArray *arrayOne = @[@"今天",@"明天"];
    
    NSInteger futureHour = 2;//预约小时
    NSInteger futureSection = 10;//预约分钟
    
    NSInteger currentSection = [GFFunctionMethod date_getNowTimeStampWithPrecision:1] + futureSection*60;//往后延迟10分钟
    NSString *currentTime = [GFFunctionMethod date_getDateWithTimeStamp:currentSection timeType:@"HH:mm"];//[GFFunctionMethod date_getCurrentDateWithType:@"HH:mm"];//当前时间戳精确秒
    
    NSArray *currentTimeArray = [currentTime componentsSeparatedByString:@":"];
    NSInteger hour = [[currentTimeArray gf_getItemWithIndex:0] integerValue];
    NSInteger minute = [[currentTimeArray gf_getItemWithIndex:1] integerValue];
    
    //分钟数 是否超过55
    if (minute >= 55) {
        hour += 1;
        minute = 0;
    }
    
    //********* 第二轮  只有两组数据 今天 && 明天
    NSMutableArray *arrayTwo = [NSMutableArray array];
    
    NSMutableArray *arrayTwo1 = [NSMutableArray array];
    NSMutableArray *arrayTwo2 = [NSMutableArray array];
    
    //是否超过 22点
    //点 + 2
    if (hour < 24 - futureHour) {
        [arrayTwo1 gf_addObject:@"立即取件"];
        for (NSInteger i = hour + futureHour; i < 24 ; i++) {
            [arrayTwo1 gf_addObject:[NSString stringWithFormat:@"%02ld",i]];//00点
        }
        
        for (int i = 0; i < 24; i++) {
            NSString *timeStr = [NSString stringWithFormat:@"%02d",i];//00点
            [arrayTwo2 gf_addObject:timeStr];
        }
    }else{
        [arrayTwo1 gf_addObject:@"立即取件"];
        
        for (NSInteger i = hour + futureHour - 24; i < 24; i++) {
            NSString *timeStr = [NSString stringWithFormat:@"%02ld",i];//00点
            [arrayTwo2 gf_addObject:timeStr];
        }
    }
    
    [arrayTwo gf_addObject:arrayTwo1];
    [arrayTwo gf_addObject:arrayTwo2];
    
    //********* 第三轮  三个数组 立即取件为空  && 第一个预约点 对应的不完整的分钟  && 完整分钟
    NSMutableArray *arrayThr = [NSMutableArray array];
    
    NSArray *arrayThr1 = @[@""];
    NSMutableArray *arrayThr2;
    NSArray *arrayThr3 = @[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"];
    
    if (minute == 0) {
        arrayThr2 = [arrayThr3 copy];
    }else{
        NSInteger index = minute / 5;
        arrayThr2 = [NSMutableArray array];
        for (NSInteger i = index + 1 ; i < arrayThr3.count ; i++) {
            
            [arrayThr2 gf_addObject:[arrayThr3[i] copy]];
        }
    }
    
    
    [arrayThr gf_addObject:arrayThr1];
    [arrayThr gf_addObject:arrayThr2];
    [arrayThr gf_addObject:arrayThr3];
    
    
    [totalArray gf_addObject:arrayOne];
    [totalArray gf_addObject:arrayTwo];
    [totalArray gf_addObject:arrayThr];
    
    return [totalArray copy];
}

#pragma mark - 解析时间 成时间格式 2012-10-10 11:11
- (NSArray *)analysTimeDataToTimeStrWithArrayData:(NSArray *)arrayData{
    
    NSString *futureTimeStr = @"";
    NSString *showTime = @"";
    
    //@"yyyy-MM-dd HH:mm"
    NSInteger currentTime = [GFFunctionMethod date_getNowTimeStampWithPrecision:1];//当前时间戳精确秒
    
    NSString *oneStr = [arrayData gf_getItemWithIndex:0];
    NSString *twoStr = [arrayData gf_getItemWithIndex:1];
    NSString *thrStr = [arrayData gf_getItemWithIndex:2];
    
    if ([twoStr isEqualToString:@"立即取件"]) {
        futureTimeStr = @"立即取件";
        showTime = @"立即取件";
    }else{
        
        //第一步 计算 年月日
        showTime = @"今天";
        if ([oneStr isEqualToString:@"明天"]) {
            //第二天
            currentTime += (24*60*60);
            showTime = @"明天";
        }
        futureTimeStr = [GFFunctionMethod date_getDateWithTimeStamp:currentTime timeType:@"yyyy-MM-dd"];
        
        //第二步 计算具体时间 时:分
        futureTimeStr = [NSString stringWithFormat:@"%@ %@:%@",futureTimeStr,twoStr,thrStr];
        
        showTime = [NSString stringWithFormat:@"%@%@:%@取件",showTime,twoStr,thrStr];
    }
    
    NSArray *timeArray = @[futureTimeStr,showTime];
    return timeArray;
}


@end
