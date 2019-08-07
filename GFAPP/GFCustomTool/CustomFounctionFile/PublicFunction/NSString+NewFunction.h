//
//  NSString+NewFunction.h
//  GFAPP
//
//  Created by 峰 on 2019/8/6.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NewFunction)

/**
 拼接字符串
 */
- (NSString *(^)(NSString *))append;


@end

NS_ASSUME_NONNULL_END
