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


/**
 
 //创建默认文件管理器
 @property (class, readonly, strong) NSFileManager *defaultManager;
 
 //返回一个在计算机可用卷上的NSURL数组
 - (nullable NSArray<NSURL *> *)mountedVolumeURLsIncludingResourceValuesForKeys:(nullable NSArray<NSURLResourceKey> *)propertyKeys options:(NSVolumeEnumerationOptions)options;
 
 //卸载指定的url路径
 - (void)unmountVolumeAtURL:(NSURL *)url options:(NSFileManagerUnmountOptions)mask completionHandler:(void (^)(NSError * _Nullable errorOrNil))completionHandler;
 
 //枚举一个url路径下的文件，返回一个url数组
 - (nullable NSArray<NSURL *> *)contentsOfDirectoryAtURL:(NSURL *)url includingPropertiesForKeys:(nullable NSArray<NSURLResourceKey> *)keys options:(NSDirectoryEnumerationOptions)mask error:(NSError **)error;
 
 
 //返回一个路径下的NSURL数组
 - (NSArray<NSURL *> *)URLsForDirectory:(NSSearchPathDirectory)directory inDomains:(NSSearchPathDomainMask)domainMask;
 
 
 - (nullable NSURL *)URLForDirectory:(NSSearchPathDirectory)directory inDomain:(NSSearchPathDomainMask)domain appropriateForURL:(nullable NSURL *)url create:(BOOL)shouldCreate error:(NSError **)error;
 
 // 两个文件的关系
 - (BOOL)getRelationship:(NSURLRelationship *)outRelationship ofDirectoryAtURL:(NSURL *)directoryURL toItemAtURL:(NSURL *)otherURL error:(NSError **)error;
 
 // 文件和指定系统路径之间的关系
 - (BOOL)getRelationship:(NSURLRelationship *)outRelationship ofDirectory:(NSSearchPathDirectory)directory inDomain:(NSSearchPathDomainMask)domainMask toItemAtURL:(NSURL *)url error:(NSError **)error;
 
 //创建目录 withIntermediatetDirectories:YES 创建额外需要的文件夹，创建父目录不存在的子目录，自动将父目录创建
 - (BOOL)createDirectoryAtURL:(NSURL *)url withIntermediateDirectories:(BOOL)createIntermediates attributes:(nullable NSDictionary<NSFileAttributeKey, id> *)attributes error:(NSError **)error;
 
 //在指定的网址创建一个指定的指向某个项目的符号链接。
 - (BOOL)createSymbolicLinkAtURL:(NSURL *)url withDestinationURL:(NSURL *)destURL error:(NSError **)error;
 
 //设置指定的文件或目录的属性
 - (BOOL)setAttributes:(NSDictionary<NSFileAttributeKey, id> *)attributes ofItemAtPath:(NSString *)path error:(NSError **)error;
 
 //创建文件夹
 @param path 要创建文件夹的路径
 @param createIntermediates 是否创建中间文件夹 经过实验发现 如 @"/Users/plyn/Desktop/实验4/shiyan" 路径中/实验4/shiyan本来是不存在的 如果这个参数是YES则可以成功地创建这个路径地文件夹；如果传NO则无法创建
 @param attribute 创建文件夹属性  传nil地话系统会自动创建
 @param error 错误信息
 - (BOOL)createDirectoryAtPath:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(nullable NSDictionary<NSFileAttributeKey, id> *)attributes error:(NSError **)error;
 
 //获取文件夹里面的文件名 非递归
 - (nullable NSArray<NSString *> *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error;
 
 //获取文件夹里面的文件名 递归的，及返回子文件夹的子文件名
 - (nullable NSArray<NSString *> *)subpathsOfDirectoryAtPath:(NSString *)path error:(NSError **)error;
 
 //给定路径中的项目的属性
 - (nullable NSDictionary<NSFileAttributeKey, id> *)attributesOfItemAtPath:(NSString *)path error:(NSError **)error;
 
 //获取文件夹的属性
 - (nullable NSDictionary<NSFileAttributeKey, id> *)attributesOfFileSystemForPath:(NSString *)path error:(NSError **)error;
 
 可通过以下方法获取相关属性
 @interface NSDictionary (NSFileAttributes)
 - (unsigned long long)fileSize;        //文件大小
 - (NSDate *)fileModificationDate;      //文件的修改时间
 - (NSString *)fileType;                //文件类型
 - (NSUInteger)filePosixPermissions;
 - (NSString *)fileOwnerAccountName;    //文件拥有者
 - (NSString *)fileGroupOwnerAccountName;
 - (NSInteger)fileSystemNumber;
 - (NSUInteger)fileSystemFileNumber;
 - (BOOL)fileExtensionHidden;
 - (OSType)fileHFSCreatorCode;
 - (OSType)fileHFSTypeCode;
 - (BOOL)fileIsImmutable;
 - (BOOL)fileIsAppendOnly;
 - (NSDate *)fileCreationDate;        //创建时间
 - (NSNumber *)fileOwnerAccountID;
 - (NSNumber *)fileGroupOwnerAccountID;
 @end
 
 //创建指向指定目的地的符号链接。
 - (BOOL)createSymbolicLinkAtPath:(NSString *)path withDestinationPath:(NSString *)destPath error:(NSError **)error;
 
 //在指定的路径上创建项目之间的硬连接
 - (nullable NSString *)destinationOfSymbolicLinkAtPath:(NSString *)path error:(NSError **)error;
 //拷贝文件
 - (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error;
 //移动
 - (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error;
 //在指定的文件之间创建一个硬链接
 - (BOOL)linkItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error;
 //删除
 - (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error;
 
 //拷贝文件
 - (BOOL)copyItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError **)error;
 //移动
 - (BOOL)moveItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError **)error;
 //在指定的网址的项目之间创建一个硬链接
 - (BOOL)linkItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError **)error;
 //删除
 - (BOOL)removeItemAtURL:(NSURL *)URL error:(NSError **)error;
 
 
 - (BOOL)trashItemAtURL:(NSURL *)url resultingItemURL:(NSURL * _Nullable * _Nullable)outResultingURL error:(NSError **)error;
 
 //获取文件属性
 - (nullable NSDictionary *)fileAttributesAtPath:(NSString *)path traverseLink:(BOOL)yorn ;
 - (BOOL)changeFileAttributes:(NSDictionary *)attributes atPath:(NSString *)path;
 - (nullable NSArray *)directoryContentsAtPath:(NSString *)path;
 - (nullable NSDictionary *)fileSystemAttributesAtPath:(NSString *)path;
 - (nullable NSString *)pathContentOfSymbolicLinkAtPath:(NSString *)path;
 - (BOOL)createSymbolicLinkAtPath:(NSString *)path pathContent:(NSString *)otherpath;
 - (BOOL)createDirectoryAtPath:(NSString *)path attributes:(NSDictionary *)attributes;
 
 
 - (BOOL)linkPath:(NSString *)src toPath:(NSString *)dest handler:(nullable id)handler;
 - (BOOL)copyPath:(NSString *)src toPath:(NSString *)dest handler:(nullable id)handler;
 - (BOOL)movePath:(NSString *)src toPath:(NSString *)dest handler:(nullable id)handler;
 - (BOOL)removeFileAtPath:(NSString *)path handler:(nullable id)handler;
 
 
 // 改变当前工作目录到指定的文件夹
 - (BOOL)changeCurrentDirectoryPath:(NSString *)path;
 //指定路径是否存在
 - (BOOL)fileExistsAtPath:(NSString *)path;
 - (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(nullable BOOL *)isDirectory;
 //指定文件是否可读
 - (BOOL)isReadableFileAtPath:(NSString *)path;
 //指定文件是否可写
 - (BOOL)isWritableFileAtPath:(NSString *)path;
 //指定文件是否可执行
 - (BOOL)isExecutableFileAtPath:(NSString *)path;
 //指定文件是否可删除
 - (BOOL)isDeletableFileAtPath:(NSString *)path;
 // 比较两个路径所指向的文件内容是否一样
 - (BOOL)contentsEqualAtPath:(NSString *)path1 andPath:(NSString *)path2;
 //提取文件名或者文件夹名
 - (NSString *)displayNameAtPath:(NSString *)path;
 //获取path地址 每一层的名称 以数组保存
 - (nullable NSArray<NSString *> *)componentsToDisplayForPath:(NSString *)path;
 
 //列出文件夹内容时
 - (nullable NSDirectoryEnumerator<NSString *> *)enumeratorAtPath:(NSString *)path;
 
 - (nullable NSDirectoryEnumerator<NSURL *> *)enumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(nullable NSArray<NSURLResourceKey> *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(nullable BOOL (^)(NSURL *url, NSError *error))handler ;
 
 //获得该路径下的所有文件和文件夹路径
 - (nullable NSArray<NSString *> *)subpathsAtPath:(NSString *)path;
 
 //获取路径文件内容
 - (nullable NSData *)contentsAtPath:(NSString *)path;
 //创建文件
 - (BOOL)createFileAtPath:(NSString *)path contents:(nullable NSData *)data attributes:(nullable NSDictionary<NSFileAttributeKey, id> *)attr;
 
 // 路径转char
 - (const char *)fileSystemRepresentationWithPath:(NSString *)path NS_RETURNS_INNER_POINTER;
 
 // 从char中获取指定长度的路径
 - (NSString *)stringWithFileSystemRepresentation:(const char *)str length:(NSUInteger)len;
 
 //用一个文件替换另一个文件
 - (BOOL)replaceItemAtURL:(NSURL *)originalItemURL withItemAtURL:(NSURL *)newItemURL backupItemName:(nullable NSString *)backupItemName options:(NSFileManagerItemReplacementOptions)options resultingItemURL:(NSURL * _Nullable * _Nullable)resultingURL error:(NSError **)error;
 
 // 移动文件到云中
 /// - parameter flag : true移动到云中,false从云中删除
 /// - parameter itemAtURL : 本地路径
 /// - parameter destinationURL : 云路径
 - (BOOL)setUbiquitous:(BOOL)flag itemAtURL:(NSURL *)url destinationURL:(NSURL *)destinationURL error:(NSError **)error;
 
 //是否该项目是针对存储在iCloud
 - (BOOL)isUbiquitousItemAtURL:(NSURL *)url;
 
 // 从云中下载文件
 - (BOOL)startDownloadingUbiquitousItemAtURL:(NSURL *)url error:(NSError **)error;
 
 // 删除云对应的本地副本
 - (BOOL)evictUbiquitousItemAtURL:(NSURL *)url error:(NSError *)error;
 
 /// 生成云的url，可在浏览器中下载
 - (nullable NSURL *)URLForUbiquityContainerIdentifier:(nullable NSString *)containerIdentifier;
 
 /// 生成云的url，可在浏览器中下载并且设置截止日期
 - (nullable NSURL *)URLForPublishingUbiquitousItemAtURL:(NSURL *)url expirationDate:(NSDate * _Nullable * _Nullable)outDate error:(NSError **)error;
 
 
 - (void)getFileProviderServicesForItemAtURL:(NSURL *)url completionHandler:(void (^)(NSDictionary <NSFileProviderServiceName, NSFileProviderService *> * _Nullable services, NSError * _Nullable error))completionHandler;
 
 //访问共享数据区
 - (nullable NSURL *)containerURLForSecurityApplicationGroupIdentifier:(NSString *)groupIdentifier
 
 - (nullable NSURL *)homeDirectoryForUser:(NSString *)userName;
 
 */





