//
//  NSArray+GFExtension.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "NSArray+GFExtension.h"

#import <objc/runtime.h>

@implementation NSArray (GFExtension)

+ (void)load {
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(cm_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}

// 为了避免和系统的方法冲突，我一般都会在swizzling方法前面加前缀
- (id)cm_objectAtIndex:(NSUInteger)index {
    // 判断下标是否越界，
    if ((self.count > 0) && (index >= 0) && (index <= self.count - 1)) {
        // 如果没有问题，则正常进行方法调用
        /**
        里面调用了自身？这是递归吗？其实不是。这个时候方法替换已经有效了，cm_objectAtIndex这个SEL指向的其实是原来系统的objectAtIndex:的IMP。因而不是递归。
         */
        /**
         1、这里调自己，其实是调用了 交换的那个方法
         2、根据业务需求，在这里进行自己的业务处理，置于下面这步是否调用交互的那个方法，看需求而定！！
         */
        return [self cm_objectAtIndex:index];//这里不是自己调用自己，而是调用的那个交换方法！！！！！！
    }else {
        //如果越界就进入异常拦截
        @try {
            return [self cm_objectAtIndex:index];//这里不是自己调用自己，而是调用的那个交换方法！！！！！！
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息。如果是线上，可以在这里将崩溃信息发送到服务器
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    }
}

- (id)gf_getItemWithIndex:(NSInteger)index{
    
    if ((self.count > 0) && (index >= 0) && (index <= self.count - 1)) {
        
        return self[index];
    }else{
        return nil;
    }
}


- (NSMutableArray *)mutableArrayDeepCopy{
    
    NSMutableArray * array = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id objOject;
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            objOject = [obj mutableDicDeepCopy];
            
        }else if ([obj isKindOfClass:[NSArray class]]){
            
            objOject = [obj mutableArrayDeepCopy];
            
        }else{
            
            objOject = obj;
        }
        [array addObject:objOject];
        
    }];
    
    return array;
    
}



@end





@implementation NSDictionary (GFExtension)


-(NSMutableDictionary *)mutableDicDeepCopy{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
    
    NSArray *keys=[self allKeys];
    for(id key in keys)
    {
        //循环读取复制每一个元素
        id value = [self objectForKey:key];
        
        id copyValue;
        
        // 如果是字典，递归调用
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            copyValue=[value mutableDicDeepCopy];
            
            //如果是数组，数组数组深拷贝
        }else if([value isKindOfClass:[NSArray class]]){
            
            copyValue = [value mutableArrayDeepCopy];
            
        }else{
            
            copyValue = [value copy];
        }
        
        [dict setObject:copyValue forKey:key];
        
    }
    
    return dict;
}




@end
