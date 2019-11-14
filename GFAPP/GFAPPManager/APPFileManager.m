//
//  APPFileManager.m
//  GFAPP
//
//  Created by 峰 on 2019/11/14.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "APPFileManager.h"

@implementation APPFileManager

///创建路径
+ (void)createFilePath:(NSString *)filePath {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:filePath]) {
        [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

///获取某文件夹的大小
+ (NSUInteger)getFolderSizeOfPath:(NSString *)folderPath {
    NSUInteger size = 0;
    
   NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:folderPath error:nil];
   size += [attrs fileSize];
    
    return size;
}

///获取文件大小
+ (NSUInteger)getFileSizeOfPath:(NSString *)filePath {
   
    NSUInteger size = 0;
    
    NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    size = [attrs fileSize];
    
    return size;
}


///遍历文件下所有文件计算大小
+ (NSUInteger)getSizeOfFolderPath:(NSString *)folderPath {
    NSUInteger size = 0;
    
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:folderPath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}



@end
