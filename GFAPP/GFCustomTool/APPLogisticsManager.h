//
//  APPLogisticsManager.h
//  GFAPP
//  后勤工具管理
//  Created by XinKun on 2017/11/14.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 重写系统按钮文字图片排版 */
#import "GFCustomImgTextButton.h"
/** 自定义按钮button */
#import "GFButton.h"

/** 公共方法操作 */
#import "GFFunctionMethod.h"

/** 沙盒文件操作 */
#import "GFSandFileOperation.h"
/** 图像操作 */
#import "GFImageOperation.h"
/** 消息提示 */
#import "GFNotifyMessage.h"


@interface APPLogisticsManager : NSObject

///公共的方法操作
@property (nonatomic,strong) GFFunctionMethod *functionMethod;

///沙盒文件操作者
@property (nonatomic,strong) GFSandFileOperation *sandFileOperation;

///图像处理者
@property (nonatomic,strong) GFImageOperation *imageOperation;

///消息提示
@property (nonatomic,strong) GFNotifyMessage *showMessage;


/**
 *  后勤管理者单例
 */
+ (APPLogisticsManager *)sharedInstance;





@end
