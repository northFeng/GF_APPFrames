//
//  APPFileManager.h
//  GFAPP
//  文件管理
//  Created by 峰 on 2019/11/14.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPFileManager : NSObject

///创建路径
+ (void)createFilePath:(NSString *)filePath;


///获取某文件夹的大小
+ (NSUInteger)getFolderSizeOfPath:(NSString *)folderPath;

///获取文件大小
+ (NSUInteger)getFileSizeOfPath:(NSString *)filePath;

///遍历文件下所有文件计算大小
+ (NSUInteger)getSizeOfFolderPath:(NSString *)folderPath;


@end

NS_ASSUME_NONNULL_END
