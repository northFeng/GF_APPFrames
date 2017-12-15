//
//  GFSandFileOperation.h
//  GFAPP
//
//  Created by XinKun on 2017/11/28.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFSandFileOperation : NSObject

#pragma mark - 归档&&解档

/**
 *  @brief 归档(默认保存到document文件下)
 *
 *  @param model 归档的对象
 *  @param key 归档&&接档 钥匙
 */
- (void)file_ArchiveModel:(id)model withKey:(NSString *)key;

/**
 *  @brief 解档
 *
 *  @param key 解档 钥匙
 *  @return 返回类的对象
 */
- (id)file_AanalysisModelWithKey:(NSString *)key;

/**
 *  @brief 保存到document文件下
 *
 *  @param folderName  document下的子文件夹
 *  @param fileName  保存的文件的名字
 *  @param fileData  保存文件的data
 */
- (void)file_WriteToDocumentPathWithfolderName:(NSString *)folderName fileName:(NSString *)fileName fileData:(NSData *)fileData;

/**
 *  @brief 保存到cache文件下SDWebImage缓存图片文件下
 *
 *  @param folderName  SDWebImage缓存图片路径下的子文件夹
 *  @param fileName  保存的文件的名字
 *  @param fileData  保存文件的data
 */
- (void)file_WriteToCachPathWithfolderName:(NSString *)folderName fileName:(NSString *)fileName fileData:(NSData *)fileData;


/**
 *  @brief 获取沙盒文件
 *
 *  @param path  保存文件的路径
 */
- (NSData *)file_GetFileFormSandWithPath:(NSString *)path;


#pragma mark - 存储UserDefault
/**
 *  @brief 存储到UserDefault
 *
 *  @param object 存储对象（NSString,NSArray,NSDictionary,NSNumber,NSData）
 *  @param key 存储的钥匙
 */
- (void)file_SaveDataToUserDefault:(id)object withKey:(NSString *)key;

/**
 *  @brief 从UserDefault取出
 *
 *  @param key 取出的钥匙
 */
- (id)file_GetDataFormUserDefaultWithKey:(NSString *)key;

@end
