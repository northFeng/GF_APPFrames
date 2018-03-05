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
 格式：YYYY-MM-DD HH:mm:ss ±HHMM
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
+ (long)changeTimeToTimeSp:(NSString *)timeStr;


@end
