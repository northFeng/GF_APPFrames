//
//  GFTimeOperation.h
//  GFAPP
//  时间操作
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFTimeOperation : NSObject

/**
 获取当前时间
 格式：yyyy-MM-dd HH:mm:ss ±HHMM
 其中 "±HHMM" 表示与GMT的存在多少小时多少分钟的时区差异。比如，若时区设置在北京，则 "±HHMM" 显示为 "+0800"
 */
+ (NSString *)getTimeWithFormatString:(NSString *)formateStr;


//将当前时间转化为年月日格式
+ (NSString *)getTimeByYearMonthDayHourWithDate:(NSDate *)date;


///获取从1970年到现在的时间戳
+ (NSTimeInterval)getTimeIntervalSince1970;

///获取时间间隔
+ (NSTimeInterval)getTimeIntervalWithEarlierDate:(NSDate *)earlierDate laterDate:(NSDate *)laterDate;

//将yyyy-MM-dd HH:mm:ss格式时间转换成时间戳
+ (NSTimeInterval)changeTimeToTimeSp:(NSString *)timeStr;


@end

/**
yyyy-MM-dd HH:mm:ss
年-月-日 时:分:秒
大写是为了区分“月”与“分”

顺便说下HH为什么大写，是为了区分12小时制与24小时制。
小写的h是12小时制，大写的H是24小时制。

书写格式和语言规定有关，上述写法是Windows系统中的我们常见的写法，包括日期设置于办公软件在内。在其他语言中有类似的但使用符号或格式不同的写法。

有的时候我们会看到这样的格式：yyyy-M-d H:m:s
mm与m等，它们的区别为是否有前导零：H,m,s表示非零开始，HH,mm,ss表示从零开始。
比如凌晨1点2分，HH:mm显示为01:02，H:m显示为1:2。

以2014年1月1日凌晨1点1分1秒（当天是星期三）为例子介绍一下其他的：
yyyy/yyy/yy/y 显示为 2014/2014/14/4
（3个y与4个y是一样的，为了便于理解多写成4个y）

MMMM/MMM/MM/M 显示为 一月/一月/01/1
（4个M显示全称，3个M显示缩写，不过中文显示是一样的，英文就是January和Jan）

dddd/ddd/dd/d 显示为 星期三/周三(有的语言显示为“三”)/01/1
（在英文中同M一样，4个d是全称，3个是简称；
dddd/ddd表示星期几，dd/d表示几号）

HH/H/hh/h 显示为 01/1/01 AM/1 AM

剩下的mm/m/ss/s只是前导零的问题了。

yyyy/M/d/dddd H:mm:ss 就是 2014年1月1日星期三 1:01:01
 
 
d               月中的某一天。一位数的日期没有前导零。
dd             月中的某一天。一位数的日期有一个前导零。
ddd           周中某天的缩写名称，在   AbbreviatedDayNames   中定义。
dddd         周中某天的完整名称，在   DayNames   中定义。
M               月份数字。一位数的月份没有前导零。
MM             月份数字。一位数的月份有一个前导零。
MMM           月份的缩写名称，在   AbbreviatedMonthNames   中定义。
MMMM         月份的完整名称，在   MonthNames   中定义。
y               不包含纪元的年份。不具有前导零。
yy             不包含纪元的年份。具有前导零。
yyyy         包括纪元的四位数的年份。
gg             时期或纪元。
h               12   小时制的小时。一位数的小时数没有前导零。
hh             12   小时制的小时。一位数的小时数有前导零。
H               24   小时制的小时。一位数的小时数没有前导零。
HH             24

 
 */
