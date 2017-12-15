//
//  GFCoreData.h
//  GFAPP
//  数据库 大会计（数据库上下文）
//  Created by XinKun on 2017/11/6.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>


@interface GFCoreData : NSObject

//单利类
+(GFCoreData *)shareInstance;

//保存到数据库
- (void)save;

//管理对象上下文
//这里声明为readonly的目的主要是重写get方法使其成为计算型属性
@property(nonatomic,strong,readonly)NSManagedObjectContext *managedObjectContext;

/**
    iOS10之后多线程处理用此方法
    通过方法返回iOS10的NSPersistentContainer
    如果是iOS9，则返回nil
    该方法的目的主要是便于使用ios10的多线程操作数据库
*/
- (NSPersistentContainer *)getCurrentPersistentContainer;



@end
