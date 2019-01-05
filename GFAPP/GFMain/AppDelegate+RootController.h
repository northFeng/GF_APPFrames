//
//  AppDelegate+RootController.h
//  GFAPP
//  代理进行扩展
//  Created by XinKun on 2017/11/11.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (RootController)

/**
 *  根视图
 */
- (void)setRootViewController;



@end


/**
 
 类别与扩展区别：
 
 类别：会生产.h和.m文件 ——> 只能给主类添加方法，不能添加实例变量 ！但是可添加属性（属性的本质——>set和get方法）
 
 扩展：没有名字的类别 ，1、单独写在一个.h文件中，扩展中的成员变量默认是私有的，属性和方法是公有的
                    2、将扩展写在主类的.m文件中，此时扩展中的成员变量、属性和方法都是私有的
                     扩展中的方法必须写在主类的.m文件中！！！
                     扩展中的成员变量默认是私有的，属性和方法是公有的
 
 */
