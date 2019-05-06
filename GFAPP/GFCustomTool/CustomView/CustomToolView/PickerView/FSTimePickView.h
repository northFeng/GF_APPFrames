//
//  FSTimePickView.h
//  FlashSend
//  时间滚轮选择器view
//  Created by gaoyafeng on 2019/4/11.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSTimePickView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

///第一轮后面拼接文字
@property (nonatomic,copy) NSString *apendStringOne;

///第二轮后面拼接文字
@property (nonatomic,copy) NSString *apendStringTwo;

///block
@property (nonatomic,copy) APPBackBlock block;

///弹出选择器
+ (void)showAlertPickViewWithSuperVC:(UIViewController *)superVC showData:(NSArray *)arrayData alertTitle:(NSString *)title blockHandle:(APPBackBlock)blockHandle;


+ (NSArray *)getFutureTimeChoseData;

@end

NS_ASSUME_NONNULL_END

/** 用法！
 
NSArray *timeData = [FSTimePickView getFutureTimeChoseData];

[FSTimePickView showAlertPickViewWithSuperVC:self showData:timeData alertTitle:@"选择取件时间" blockHandle:^(BOOL result, id idObject) {
    NSArray *arrayTime = (NSArray *)idObject;
    self->_futureTime = [arrayTime gf_getItemWithIndex:0];
    self->_futureShowTime = [arrayTime gf_getItemWithIndex:1];
    [self.tableView reloadData];//刷新
    [self cellActionAfterRequest];//从新计价
}];
 */
