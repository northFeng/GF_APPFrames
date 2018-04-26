//
//  APPSystemDefine.h
//  GFAPP
//
//  Created by XinKun on 2017/11/10.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#ifndef APPSystemDefine_h
#define APPSystemDefine_h


#pragma mark - 系统宏定义
//***********************************************
//**********      日志输出宏定义      *************
//***********************************************
//relese模式下不打印
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

/**
//宏定义 nslog ------>会输出哪一个视图哪一个行
#ifdef DEBUG
#define NSLog(fmt,...) NSLog((@"--> %s line--%d " fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define NSLog(fmt,...)
#endif
 */

#pragma mark - 系统方法宏定义
//***********************************************
//**********      系统方法宏定义      *************
//***********************************************
#define APPNotificationCenter [NSNotificationCenter defaultCenter]
#define APPUserDefault [NSUserDefaults standardUserDefaults]
//************* 定义UIImage对象 *************
//图标切图使用此方法
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]
//大的图片，不常用的图片用此方法
#define ImageFile(imgName,imgType) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:imgType]];

//#define XKValue(x) x ? x:@""
//#define XKShareContent(str) str ? str:@"有思想的法律阅读"

//屏幕适配(以iPhone6为基准)
//#define APP_SCREEN_ADAPTIVE(x) (iPhone6Plus?(ceil(x * 1.5)):(ceil(x)))
//#define APP_SCREEN_ADAPTIVE_HEIGHT(x) (iPhone6Plus?(ceil(x*1.5)):(iPhone6?(ceil(x)):(ceil(x))))
//#define APP_WIDTH_SCALE(x) (ceil((x) * (APP_CONTENT_WIDTH) / 750.))
//#define APP_HEIGHT_SCALE(x) (ceil((x) * (APP_SCREEN_HEIGHT) / 1334.))

#pragma mark - 手机型号、系统版本判断
//***********************************************
//**********      手机型号、系统版本判断      *************
//***********************************************
//ios操作系统判断
#define IOS7  ([[[UIDevice currentDevice] systemVersion] integerValue] == 7)
#define IOS8  ([[[UIDevice currentDevice] systemVersion] integerValue] == 8)
#define IOS9  ([[[UIDevice currentDevice] systemVersion] integerValue] == 9)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] integerValue] == 10)
#define IOS11 ([[[UIDevice currentDevice] systemVersion] integerValue] == 11)

#define IOSLess9 ([[[UIDevice currentDevice] systemVersion] integerValue] < 9)
#define IOSLess10 ([[[UIDevice currentDevice] systemVersion] integerValue] < 10)
#define IOSLess11 ([[[UIDevice currentDevice] systemVersion] integerValue] < 11)

#define IOSAbove9 ([[[UIDevice currentDevice] systemVersion] integerValue] >= 9)
#define IOSAbove10 ([[[UIDevice currentDevice] systemVersion] integerValue] >= 10)
//@available(iOS 11.0, *)
#define IOSAbove11 ([[[UIDevice currentDevice] systemVersion] integerValue] >= 11)


//按屏幕分辨率判断手机型号
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640,1136),[[UIScreen mainScreen] currentMode].size):NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(750,1334),[[UIScreen mainScreen] currentMode].size):NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1242,2208),[[UIScreen mainScreen] currentMode].size):NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1125,2436),[[UIScreen mainScreen] currentMode].size):NO)

#pragma mark - 手机信息/沙盒路径
//***********************************************
//**********      手机信息/沙盒路径      *************
//***********************************************
//APP版本号
#define kApp_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//系统版本号
#define kAPP_SystemVersion [[UIDevice currentDevice] systemVersion]
//获取当前语言
#define kAPP_CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//判断是否为iPhone
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define kISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//************ 以下路径末尾是不带 / 这个符号的 ************
//获取沙盒Document路径
#define kAPP_File_DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒Library路径
#define kAPP_File_LibraryPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒Cache路径
#define kAPP_File_CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒temp路径
#define kAPP_File_TempPath NSTemporaryDirectory()
//获取沙盒home路径
#define kAPP_File_HomePath NSHomeDirectory()



#endif /* APPSystemDefine_h */
