//
//  NSArray+GFExtension.h
//  GFAPP
//  数组扩展
//  Created by gaoyafeng on 2018/9/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GFExtension)


/**
 *  @brief 获取某个元素(防止越界崩溃)
 *
 *  @param index 元素下标
 */
- (id)gf_getItemWithIndex:(NSInteger)index;



@end
