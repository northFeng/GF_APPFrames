//
//  UseModel.h
//  GFAPP
//
//  Created by XinKun on 2017/11/6.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UseModel : NSObject

///用户ID
@property (nonatomic,copy) NSString *userId;

///文件夹名字
@property (nonatomic,copy) NSString *name;

///文件夹创建时间
@property (nonatomic,copy) NSString *createDate;

@end
