//
//  NSMutableArray+GFExtension.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "NSMutableArray+GFExtension.h"

@implementation NSMutableArray (GFExtension)

- (BOOL)gf_addObject:(id)itemObject{
    
    if (![itemObject isKindOfClass:[NSNull class]] && itemObject != nil) {
        
        [self addObject:itemObject];
        
        return YES;
    }else{
        
        return NO;
    }
}

///按照位置删除一个元素
- (BOOL)gf_removeObjectAtIndex:(NSUInteger)index{
    
    if ((index <= self.count - 1) && (index >= 0) && (self.count > 0)) {
        
        [self removeObjectAtIndex:index];
        
        return YES;
    }else{
        
        return NO;
    }
}

///按照元素删除一个元素
- (BOOL)gf_removeObject:(nonnull id)object{
    
    if ([self containsObject:object]) {
        //这个不会崩溃，找的到就删除，找不到也不会崩溃
        [self removeObject:object];
        
        return YES;
    }else{
        
        return NO;
    }
}


@end
