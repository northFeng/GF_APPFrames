//
//  UseService.h
//  GFAPP
//  用户数据表单
//  Created by XinKun on 2017/11/6.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

//引入coredata头文件 APP创建勾选数据库，（创建四个文件，然后再删除！不知道为什么，创建工程时选中数据库，则必须这样操作）
#import "UseDemo+CoreDataClass.h"
#import "UseDemo+CoreDataProperties.h"

#import "Userone+CoreDataClass.h"

//外部数据model
#import "UseModel.h"

@interface UseService : NSObject

+ (UseService *)sharedService;




/**
 *  获取数据库所有数据
 *
 *  @return 数据数组
 */
- (NSArray *)getAllData;



/**
 *  显示单条数据
 *
 *  @userId 用户ID
 *  @floderId 文件夹ID
 *
 *  @return model
 */
- (UseModel *)getOneInfoUserId:(NSString *)userId;



/**
 *  添加单个收藏夹信息
 *
 *  @bookInfoModel 图书model
 *
 *  @return 是否添加成功
 */
- (BOOL)addModelInfo:(UseModel *)modelInfo;




/**
 *  删除单个收藏夹
 *
 *  @userId 用户ID
 *
 *  @return YES/NO
 */
- (BOOL)removeEntityByUserId:(NSString *)userId;



/**
 *  修改单个收藏夹
 *
 *
 *  @return YES/NO
 */
- (BOOL)updateEntityByModel:(UseModel *)modelInfo;



/**
 *  删除数据库表所有数据
 */
- (void)removeAllData;





@end
