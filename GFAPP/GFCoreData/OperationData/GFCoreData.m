//
//  GFGFCoreData.m
//  GFAPP
//
//  Created by XinKun on 2017/11/6.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFCoreData.h"

#import <UIKit/UIKit.h>

@interface GFCoreData ()

//iOS9中 CoreData Stack核心的三个类
//管理模型文件上下文
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext1;
//模型文件
@property(nonatomic,strong)NSManagedObjectModel *managedObjectModel;
//存储调度器
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;

//iOS10中NSPersistentContainer
/**
 CoreData Stack容器
 内部包含：
 管理对象上下文：NSManagedObjectContext *viewContext;
 对象管理模型：NSManagedObjectModel *managedObjectModel
 存储调度器：NSPersistentStoreCoordinator *persistentStoreCoordinator;
 */
@property(nonatomic,strong) NSPersistentContainer *persistentContainer;

@end


@implementation GFCoreData

+ (GFCoreData *)shareInstance
{
    static GFCoreData *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GFCoreData alloc] init];
    });
    return manager;
}

#pragma mark -iOS8,iOS9 CoreData Stack


//懒加载managedObjectModel
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    //    //根据某个模型文件路径创建模型文件
    //    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Person" withExtension:@"momd"]];
    
    
    //合并Bundle所有.momd文件
    //budles: 指定为nil,自动从mainBundle里找所有.momd文件
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSAssert(_managedObjectModel != nil, @"初始化错误管理的对象模型");
    return _managedObjectModel;
    
}

#pragma mark - 懒加载persistentStoreCoordinator会调用懒加载managedObjectModel
//懒加载persistentStoreCoordinator
-(NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //根据模型文件创建存储调度器
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    /**
     *  给存储调度器添加存储器
     *
     *  tyep:存储类型
     *  configuration：配置信息 一般为nil
     *  options：属性信息  一般为nil
     *  URL：存储文件路径
     */
    //获取沙盒路径URL

    //先判断本地沙盒地址是否存在
    NSString *docDirPath = NSHomeDirectory();
    //Caches/ImageCache
    NSString *bookPath = [NSString stringWithFormat:@"%@/Library/Application Support", docDirPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    //判断路径是否存在
    if (![fm fileExistsAtPath:bookPath]) {
        //iOS10之后会自动创建该路径，iOS10之前，必须手动创建才能 保证 iOS9 升级到 iOS10 完成适配
        [fm createDirectoryAtPath:bookPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSURL *urlHost = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *url = [urlHost URLByAppendingPathComponent:@"Application Support/GFAPP.sqlite" isDirectory:YES];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
    NSError *error = nil;
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
    
    if (error!=nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"未能初始化应用程序的保存数据";
        dict[NSLocalizedFailureReasonErrorKey] = @"有一个错误创建或加载应用程序的保存数据";
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"未解决的错误： %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSLog(@"------存储路径：%@",_persistentStoreCoordinator.persistentStores[0].URL);
    
    return _persistentStoreCoordinator;
    
}

#pragma mark - 懒加载上下文会调用上线两个懒加载
//懒加载managedObjectContext
-(NSManagedObjectContext*)managedObjectContext1
{
    if (_managedObjectContext1 != nil) {
        return _managedObjectContext1;
    }
    
    //参数表示线程类型  NSPrivateQueueConcurrencyType比NSMainQueueConcurrencyType略有延迟
    _managedObjectContext1 = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //设置存储调度器
    [_managedObjectContext1 setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _managedObjectContext1;
}


#pragma mark -iOS10 CoreData Stack

@synthesize persistentContainer = _persistentContainer;
//懒加载NSPersistentContainer
- (NSPersistentContainer *)persistentContainer
{
    if(_persistentContainer != nil)
    {
        return _persistentContainer;
    }
    
    //1.创建对象管理模型
    //    //根据某个模型文件路径创建模型文件
    //    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Person" withExtension:@"momd"]];
    
    
    //合并Bundle所有.momd文件
    //budles: 指定为nil,自动从mainBundle里找所有.momd文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    
    //2.创建NSPersistentContainer
    /**
     * name:数据库文件名称
     */

    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"GFAPP" managedObjectModel:model];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}


#pragma mark - NSManagedObjectContext

//重写get方法
- (NSManagedObjectContext *)managedObjectContext
{
    //获取系统版本
    float systemNum = [[UIDevice currentDevice].systemVersion floatValue];
    
    //根据系统版本返回不同的NSManagedObjectContext
    if(systemNum < 10.0){
        //iOS10之前的上下文
        return self.managedObjectContext1;
    }else{
        //iOS10之后的上下文
        return self.persistentContainer.viewContext;
    }
}


- (NSPersistentContainer *)getCurrentPersistentContainer
{
    //获取系统版本
    float systemNum = [[UIDevice currentDevice].systemVersion floatValue];
    
    //根据系统版本返回不同的NSManagedObjectContext
    if(systemNum < 10.0)
    {
        return nil;
    }
    else
    {
        return self.persistentContainer;
    }
}

- (void)save{
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    if (error == nil) {
        NSLog(@"保存到数据库成功");
    }
    else
    {
        NSLog(@"保存到数据库失败：%@",error);
    }
}

@end


/*
//1.保存耗时操作之前的时间
NSDate *date = [NSDate date];
//2.创建一个新的多线程管理对象上下文
NSManagedObjectContext *context1 = [kHMCoreDataManager.persistentContainer newBackgroundContext];
//3.添加10万行数据
for(int i=0;i<100000;i++)
{
    //创建CoreData模型，注意这里的参数上下文是基于多线程的
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context1];
    //赋值
    person.name = @"坤哥";
    person.age = 18;
}


//4.开启异步多线程保存到数据库
[kHMCoreDataManager.persistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
    //这里不能使用block中的context，而必须要使用上面的context1（在哪一个上下文中添加，就在哪一个上下文中保存）
    [context1 save:nil];
}];

//5.获取耗时操作之后的时间
NSDate *date1 = [NSDate date];
//6.输出两个耗时操作的时间差
NSLog(@"%f",[date1 timeIntervalSinceDate:date]);

*/



