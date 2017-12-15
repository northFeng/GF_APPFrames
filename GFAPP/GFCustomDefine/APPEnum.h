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
 *  用户性别
 */
typedef NS_ENUM(NSInteger,APPSex) {
    /**
     *  未知
     */
    APP_Sex_Unknown = 0,
    /**
     *  男
     */
    APP_Sex_Man,
    /**
     *  女
     */
    APP_Sex_Woman,
    /**
     *  保密
     */
    APP_Sex_Secrecy,
};




#endif /* APPEnum_h */
