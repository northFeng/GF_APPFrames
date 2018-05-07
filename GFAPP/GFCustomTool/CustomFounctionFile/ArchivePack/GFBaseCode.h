//
//  GFBaseCode.h
//  GFAPP
//  归档基类
//  Created by XinKun on 2018/2/18.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFBaseCode : NSObject <NSCoding>

///设置过滤不需要的归档的属性
- (NSArray *)ignoredNames;


@end


/** 使用方法：在需要归解档的对象中实现下面方法即可
// 设置需要忽略的属性
- (NSArray *)ignoredNames {
    return @[@"bone"];
}

 */
