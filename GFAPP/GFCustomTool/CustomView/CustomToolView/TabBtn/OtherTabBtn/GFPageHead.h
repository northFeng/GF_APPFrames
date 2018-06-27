//
//  GFPageHead.h
//  GFAPP
//  头文件
//  Created by gaoyafeng on 2018/6/21.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#ifndef GFPageHead_h
#define GFPageHead_h

#import "UIView+ViewController.h"
#import "UIView+EasyFrame.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#endif /* GFPageHead_h */


/**
- (void)setUpSegment {
 
 #import "GFSegmentManager.h"//导入这个头文件
 
    //    NSArray *list = @[@"商品",
    //                      @"商家信息",
    //                      @"评价"];
    NSArray *list = self.categoryTitles;
    
    //第三方head tabBtn按钮条
    _segHead = [[GFSegmentHead alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) titles:list headStyle:SegmentHeadStyleLine layoutStyle:GFSegmentLayoutDefault];
    _segHead.fontScale = 1.2;
    _segHead.fontSize = 14;
    _segHead.deSelectColor = [UIColor lightGrayColor];
    _segHead.selectColor = [UIColor redColor];
    _segHead.lineScale = 1;
    _segHead.lineColor = [UIColor redColor];
    
    //第三方scrollView
    _segScroll = [[GFSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, self.tableView.frame.size.height-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];//添加子视图
    _segScroll.loadAll = YES;
    _segScroll.showIndex = 0;
    
    //绑定两个head 和 ScrollView && 使内部产生联动
    //[GFSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
    //    [self.view addSubview:_segHead];
    //    [self.view addSubview:_segScroll];
    //}];
    
    //用这个可以获取滑动的触发位置
    [GFSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.cell.contentView addSubview:_segHead];
        [self.cell.contentView addSubview:_segScroll];
    } selectEnd:^(NSInteger index) {
        NSLog(@"滑动到位置：%ld",index);
    }];
    
}

//获取添加的视图数组
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.childVCs.count; i++) {
        HSFBaseTableVC *vc = self.childVCs[i];
        [arr addObject:vc];
    }
    return arr;
}
 
 */
