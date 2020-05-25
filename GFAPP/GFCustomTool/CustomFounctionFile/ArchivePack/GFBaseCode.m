//
//  GFBaseCode.m
//  GFAPP
//  归档数据
//  Created by XinKun on 2018/2/18.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFBaseCode.h"

#import <objc/runtime.h>

//归档宏
#define encodeRuntime(A) \
\
unsigned int count = 0;\
Ivar *ivars = class_copyIvarList([A class], &count);\
for (int i = 0; i<count; i++) {\
Ivar ivar = ivars[i];\
const char *name = ivar_getName(ivar);\
NSString *key = [NSString stringWithUTF8String:name];\
id value = [self valueForKey:key];\
[encoder encodeObject:value forKey:key];\
}\
free(ivars);\
\

//解档宏
#define initCoderRuntime(A) \
\
if (self = [super init]) {\
unsigned int count = 0;\
Ivar *ivars = class_copyIvarList([A class], &count);\
for (int i = 0; i<count; i++) {\
Ivar ivar = ivars[i];\
const char *name = ivar_getName(ivar);\
NSString *key = [NSString stringWithUTF8String:name];\
id value = [decoder decodeObjectForKey:key];\
[self setValue:value forKey:key];\
}\
free(ivars);\
}\
return self;\
\


@implementation GFBaseCode

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self encode:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        [self decode:aDecoder];
    }
    return self;
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
    
    /** 非Runtime 归档写法   YYModel 里封装方法   - (void)yy_modelEncodeWithCoder:(NSCoder *)aCoder;
     [aCoder encodeInteger:self.totalPageCount forKey:@"totalPageCount"];
     [aCoder encodeInteger:self.currentPageTotal forKey:@"currentPageTotal"];
     
     [aCoder encodeObject:self.record forKey:@"record"];
     [aCoder encodeObject:self.resource forKey:@"resource"];
     */
    
    /** 直接把model归档 ——> 存储到沙盒中 （会自动触发这个代理）
     [NSKeyedArchiver archiveRootObject:model toFile:@"/file/path"];
     */
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
    
    /** 非Runtime 解档写法  YYModel方法  - (id)yy_modelInitWithCoder:(NSCoder *)aDecoder;
     self.songTotalArrayOne = [aDecoder decodeObjectForKey:@"songTotalArrayOne"];
     self.songTotalArrayTwo = [aDecoder decodeObjectForKey:@"songTotalArrayTwo"];
     self.songTotalArrayThr = [aDecoder decodeObjectForKey:@"songTotalArrayThr"];
     */
    
    /** 这个类方法更快 不带key 直接从沙盒文件读取 （会自动触发代理）
     id model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
     */
}

@end
