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


@end
