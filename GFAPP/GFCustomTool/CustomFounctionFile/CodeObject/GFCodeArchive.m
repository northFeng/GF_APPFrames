//
//  GFCodeArchive.m
//  GFAPP
//
//  Created by XinKun on 2018/2/18.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFCodeArchive.h"

#import <objc/runtime.h>

@implementation GFCodeArchive

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return nil;
}

///设置过滤不需要的归档的属性
- (NSArray *)ignoredNames{
    
    return @[];
}

///归档
- (void)encode:(NSCoder *)aCoder{
    
    // 一层层父类往上查找，对父类的属性执行归解档方法
    Class c = self.class;
    while (c &&c != [NSObject class]) {
        
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            // 如果有实现该方法再去调用
            if ([self respondsToSelector:@selector(ignoredNames)]) {
                if ([[self ignoredNames] containsObject:key]) continue;
            }
            
            id value = [self valueForKeyPath:key];
            [aCoder encodeObject:value forKey:key];
        }
        free(ivars);
        c = [c superclass];
    }
}

///解档
- (void)decode:(NSCoder *)aDecoder{
    
    // 一层层父类往上查找，对父类的属性执行归解档方法
    Class c = self.class;
    while (c &&c != [NSObject class]) {
        
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            // 如果有实现该方法再去调用
            if ([self respondsToSelector:@selector(ignoredNames)]) {
                if ([[self ignoredNames] containsObject:key]) continue;
            }
            
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
        c = [c superclass];
    }
}

@end
