//
//  GFPageControl.m
//  SDCycleScrollView
//
//  Created by gaoyafeng on 2018/6/20.
//  Copyright © 2018年 GSD. All rights reserved.
//

#import "GFPageControl.h"

#define dotW 8 // 圆点宽
#define dotH 8  // 圆点高
#define magrin 8    // 圆点间距

@implementation GFPageControl

- (void)layoutSubviews
{
    [super layoutSubviews];
    //计算圆点间距
    CGFloat marginX = dotW + magrin;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotH)];
        }else {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotH)];
        }
        
        
        
    }

}



@end
