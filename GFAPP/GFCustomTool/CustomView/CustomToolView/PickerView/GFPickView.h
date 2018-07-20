//
//  GFPickView.h
//  GFAPP
//  滚轮数据选择器
//  Created by gaoyafeng on 2018/7/4.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFPickView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

/** 数组 */
@property (nonatomic,strong) NSMutableArray *dataArray;

/** block回调 */
@property (nonatomic,copy) void(^blockResult)(NSString *result);

@end


/**
 
//添加选择器
_pickView = [[NQDPickView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 150)];
_pickView.backgroundColor = [UIColor whiteColor];
 
BBWeakSelf
 //回调处理
_pickView.blockResult = ^(NSString *result) {
    if (result.length) {
        weakSelf.labelMd.text = result;
    }
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.pickView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 150);
    }];
};
[self.view addSubview:_pickView];

*/
