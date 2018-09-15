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



@end
