//
//  GFNetDataRequest.m
//  GFNetWorkRequest
//
//  Created by XinKun on 2017/8/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "APPNetRequestManager.h"

@implementation APPNetRequestManager

/// 加 线程锁
@synthesize bookService = _bookService;


///销毁实例
- (void)dealloc {

    _bookService = nil;
    
}

/**
 *  网络管理器单例
 */
+ (instancetype)sharedInstance{

    static APPNetRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APPNetRequestManager alloc] init];
    });
    return manager;
}

- (instancetype)init {

    if ([super init]) {
        //网络初始化
        _netRequest = [GFNetRequest sharedInstance];
        //网络主路径
        _netHostUrl = [_netRequest hostUrl];
        
        //******************************
        _baseNetRequest = [[GFBaseNetRequest alloc] init];
        //图书接口初始化
        _bookService = [[GFBookService alloc] init];
        
    }
    return self;
}


///重写networkStatus属性get方法
- (GFNetworkStatus)networkStatus{
    
    _networkStatus = [self.netRequest getNetworkStatus];
    
    return _networkStatus;
}

///重写networkStatueDescribe属性get方法
- (NSString *)networkStatueDescribe{
    
    _networkStatueDescribe = [self.netRequest getNetworkStatusName];
    
    return _networkStatueDescribe;
}

///获取主路径
- (NSString *)netHostUrl{
    _netHostUrl = [self.netRequest hostUrl];
    return _netHostUrl;
}




@end
