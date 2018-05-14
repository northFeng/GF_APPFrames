//
//  APPCacheManager.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/14.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPCacheManager.h"

//YYCache缓存框架
#import <YYCache/YYCache.h>

static NSString *CFCacheKey = @"GFCacheKey";

@implementation APPCacheManager

+ (BOOL)isContainsCacheForKey:(NSString *)key{
    if (key.length==0||!key)
    {
        return NO;
    }
    return  [[APPCacheManager getCacheManager] containsObjectForKey:key];
}

+ (YYCache *)getCacheManager{
    
    return [YYCache cacheWithName:CFCacheKey];
}

+ (void)setCacheObject:(id)value Key:(NSString *)key{
    if (!key||key.length==0||(value==nil))
    {
        return ;
    }
    [[self getCacheManager] setObject:value forKey:key];
}

+ (id)getObjectCaCheForKey:(NSString *)key{
    if (!key||key.length==0)
    {
        return nil;
    }
    return [[self getCacheManager] objectForKey:key];
}

+(void)removeObjectForKey:(NSString *)key{
    [[self getCacheManager] removeObjectForKey:key];
}

+(void)removeAllObjects{
    [[self getCacheManager] removeAllObjects];
}


@end
