//
//  NSMutableDictionary+GFExtension.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "NSMutableDictionary+GFExtension.h"

@implementation NSMutableDictionary (GFExtension)

- (BOOL)gf_setObject:(id)itemObject withKey:(NSString *)key{
    
    if (![itemObject isKindOfClass:[NSNull class]] && itemObject != nil) {
        
        [self setObject:itemObject forKey:key];
        
        return YES;
    }else{
        
        return NO;
    }
}


+ (NSDictionary *)makeWithObjectsAndKeys:(NSString *)firstKey, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (firstKey) {
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        id arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, firstKey);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        NSString *key = firstKey;
        while ((arg = va_arg(args, id))) {
            if (key) {
                dict[[key mutableCopy]] = arg;
                key = nil;
            } else {
                if ([arg isKindOfClass:[NSString class]]){
                    key = (NSString *)arg;
                }
            }
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
    return [dict copy];
}



@end
