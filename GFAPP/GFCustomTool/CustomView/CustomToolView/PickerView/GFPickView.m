//
//  GFPickView.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/7/4.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFPickView.h"

@implementation GFPickView
{
    UIView *_backView;
    
    UILabel *_labelTitle;//标题
    
    /** 门店选择器 */
    UIPickerView *_pickerView;
    
    NSString *_selectStr;
    
    NSArray *_arrayData;
    
    NSInteger _indexOne;//第一轮选中位置
    NSInteger _indexTwo;//第二轮选中位置
}

#pragma mark - 视图布局
//初始化
- (instancetype)init{
    
    if ([super init]) {
        _indexOne = 0;
        _indexTwo = 0;
        self.backgroundColor = [RGBS(28) colorWithAlphaComponent:0.4];
        [self createView];
    }
    return self;
}


//创建视图
- (void)createView{
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 317*KSCALE);
    
    _labelTitle = [[APPLogisticsManager sharedInstance].functionMethod view_createLabelWith:@"取件时间" font:22*KSCALE textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter textWight:1];
    [_backView addSubview:_labelTitle];
    
    //取消按钮
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancle.titleLabel.font = kFontOfSystem(16*KSCALE);
    [cancle addTarget:self action:@selector(onCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:cancle];
    
    
    //确定按钮
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirm.titleLabel.font = kFontOfSystem(16*KSCALE);
    [confirm addTarget:self action:@selector(onConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:confirm];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBS(241);
    [_backView addSubview:line];
    
    
    //添加选择器
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_backView addSubview:_pickerView];
    
    
    //约束
    _labelTitle.sd_layout.centerXEqualToView(_backView).topSpaceToView(_backView, 18*KSCALE).widthIs(160*KSCALE).heightIs(30*KSCALE);
    cancle.sd_layout.leftSpaceToView(_backView, 20).centerYEqualToView(_labelTitle).widthIs(34*KSCALE).heightIs(22*KSCALE);
    confirm.sd_layout.rightSpaceToView(_backView, 20).centerYEqualToView(_labelTitle).widthIs(34*KSCALE).heightIs(22*KSCALE);
    
    line.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).topSpaceToView(_labelTitle, 14*KSCALE).heightIs(1);
    
    _pickerView.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).bottomEqualToView(_backView).topSpaceToView(line, 0);
    
    
}


//约束布局


#pragma mark - 按钮点击事件

///点击取消按钮
- (void)onCancleBtn{
    
    [UIView animateWithDuration:0.2 animations:^{
        self->_backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 317*KSCALE);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

///点击确定按钮
- (void)onConfirmBtn{
    
    [self onCancleBtn];
    
    //回调
    
    
}


///赋值
- (void)setArrayData:(NSArray *)arrayData withTitle:(NSString *)title{
    
    _labelTitle.text = title;
    _arrayData = [arrayData copy];
    
    [_pickerView reloadAllComponents];
    [_pickerView selectedRowInComponent:0];
    [_pickerView selectedRowInComponent:1];
    
    [UIView animateWithDuration:0.2 animations:^{
        self->_backView.frame = CGRectMake(0, kScreenHeight - 317*KSCALE, kScreenWidth, 317*KSCALE);
    } completion:^(BOOL finished) {
        self.hidden = NO;
    }];
}



#pragma mark - UIPickerView代理
//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
//指定每个表盘有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSArray *array = _arrayData[component];
    
    return array.count;
}

- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return nil;
}

//自定义cell
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [UIColor grayColor];
        }
    }
    
    /*重新定义row 的UILabel*/
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[APPLogisticsManager sharedInstance].functionMethod view_createLabelWith:@"" font:16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter textWight:0];
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
    
    NSArray *array = _arrayData[component];
    NSAttributedString *attrbuteString;
    switch (component) {
        case 0:
        {
            if (row == _indexOne) {
                attrbuteString = [[NSAttributedString alloc] initWithString:array[row] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:RGB(255,164,79)}];
            }else{
                attrbuteString = [[NSAttributedString alloc] initWithString:array[row] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
            }
        }
            break;
        case 1:
        {
            if (row == _indexTwo) {
                attrbuteString = [[NSAttributedString alloc] initWithString:array[row] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:RGB(255,164,79)}];
            }else{
                attrbuteString = [[NSAttributedString alloc] initWithString:array[row] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
            }
            
        }
            break;
        default:
            break;
    }
    
    
    return attrbuteString;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return kScreenWidth/2.;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 50;
}

//选中时回调的委托方法，在此方法中实现联动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSLog(@"选中位置--->%ld--->%ld",component,row);
    switch (component) {
        case 0:
            _indexOne = row;
            break;
        case 1:
            _indexTwo = row;
            break;
            
        default:
            break;
    }
    
    //刷新picker，看上面的代理
    [pickerView reloadComponent:component];
    
}






@end
