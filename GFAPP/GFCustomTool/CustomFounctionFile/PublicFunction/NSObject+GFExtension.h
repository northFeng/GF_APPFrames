//
//  NSObject+GFExtension.h
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/22.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GFExtension)


/**
 *  @brief 深拷贝对象
 *
 */
- (id)gf_deepCopy:(id)idObject;





@end

NS_ASSUME_NONNULL_END
