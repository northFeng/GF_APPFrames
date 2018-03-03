//
//  GFCodeArchive.h
//  GFAPP
//  归档打包数据
//  Created by XinKun on 2018/2/18.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFCodeArchive : NSObject <NSCoding>


///设置过滤不需要的归档的属性
- (NSArray *)ignoredNames;

///归档
- (void)encode:(NSCoder *)aCoder;

///解档
- (void)decode:(NSCoder *)aDecoder;

@end


/** 使用方法：在需要归解档的对象中实现下面方法即可
// 设置需要忽略的属性
- (NSArray *)ignoredNames {
    return @[@"bone"];
}

// 在系统方法内来调用我们的方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self decode:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self encode:aCoder];
}
 */
