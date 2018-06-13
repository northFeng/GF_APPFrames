//
//  SegmentPageHead.h
//  MLMSegmentPage
//
//  Created by my on 16/11/4.
//  Copyright © 2016年 my. All rights reserved.
//

#ifndef SegmentPageHead_h
#define SegmentPageHead_h

#import "UIView+ViewController.h"
#import "UIView+EasyFrame.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#endif /* SegmentPageHead_h */


/** 用法
#pragma mark - 添加子控制器
- (void)setUpSegment {
    //    NSArray *list = @[@"商品",
    //                      @"商家信息",
    //                      @"评价"];
    NSArray *list = self.categoryTitles;
 
    //第三方head tabBtn按钮条
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) titles:list headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    _segHead.fontScale = 1.2;
    _segHead.fontSize = 14;
    _segHead.deSelectColor = [UIColor lightGrayColor];
    _segHead.selectColor = [UIColor redColor];
    _segHead.lineScale = 1;
    _segHead.lineColor = [UIColor redColor];
 
    //第三方scrollView
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, self.tableView.frame.size.height-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];//添加子视图
    _segScroll.loadAll = YES;
    _segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.cell.contentView addSubview:_segHead];
        [self.cell.contentView addSubview:_segScroll];
    }];
}
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.childVCs.count; i++) {
        HSFBaseTableVC *vc = self.childVCs[i];
        [arr addObject:vc];
    }
    return arr;
}
 
 */
 
 
 
 
