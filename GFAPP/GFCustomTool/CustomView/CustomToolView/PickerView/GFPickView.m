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
    /** 门店选择器 */
    UIPickerView *_pickerView;
    
    NSString *_selectStr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (instancetype)init{
    if ([super init]) {
        [self createView];
    }
    return self;
}

///创建视图
- (void)createView{
    
    //添加选择器
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    //_pickerView.sd_layout.leftEqualToView(self).topEqualToView(self).rightEqualToView(self).bottomEqualToView(self);
    
    //取消按钮
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(onCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancle];
    //cancle.sd_layout.leftSpaceToView(self, 15).topSpaceToView(self, 5).widthIs(40).heightIs(20);
    
    //确定按钮
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirm setTitle:@"确认" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(onConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirm];
    //confirm.sd_layout.rightSpaceToView(self, 15).topSpaceToView(self, 5).widthIs(40).heightIs(20);
    
}

///取消
- (void)onCancleBtn{
    
    if (self.blockResult) {
        self.blockResult(nil);
    }
}

///确认
- (void)onConfirmBtn{
    if (self.blockResult) {
        self.blockResult(_selectStr);
    }
}

//刷新数据
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    [_pickerView reloadComponent:0];
    
    if (dataArray.count) {
        [_pickerView selectRow:0 inComponent:0 animated:YES];
    }
}


#pragma mark - UIPickerView代理
//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//指定每个表盘有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}
//指定每行要展示的数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return self.dataArray[row][@"storeName"];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return 200;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 30;
}

//选中时回调的委托方法，在此方法中实现省份和城市间的联动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _selectStr = self.dataArray[row][@"storeName"];
}



@end
