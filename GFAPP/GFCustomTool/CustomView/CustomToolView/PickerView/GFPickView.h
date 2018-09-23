//
//  GFPickView.h
//  GFAPP
//  滚轮数据选择器
//  Created by gaoyafeng on 2018/7/4.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFPickView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

///block
@property (nonatomic,copy) GFBackBlock block;


///赋值并显示视图  arrayData必须内部含有数组
- (void)setArrayData:(NSArray *)arrayData withTitle:(NSString *)title;


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
