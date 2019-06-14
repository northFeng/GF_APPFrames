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

//扩展
#import "UIView+GFExtension.h"
#import "UILabel+Text.h"
#import "NSArray+GFExtension.h"
#import "NSMutableArray+GFExtension.h"


@interface APPLogisticsManager : NSObject

///公共的方法操作
@property (nonatomic,strong) GFFunctionMethod *functionMethod;

///沙盒文件操作者
@property (nonatomic,strong) GFSandFileOperation *sandFileOperation;

///图像处理者
@property (nonatomic,strong) GFImageOperation *imageOperation;

///消息提示
@property (nonatomic,strong) GFNotifyMessage *showMessage;

///安全类（手机是否越狱）
///手机信息查询
///手机各种权限查询


/**
 *  后勤管理者单例
 */
+ (APPLogisticsManager *)sharedInstance;





@end

/**
NSLog各种打印格式：

%@ 对象

%d, %i 整型 (%i的老写法)

%hd 短整型

%ld, %lld 长整型

%u 无符整型

%f 浮点型和double型

%0.2f 精度浮点数，只保留两位小数

%x 为32位的无符号整型数(unsigned int),打印使用数字0-9的十六进制,小写a-f;

%X 为32位的无符号整型数(unsigned int),打印使用数字0-9的十六进制,大写A-F;

%o 八进制

%zu size_t

%p 指针地址

%e float/double （科学计算）

%g float/double （科学技术法）

%s char *  字符串

%.*s Pascal字符串

%c char 字符

%C unichar

%Lf 64位double

%lu sizeof(i)内存中所占字节数

打印CGSize：NSLog(@"%@", NSStringFromCGSize(someCGSize));

打印CGRect：NSLog(@"%@", NSStringFromCGRect(someCGRect));
或者CFShow(NSStringFromCGRect(someCGRect));

 */
