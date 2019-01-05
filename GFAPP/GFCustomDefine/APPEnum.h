//
//  APPEnum.h
//  GFAPP
//  APP内 自定义枚举
//  Created by XinKun on 2017/11/9.
//  Copyright © 2017年 North_feng. All rights reserved.
//

/**
 *
 *  常量命名规则（驼峰式命名规则），所有的单词首字母大写和加上与类名有关的前缀:
 *
 */

#ifndef APPEnum_h
#define APPEnum_h


/**
 *  枚举
 */
typedef NS_ENUM(NSInteger,APPEnum) {
    /**
     *  未知
     */
    APPEnum_One = 0,
};

/**
 * 全局block回调
 * block会捕获外部对象指针进行拷贝，对象拥有的block在对象释放时，block会自动销毁，block里的对象也会销毁
 * 如果该对象没有销毁，该block拥有的对象要释放时！一定要释放block = nil !!!!否则block内拥有的对象不会释放！
 */
typedef void (^APPBackBlock)(BOOL result, id idObject);
/**
__weak typeof(student) weakSelf = student;

student.study = ^{
    __strong typeof(student) strongSelf = weakSelf;
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"my name is = %@",strongSelf.name);
    });
    
};
 */


/**
 *  用户性别
 */
typedef NS_ENUM(NSInteger,APPEnum_Sex) {
    /**
     *  未知
     */
    APPEnum_Sex_Unknown = 0,
    /**
     *  男
     */
    APPEnum_Sex_Sex_Man,
    /**
     *  女
     */
    APPEnum_Sex_Woman,
    /**
     *  保密
     */
    APPEnum_Sex_Secrecy,
};


#endif /* APPEnum_h */
