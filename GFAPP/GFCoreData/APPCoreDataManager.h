//
//  APPCoreDataManager.h
//  GFAPP
//  数据库 大管家
//  Created by XinKun on 2017/11/6.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UseService.h"//用户数据库

@interface APPCoreDataManager : NSObject

///加锁，防止多个线程访问
@property (atomic,strong) UseService *useService;


//数据库管理者单利类
+(APPCoreDataManager *)sharedInstance;



@end
