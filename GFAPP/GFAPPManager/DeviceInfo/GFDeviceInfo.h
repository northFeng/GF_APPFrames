//
//  GFDeviceInfo.h
//  GFAPP
//
//  Created by gaoyafeng on 2018/6/27.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFDeviceInfo : NSObject

+ (GFDeviceInfo *)sharedGFDeviceInfo;

// 取得手机唯一序列号,一旦安装了, 哪怕是App删除，下次得到的序列号也是唯一的
+ (NSString *) getSerialNo;

+ (NSArray *) getAllSerial;

//获取网络类型
+ (NSString *)getNetworkType;

///获取iOS版本号
+ (NSString *)getIOSVersion;

//客户端版本号
+(NSString *)getTheClientVersionNumber;

//分辨率
+ (NSString *)getTheResolutionOfThe;

//ip 地址
+ (NSString *)getDeviceIPAdress;

// 获取 wifimac 地址
+ (NSString *)getWiFiMac;

// 获取 mac地址
+ (NSString *)getMacAddress;

// 获取手机型号
+ (NSString *)iphoneType;

// 获取总内存大小
+ (NSString *)getTotalMemorySize;

// 获取当前可用内存
+ (NSString *)getAvailableMemorySize;

// 获取总磁盘容量
+(NSString *)getTotalDiskSize;

// 获取可用磁盘容量
+(NSString *)getAvailableDiskSize;

// 获取cpu
+ (NSString *)getCPUType;


@end
