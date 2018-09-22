//
//  NSArray+GFExtension.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "NSArray+GFExtension.h"

@implementation NSArray (GFExtension)

- (id)gf_getItemWithIndex:(NSInteger)index{
    
    if (self.count - 1 >= index) {
        
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
