//
//  GFSandFileOperation.m
//  GFAPP
//
//  Created by XinKun on 2017/11/28.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFSandFileOperation.h"

@implementation GFSandFileOperation

#pragma mark - 归档&&解档
- (void)file_ArchiveModel:(id)model withKey:(NSString *)key{
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:model forKey:key];
    
    [archiver finishEncoding];
    
    [self file_WriteToDocumentPathWithfolderName:@"ArchiveModel" fileName:key fileData:data];
    
    //或者
    //    NSData *dt = [NSKeyedArchiver archivedDataWithRootObject:person];
    //    Person *per = [NSKeyedUnarchiver unarchiveObjectWithData:dt];
    
}

///解档
- (id)file_AanalysisModelWithKey:(NSString *)key{
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",kAPP_File_DocumentPath,key];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    id model = [unarchiver decodeObjectForKey:key];
    
    return model;
}

//保存到document文件下
- (void)file_WriteToDocumentPathWithfolderName:(NSString *)folderName fileName:(NSString *)fileName fileData:(NSData *)fileData{
    
    //NSString *docDirPath = NSHomeDirectory();
    //Caches/ImageCache
    //保存文件夹路径
    NSString *folderPath = [NSString stringWithFormat:@"%@/%@",kAPP_File_DocumentPath,folderName];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:folderPath]) {
        [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",folderPath,fileName];
    
    if ([fm fileExistsAtPath:filePath]) {
        //存在就移除
        [fm removeItemAtPath:filePath error:nil];
    }
    //写入
    [fileData writeToFile:filePath atomically:YES];
    /**
    //读取
    NSData *data = [NSData dataWithContentsOfFile:folderPath];
    //删除
    NSError *error;
    [fm removeItemAtPath:folderPath error:&error];
     */
    
    //@throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
}

//保存到cache文件下SDWebImage缓存图片文件下
- (void)file_WriteToCachPathWithfolderName:(NSString *)folderName fileName:(NSString *)fileName fileData:(NSData *)fileData{
    
    //NSString *docDirPath = NSHomeDirectory();
    //Caches/ImageCache
    //保存文件夹路径
    NSString *folderPath = [NSString stringWithFormat:@"%@/%@/%@",kAPP_File_CachePath,_kGlobal_SDWebImagePath,folderName];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:folderPath]) {
        [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",folderPath,fileName];
    
    if ([fm fileExistsAtPath:filePath]) {
        //存在就移除
        [fm removeItemAtPath:filePath error:nil];
    }
    [fileData writeToFile:filePath atomically:YES];
    
    //@throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
}

///获取沙盒文件
- (NSData *)file_GetFileFormSandWithPath:(NSString *)path{
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return data;
}

#pragma mark - 存储
//存储到UserDefault
- (void)file_SaveDataToUserDefault:(id)object withKey:(NSString *)key{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:object forKey:key];
    [user synchronize];
}
//从UserDefault取出
- (id)file_GetDataFormUserDefaultWithKey:(NSString *)key{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    id object = [user objectForKey:key];
    return object;
}


@end




