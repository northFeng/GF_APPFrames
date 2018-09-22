//
//  NSObject+GFExtension.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/22.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "NSObject+GFExtension.h"

#import <objc/runtime.h>

@implementation NSObject (GFExtension)


/**
 *  @brief 深拷贝对象
 *
 */
- (id)gf_deepCopy:(id)idObject{
    
    // 一层层父类往上查找，对父类的属性执行归解档方法
    Class c = self.class;
    while (c &&c != [NSObject class]) {
        
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            id value = [idObject valueForKey:key];
            
            [self setValue:value forKey:key];
        }
        free(ivars);
        
        c = [c superclass];
    }
    
    return self;
}



@end
