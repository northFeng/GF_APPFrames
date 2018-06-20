//
//  GFPageControl.h
//  SDCycleScrollView
//  自定义UIPageControl
//  Created by gaoyafeng on 2018/6/20.
//  Copyright © 2018年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFPageControl : UIPageControl

@end




/**  用法
 
_pageControl = [[GFPageControl alloc] init];
_pageControl.frame = CGRectMake(0, kScreenH-75*kscale, kScreenW, 20);//指定位置大小
_pageControl.numberOfPages = 3;//指定页面个数
_pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）

// 设置成圆点颜色
//    _pageControl.pageIndicatorTintColor =[UIColor yellowColor];
//    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];

// 设置成图片
[_pageControl setValue:[UIImage imageNamed:@"icon_dot_normal"] forKeyPath:@"_pageImage"];
[_pageControl setValue:[UIImage imageNamed:@"icon_dot_height"] forKeyPath:@"_currentPageImage"];
[self.view addSubview:_pageControl];
 
 */
