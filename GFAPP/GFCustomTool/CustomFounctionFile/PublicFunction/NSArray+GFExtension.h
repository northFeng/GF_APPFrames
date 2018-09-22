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



/**
 *  @brief 将数组进行可变的深拷贝（数组内部所有对象都变成可变类型）
 *
 */
- (NSMutableArray *)mutableArrayDeepCopy;



@end



@interface NSDictionary (GFExtension)


/**
 *  @brief 将不可变字典进行可变的深拷贝（字典内部所有对象都变成可变类型）
 *
 */
-(NSMutableDictionary *)mutableDicDeepCopy;




@end
