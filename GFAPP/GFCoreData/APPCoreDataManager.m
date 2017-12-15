//
//  APPCoreDataManager.m
//  GFAPP
//
//  Created by XinKun on 2017/11/6.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "APPCoreDataManager.h"

@implementation APPCoreDataManager

+ (APPCoreDataManager *)sharedInstance
{
    static APPCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APPCoreDataManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    
    if ([super init]) {
        
        //创建数据库操作
        _useService = [UseService sharedService];
        
    }
    return self;
}


@end
