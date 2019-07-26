//
//  NSObject+GFExtension.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/22.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "NSObject+GFExtension.h"

#import <objc/runtime.h>

/**
 //用来标记是哪一个属性的key常见有三种写法，但代码效果是一样的，如下：
 //利用静态变量地址唯一不变的特性
 1、static void *strKey = &strKey;
 
 2、static NSString *strKey = @"strKey";
 
 3、static char strKey;
 */

static void *strKey = &strKey;//一个属性对应一个key

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


/**
 分类中手动添加属性的set方法和get方法
 @dynamic 属性;//手动实现set和get
 @synthesize 属性;//自动实现set和get 代理中添加属性，用这个就行
 */
-(void)setStrDescribe:(NSString *)strDescribe
{
    objc_setAssociatedObject(self, &strKey, strDescribe, OBJC_ASSOCIATION_COPY);
}

-(NSString *)strDescribe
{
    return objc_getAssociatedObject(self, &strKey);
}

@end
