//
//  GFNetDataRequest.h
//  GFNetWorkRequest
//  网络请求 大管家
//  Created by XinKun on 2017/8/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFNetworkDefine.h"//网络请求的宏文件

#import "GFBaseNetRequest.h"//基本网络接口
/** 图书数据接口 */
#import "GFBookService.h"

@interface APPNetRequestManager : NSObject

//*****************  网络监测管理  *****************

///网络状态
@property (nonatomic,assign) GFNetworkStatus networkStatus;

///网络状态描述
@property (nonatomic,copy) NSString *networkStatueDescribe;

///APP访问网络主路径
@property (nonatomic,copy) NSString *netHostUrl;

///网络类接口
@property (nonatomic,strong) GFNetRequest *netRequest;


//*****************  下面是各个视图的数据请求接口  *****************
///基本接口类
@property (nonatomic,strong) GFBaseNetRequest *baseNetRequest;

///图书接口类
@property (nonatomic,strong) GFBookService *bookService;




/**
 *  网络管理者单例
 */
+ (instancetype)sharedInstance;





@end
