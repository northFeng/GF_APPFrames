//
//  APPLogisticsManager.m
//  GFAPP
//
//  Created by XinKun on 2017/11/14.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "APPLogisticsManager.h"

@implementation APPLogisticsManager

- (void)dealloc{
    
    self.functionMethod = nil;
    self.sandFileOperation = nil;
    self.imageOperation = nil;
    self.showMessage = nil;
}

+ (APPLogisticsManager *)sharedInstance
{
    static APPLogisticsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APPLogisticsManager alloc] init];
    });
    return manager;
}

#pragma mark - 公共方法操作
- (GFFunctionMethod *)functionMethod{
    if (_functionMethod == nil) {
        _functionMethod = [[GFFunctionMethod alloc] init];
    }
    return _functionMethod;
}

#pragma mark - 沙盒文件操作
- (GFSandFileOperation *)sandFileOperation{
    if (_sandFileOperation == nil) {
        _sandFileOperation = [[GFSandFileOperation alloc] init];
    }
    return _sandFileOperation;
}

#pragma mark - 消息提示
- (GFNotifyMessage *)showMessage{
    if (_showMessage == nil) {
        _showMessage = [[GFNotifyMessage alloc] init];
    }
    return _showMessage;
}

#pragma mark - 图片操作
//采用懒加载
- (GFImageOperation *)imageOperation{
    if (_imageOperation == nil) {
        _imageOperation = [[GFImageOperation alloc] init];
    }
    return _imageOperation;
}




@end
