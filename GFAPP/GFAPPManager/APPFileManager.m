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

///清除文件
+ (void)removeFileOfPath:(NSString *)filePath {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
}

///获取某文件夹的大小
+ (void)getFolderSizeOfPath:(NSString *)folderPath endBlock:(APPBackBlock)blockEnd {
    
    [self getSizeOfFolderPath:folderPath endBlock:blockEnd];
}

///获取文件大小
+ (NSUInteger)getFileSizeOfPath:(NSString *)filePath {
   
    NSUInteger size = 0;
    
    NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    size = [attrs fileSize];
    
    return size;
}


///遍历文件下所有文件计算大小
+ (void)getSizeOfFolderPath:(NSString *)folderPath endBlock:(APPBackBlock)blockEnd {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUInteger size = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:folderPath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
            NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (blockEnd) {
                blockEnd(YES,@(size));
            }
        });
    });
}

///获取Cache文件大小
+ (void)getCacheFileSizeEndBlock:(APPBackBlock)blockEnd {
    
    NSString *filePath = kAPP_File_CachePath;
    [self getSizeOfFolderPath:filePath endBlock:blockEnd];
}

///清理Cache下的所有缓存
+ (void)clearDiskItemsOfCacheEndBlock:(APPBackBlock)blockEnd {
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSString *cachePath = kAPP_File_CachePath;
        NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];//返回这个路径下的所有文件的数组
        for (NSString *fileName in files) {

            NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
            
            [self removeFileOfPath:filePath];//清除文件
        }
        
        if (blockEnd) {
            blockEnd(YES,@0);
        }
    });
}



@end
