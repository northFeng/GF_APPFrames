//
//  GFObject.h
//  Demo
//
//  Created by 峰 on 2019/10/15.
//  Copyright © 2019 峰. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@protocol GFDelegate <NSObject>

///代理中添加属性 名字  @dynamic 手动实现
@property (nonatomic,copy) NSString *name;

///代理中添加属性 年龄  @synthesize 自动实现
@property (nonatomic,copy) NSString *age;

@end

@interface GFObject : NSObject <GFDelegate>


+ (void)a123;


@end

#pragma mark - 分类
@interface GFObject (Category)

///评语  不使用runtime   点语法 调用 set和get 方法
@property (nonatomic,copy) NSString *message;

///分类添加属性   使用runtime  动态添加 成员变量
@property (nonatomic,copy) NSString *score;


+ (void)a123;

@end



NS_ASSUME_NONNULL_END

/**
GFObject *demo = [[GFObject alloc] init];
 
demo.name = @"肖大宝";
demo.age = @"20";
demo.score = @"100";

//--->肖大宝-->20岁-->100分--->很好
NSLog(@"--->%@-->%@岁-->%@分--->%@",demo.name,demo.age,demo.score,demo.message);
*/
