//
//  GFSegmentManager.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/6/21.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFSegmentManager.h"

@implementation GFSegmentManager

+ (void)associateHead:(GFSegmentHead *)head
           withScroll:(GFSegmentScroll *)scroll
           completion:(void(^)())completion {
    [GFSegmentManager associateHead:head withScroll:scroll completion:completion selectEnd:nil];
}


+ (void)associateHead:(GFSegmentHead *)head
           withScroll:(GFSegmentScroll *)scroll
           completion:(void(^)())completion
            selectEnd:(void(^)(NSInteger index))selectEnd {
    NSInteger showIndex;
    showIndex = head.showIndex?head.showIndex:scroll.showIndex;
    head.showIndex = scroll.showIndex = showIndex;
    
    head.selectedIndex = ^(NSInteger index) {
        [scroll setContentOffset:CGPointMake(index*scroll.width, 0) animated:YES];
        if (selectEnd) {
            selectEnd(index);
        }
    };
    [head defaultAndCreateView];
    
    scroll.scrollEnd = ^(NSInteger index) {
        [head setSelectIndex:index];
        if (selectEnd) {
            selectEnd(index);
        }
    };
    scroll.animationEnd = ^(NSInteger index) {
        [head animationEnd];
    };
    scroll.offsetScale = ^(CGFloat scale) {
        [head changePointScale:scale];
    };
    
    if (completion) {
        completion();
    }
    [scroll createView];
    
    UIView *view = head.nextResponder?head:scroll;
    UIViewController *currentVC = [view viewController];
    currentVC.automaticallyAdjustsScrollViewInsets = NO;
}

@end
