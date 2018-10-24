//
//  GFPickView.h
//  GFAPP
//  滚轮数据选择器
//  Created by gaoyafeng on 2018/7/4.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFPickView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

///选择器类型  0:数据里两个数组  1:数据里两个数组(第二数组里是很多数组)
@property (nonatomic,assign) NSInteger typePicker;

///第一轮后面拼接文字
@property (nonatomic,strong) NSString *apendStringOne;

///第二轮后面拼接文字
@property (nonatomic,strong) NSString *apendStringTwo;


///block
@property (nonatomic,copy) GFBackBlock block;


///赋值并显示视图  arrayData必须内部含有数组
- (void)setArrayData:(NSArray *)arrayData withTitle:(NSString *)title;

///赋值 滚轮滚到的位置 indexOne:滚轮1滚到的位置  indexTwo:滚轮2滚到的位置
- (void)setArrayData:(NSArray *)arrayData withTitle:(NSString *)title indexOne:(NSInteger)indexOne indexTwo:(NSInteger)indexTwo;


@end


/**
 
//添加选择器
 //创建选择器
 _pickView = [[FSPickView alloc] init];
 [self.view addSubview:_pickView];
 _pickView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
 _pickView.hidden = YES;
 
 ///弹出来
[_pickView setArrayData:_arrayPickDate withTitle:@"取件时间"];

*/
