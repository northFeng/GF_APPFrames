//
//  NSObject+GFExtension.h
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/22.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GFExtension)


/**
 *  @brief 深拷贝对象
 *
 */
- (id)gf_deepCopy:(id)idObject;


///分类添加属性
@property (nonatomic, strong) NSString *strDescribe;

/**
 对象中 添加属性 系统会自动做的三件事：1、生成set和get方法声明
                               2、根据关键词 实现 set和get方法内部
                               3、生成成员变量！！
 
 分类中可以添加实例方法、类方法、属性、协议。但是不能添加成员变量。 添加属性的话
 只会生成!!!!!!—>set、get方法的声明  set/get内部不会实现！！！！（需要自己实现set/get方法内部方法—>相当于添加了两个 可以使用点语法!! 调用的方法）
 也不会!! 生成下划线成员变量。只有使用runtime动态添加属性 才会生产 带下划线的成员变量！
 
 分类加重复方法会覆盖旧的方法：系统是在运行时将分类中对应的实例方法、类方法等插入到了原来类或元类的方法列表中，且是在列表的前边！所以，方法调用时通过isa去对应的类或元类的列表中查找对应的方法时先查到的是分类中的方法！查到后就直接调用不在继续查找。这即是’覆盖’的本质！
 
 多个分类调用顺序：这个是与编译顺序有关，最后编译的分类中对应的信息会在整合在类或元类对应列表的最前边。所以是调用最后编译的分类中的方法！可以查看Build Phases ->Complie Source 中的编译顺序！
 */


@end

NS_ASSUME_NONNULL_END
