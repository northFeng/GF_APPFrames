//
//  NSString+NewFunction.m
//  GFAPP
//
//  Created by 峰 on 2019/8/6.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "NSString+NewFunction.h"

@implementation NSString (NewFunction)

- (NSString *(^)(NSString *))append {
    return ^NSString *(NSString * str){
        if (!str) {
            return self;
        }
        return [self stringByAppendingString:str];
    };
}

@end
