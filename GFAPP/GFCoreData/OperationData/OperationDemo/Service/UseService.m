//
//  UseService.m
//  GFAPP
//
//  Created by XinKun on 2017/11/6.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "UseService.h"

//上下文
#import "GFCoreData.h"

//实体类名字 (创建实体的名字)
#define Entity_Name @"UseDemo"

//******************* 取别名 **************
//数据库实体类
typedef UseDemo ENTITYClass;

//外部模型类
typedef UseModel ModelClass;

//******************* 取别名 **************

@implementation UseService

+ (UseService *)sharedService{
    
    static UseService *useService = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        useService = [[UseService alloc] init];
    });
    return useService;
}


/**
 *  获取数据库所有数据
 *
 *  @return 数据数组
 */
- (NSArray *)getAllData{
    NSArray *array = [self getAllEntity];
    NSMutableArray *mArray = [NSMutableArray array];
    for (ENTITYClass *entity in array) {
        //赋值数据
        ModelClass *modelInfo = [[ModelClass alloc] init];
        modelInfo.userId = entity.userId;
        modelInfo.name = entity.name;
        modelInfo.createDate = entity.createDate;
        
        [mArray addObject:modelInfo];
    }
    
    return mArray;
}

/**
 *  显示单条数据
 *
 *  @userId 用户ID
 *  @floderId 文件夹ID
 *
 *  @return model
 */
- (ModelClass *)getOneInfoUserId:(NSString *)userId{
    
    ENTITYClass *entity = [self getOneEntityUserId:userId];
    if (entity != nil) {
        ModelClass *modelInfo = [[ModelClass alloc] init];
        modelInfo.userId = entity.userId;
        modelInfo.name = entity.name;
        modelInfo.createDate = entity.createDate;
        
        return modelInfo;
    }
    
    return nil;
}

/**
 *  添加单个收藏夹信息
 *
 *  @bookInfoModel 图书model
 *
 *  @return 是否添加成功
 */
- (BOOL)addModelInfo:(ModelClass *)modelInfo{
    
    __block BOOL isSuccess = NO;
    ENTITYClass *entity = [self getOneEntityUserId:modelInfo.userId];
    
    
    if (entity) {
        NSLog(@"addCase这不科学");
        //查到的话就更新
        isSuccess = [self updateOneEntity:entity modelInfo:modelInfo];
        
    }else {
        //查询不到就添加
        isSuccess =  [self addOneEntity:modelInfo];
    }
    
    return isSuccess;
}

/**
 *  删除单个收藏夹
 *
 *  @userId 用户ID
 *
 *  @return YES/NO
 */
- (BOOL)removeEntityByUserId:(NSString *)userId{
    
    
    ENTITYClass *entity = [self getOneEntityUserId:userId];
    
    BOOL isSuccess = [self removeOneEntity:entity];
    
    return isSuccess;
}


/**
 *  修改单个收藏夹
 *
 *
 *  @return YES/NO
 */
- (BOOL)updateEntityByModel:(ModelClass *)modelInfo{
    
    BOOL isSuccess = NO;
    
    ENTITYClass *entity = [self getOneEntityUserId:modelInfo.userId];
    
    isSuccess = [self updateOneEntity:entity modelInfo:modelInfo];
    
    return isSuccess;
}



/**
 *  删除数据库表所有数据
 */
- (void)removeAllData{
    
    [self removeAllEntity];
    
}





//****************************************************

#pragma mark - 数据库操作

///获取所有的实体
- (NSArray *)getAllEntity{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Entity_Name];
    
    NSError *error = nil;
    NSArray *array = [[self context] executeFetchRequest:request error:&error];
    
    if (!error) {
        if (array == nil || [array count] == 0) {
            return nil;
        }
    }
    NSAssert(array.count, @"Error fetching Students objects:Error Info：%@ \n",  [error localizedDescription]);
    
    return [array copy];
    
}

///查询某个实体
- (ENTITYClass *)getOneEntityUserId:(NSString *)userId{
    
    ENTITYClass *entity = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Entity_Name];
    //request.predicate = [NSPredicate predicateWithFormat:@"%K = %@ AND %K = %@",@"userId",userId,@"folderId",floderId];
    request.predicate = [NSPredicate predicateWithFormat:@"%K = %@",@"userId",userId];
    
    NSError *error = nil;
    NSArray *arrayResult = [[self context] executeFetchRequest:request error:&error];
    if (!error) {
        //        NSLog(@"case单条修改");
        entity = [arrayResult firstObject];
    }else {
        NSLog(@"select data Error,Error Info：%@", error.localizedDescription);
    }
    return entity;
}

///添加某个实体
- (BOOL)addOneEntity:(ModelClass *)modelInfo{
    
    BOOL isSuccess = NO;
    ENTITYClass *entity = [NSEntityDescription insertNewObjectForEntityForName:Entity_Name inManagedObjectContext:[self context]];
    
    //添加的信息 (改成字典转模型)
    entity.userId = modelInfo.userId;
    entity.name = modelInfo.name;
    entity.createDate = modelInfo.createDate;
    
    __block NSError *error = nil;
    isSuccess = [[self context] save:&error];

    NSAssert(isSuccess, @"Error info : %@\n",  [error userInfo]);
    return isSuccess;
}

///删除某个实体
- (BOOL)removeOneEntity:(ENTITYClass *)entity{
    
    BOOL isSuccess = NO;
    NSError *error = nil;
    
    if (entity) {
        //删除
        [[self context] deleteObject:entity];
        //保存
        isSuccess = [[self context] save:&error];
    }else{
        NSLog(@"查询的数据不存在，无法进行删除操作");
    }
    return isSuccess;
}


///更改某个实体
- (BOOL)updateOneEntity:(ENTITYClass *)entity modelInfo:(ModelClass *)model{
    
    NSError *error = nil;
    
    BOOL isSuccess = NO;
    if (entity) {
        //字典模型
        entity.userId = model.userId;
        entity.name = model.name;
        entity.createDate = model.createDate;
        
        isSuccess = [[self context] save:&error];
    }else {
        //        isSuccess =  [self addBook:book managedObjectContext:collectionMOC];
        NSLog(@"removeBookWithTypeId ：：未知错误");
    }
    
    return isSuccess;
    
}


///删除所有的实体
- (void)removeAllEntity{
    
    NSEntityDescription *description = [NSEntityDescription entityForName:Entity_Name inManagedObjectContext:[self context]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:description];
    NSError *error = nil;
    NSArray *data = [[self context] executeFetchRequest:request error:&error];
    if (!error &&data && [data count]) {
        for (NSManagedObject *obj in data) {
            [[self context] deleteObject:obj];
        }
        if (![[self context] save:&error]) {
            NSLog(@"error = %@",error.userInfo);
        }
    }
    
}


//获取数据库的上下文（iOS10之前和之后的都可获得）
- (NSManagedObjectContext *)context {
    
    return [GFCoreData shareInstance].managedObjectContext;
}


@end
