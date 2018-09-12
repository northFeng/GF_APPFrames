//
//  GFSearchBarView.h
//  Lawpress
//  滑动按钮视图(按钮总长度超过屏幕)
//  Created by XinKun on 2017/6/7.
//  Copyright © 2017年 彬万. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFSearchBarView : UIView<UIScrollViewDelegate>


///回调
@property (nonatomic,copy) void(^blockBtnIndex)(NSInteger index);


///创建btn
- (void)setBtnArray:(NSArray *)arrayBtnString;


///滚动当前按钮
- (void)scrollerToCurrentBtn:(NSInteger)index;

@end
