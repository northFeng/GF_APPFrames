//
//  NSMutableDictionary+GFExtension.h
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (GFExtension)


/**
 *  @brief 添加某个元素(防止崩溃)
 *
 *  @param itemObject 添加元素
 *  @param key 元素对应的key
 *  return BOOL是否成功
 */
- (BOOL)gf_setObject:(id)itemObject withKey:(NSString *)key;


@end
