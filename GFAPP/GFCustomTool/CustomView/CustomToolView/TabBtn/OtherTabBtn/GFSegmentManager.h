//
//  GFSegmentManager.h
//  GFAPP
//
//  Created by gaoyafeng on 2018/6/21.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GFSegmentHead.h"
#import "GFSegmentScroll.h"
#import "GFPageHead.h"

@interface GFSegmentManager : NSObject

/**
 * 绑定两个view
 */
+ (void)associateHead:(GFSegmentHead *)head
           withScroll:(GFSegmentScroll *)scroll
           completion:(void(^)())completion;


+ (void)associateHead:(GFSegmentHead *)head
           withScroll:(GFSegmentScroll *)scroll
           completion:(void(^)())completion
            selectEnd:(void(^)(NSInteger index))selectEnd;


@end
