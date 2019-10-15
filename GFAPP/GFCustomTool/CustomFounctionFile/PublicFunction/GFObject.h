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
对象中 添加属性 系统会自动做的三件事：1、生成set和get方法声明
                              2、根据关键词 实现 set和get方法内部
                              3、生成成员变量！！

分类中可以添加实例方法、类方法、属性、协议。但是不能添加成员变量。 添加属性的话
只会生成!!!!!!—>set、get方法的声明  set/get内部不会实现！！！！（需要自己实现set/get方法内部方法—>相当于添加了两个 可以使用点语法!! 调用的方法）
也不会!! 生成下划线成员变量。只有使用runtime动态添加属性 才会生产 带下划线的成员变量！

分类加重复方法会覆盖旧的方法：系统是在运行时将分类中对应的实例方法、类方法等插入到了原来类或元类的方法列表中，且是在列表的前边！所以，方法调用时通过isa去对应的类或元类的列表中查找对应的方法时先查到的是分类中的方法！查到后就直接调用不在继续查找。这即是’覆盖’的本质！

多个分类调用顺序：这个是与编译顺序有关，最后编译的分类中对应的信息会在整合在类或元类对应列表的最前边。所以是调用最后编译的分类中的方法！可以查看Build Phases ->Complie Source 中的编译顺序！
 
 总结：分类 和 代理 中添加属性 ——>只能起到第一种作业，系统会自动声明 set和get 方法 ！！ 但是不会内部 不会实现!!，也不会生成  成员变量!!
*/

/**
GFObject *demo = [[GFObject alloc] init];
 
demo.name = @"肖大宝";
demo.age = @"20";
demo.score = @"100";

//--->肖大宝-->20岁-->100分--->很好
NSLog(@"--->%@-->%@岁-->%@分--->%@",demo.name,demo.age,demo.score,demo.message);
*/
