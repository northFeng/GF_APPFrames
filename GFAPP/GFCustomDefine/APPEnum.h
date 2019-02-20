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

/**
一.枚举的几种写法

1.第一种写法

typedef enum

{
    
    XMGDemoTypeTop,
    
    XMGDemoTypeBottom,
    
}XMGDemoType;



2.第二种枚举,定义类型

typedef NS_ENUM(NSInteger,XMGType)

{
    
    XMGTypeTop,
    
    XMGTypeBottom,
    
};



3.第三种枚举 ,位移枚举

//一个参数可以传递多个值 ,如果枚举使用了位运算那么就可以使用并运算

//如果是位移枚举,观察第一个枚举值,如果该枚举值!=0 那么可以默认传0做参数,如果传0做参数,那么效率最高

typedef NS_OPTIONS(NSInteger, XMGActionType)

{
    
    XMGActionTypeTop = 1<<0, //1*2(0) =1  1左移0位
    
    XMGActionTypeBottom = 1<<1,//1*2(1)=2  1左移1位
    
    XMGActionTypeLeft = 1<<2,//1*2(2)=4    1左移2位
    
    XMGActionTypeRight = 1<<3,//8          1左移3位
    
};
 
 //位移原理
 是不是明白了？还不明白？那好，把2改为二进制形式”10"， ActionTypeUp     =  2 << 0，我们把”<<“右边的数字理解为”往左位移0位”，结果还是10，所以ActionTypeDown   =  2 << 1这个东西就应该是100，也就是4，以此类推。。。明白了吗？”<<“左边是位移的起点数，右边是位移偏移量，就这么简单。
 *
 *  准备：首先你要知道这些知识。
 *
 *  1、<< 是左移运算符 ： 用来将一个数的各二进制位全部左移若干位。
 *        举个栗子  ：0000 0001 代表 二进制中的 1
 *        左移一位    <<1
 *        就会变成  ：0000 0010 代表 二进制中的 2
 *        简便算法：8 << n的值为8*（2^n）
 *
 *  2、按位与运算 :&  1 & 1 = 1  1 & 0 = 0   0 & 0 = 0
 *        总结规则:有0则为0
 *
 *  3、按位或运算: |   1 | 1= 1  1 | 0 = 1  0 | 0= 0
 *        总结规则: 有1则为1
 *
 *  以上可以推导出：
 *  GHOpertionTypeUp ：     0000 0001
 *  GHOpertionTypeDown ：   0000 0010
 *  GHOpertionTypeLeft ：   0000 0100
 *  GHOpertionTypeRight ：  0000 1000
 *  依据3的知识可以得到以上按位或运算后的结果为 : 0000 1111
 *  依据2的知识当此值和GHOpertionTypeUp进行按位与运算时得到的结果为 : 0000 0001 即得到了GHOpertionTypeUp本身，以此类推
 *  综上所述可以解释位移枚举为什么可以一个参数可以传递多个值
 *

位移枚举已应用场景：
场景一
我们的代码如下：

if (type & ShareType_WeiXinGroup) {
    doShare1();
}


场景二

NSInteger fitableTypes = ShareType_WeiXinGroup | ShareType_WeiXinFriend | ShareType_QQAuthor | ShareType_QQShareQZone;
if (type & fitableTypes) {
    doShare1();
}

原理
其实就是简单的用了二进制中的位移运算（<<），&运算符以及 | 运算符
例如
##场景一
ShareType_Unknown = 1 << 0, 二进制的表示为 01
ShareType_WeiXinGroup = 1 << 1, 二进制的表示为 10

ShareType_Unknown & ShareType_WeiXinGroup
01
10
二进制每一位进行&运算 结果为 00 判断不通过

ShareType_WeiXinGroup & ShareType_WeiXinGroup
10
10
二进制每一位进行&运算 结果为 10 判断通过

##场景二
ShareType_WeiXinGroup | ShareType_WeiXinFriend | ShareType_QQAuthor | ShareType_QQShareQZone
0000010
0000100
0100000
1000000
二进制每一位进行|运算 结果为1100110 记为A

ShareType_WeiXinGroup & A 二进制每一位进行&运算 结果为0000010 判断通过
ShareType_link & A 二进制每一位进行&运算00000000 判断不通过
 
 */


#endif /* APPEnum_h */
