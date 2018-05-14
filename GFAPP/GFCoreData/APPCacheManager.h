//
//  APPCacheManager.h
//  GFAPP
//  APP缓存管理者
//  Created by gaoyafeng on 2018/5/14.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPCacheManager : NSObject

/**
 根据key判断是否已存在缓存
 
 @param key 保存的key
 @return 是否已存在缓存， 已有缓存 = yes ，  无 = NO
 */
+ (BOOL)isContainsCacheForKey:(NSString *)key;

/**
 保存数据
 
 @param value 要保存的数据
 @param key 保存数据的key
 */
+ (void)setCacheObject:(id)value Key:(NSString *)key;


/**
 获取数据
 
 @param key 缓存的key
 @return 缓存的数据
 */
+ (id)getObjectCaCheForKey:(NSString *)key;

/**
 删除缓存数据
 
 @param key 要删除缓存数据的key
 */
+ (void)removeObjectForKey:(NSString *)key;

/**
 删除所有的缓存数据
 */
+ (void)removeAllObjects;


@end
