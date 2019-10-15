//
//  GFObject.m
//  Demo
//
//  Created by 峰 on 2019/10/15.
//  Copyright © 2019 峰. All rights reserved.
//

#import "GFObject.h"

#import <objc/runtime.h>

@implementation GFObject

#pragma mark - 方法一  手动实现
//手动实现声明 下面必须实现代理中每个属性的set和get方法！！并且用runtime进行动态添加 成员变量！！！
@dynamic name;
//@dynamic age;

- (void)setName:(NSString *)name{
    objc_setAssociatedObject(self, "name", name, OBJC_ASSOCIATION_COPY);
}

- (NSString *)name{
    return objc_getAssociatedObject(self, "name");
}

/**
- (void)setAge:(NSString *)age{
    objc_setAssociatedObject(self, "age", age, OBJC_ASSOCIATION_COPY );
}

- (NSString *)age{
    return objc_getAssociatedObject(self, "age");
}
 */


#pragma mark - 方法二 自动实现！
//@synthesize name = _name;
@synthesize age = _age;


+ (void)a123{
    NSLog(@"-->1a123");
}

@end

#pragma mark - 分类实现
@implementation GFObject (Category)

/**
 分类中添加属性 系统会自动生成 set、get方法声明，但内部没有实现
  1、不用runtime动态添加属性 ——> 相当于添加了 两个可以使用点语法 的 set 和 get 方法
  2、用runtime动态添加舒心 ——>  内部会生成 成员变量
 */


#pragma mark - 第一种做法 不使用runtime ——> 点语法 调用 set和get方法

- (void)setMessage:(NSString *)message{
    if ([message isEqualToString:@"很好"]) {
        self.score = @"90";
    }
}
- (NSString *)message{
    if ([self.score intValue] > 80) {
        return @"很好";
    }else{
        return @"很差";
    }
}


#pragma mark - 第二种  使用truntime ——> 动态添加 成员变量

- (void)setScore:(NSString *)score{
    objc_setAssociatedObject(self, "score", score, OBJC_ASSOCIATION_COPY);
}
- (NSString *)score{
    return objc_getAssociatedObject(self, "score");
}

+ (void)a123{
    
    NSLog(@"-->2a123");
}

@end

