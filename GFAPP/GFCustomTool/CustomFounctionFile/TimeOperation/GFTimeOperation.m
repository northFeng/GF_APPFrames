//
//  GFTimeOperation.m
//  GFAPP
//
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFTimeOperation.h"

@implementation GFTimeOperation

/**
  获取当前时间 HH可以大小写，其他的都这么写
  格式：YYYY-MM-DD HH:mm:ss ±HHMM
  其中 "±HHMM" 表示与GMT的存在多少小时多少分钟的时区差异。比如，若时区设置在北京，则 "±HHMM" 显示为 "+0800"
 */
+ (NSString *)getTimeWithFormatString:(NSString *)formateStr{
    
    //NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    //获取（默认获取的系统的）当前时间
    NSDate *currentDate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formateStr];
    NSString *timeString = [dateformatter stringFromDate:currentDate];
 
    return timeString;
}

//将当前时间转化为年月日格式
+ (NSString *)getTimeByYearMonthDayHourWithDate:(NSDate *)date{
    //NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];
    
    NSString *string = [NSString stringWithFormat:@"%ld年%ld月%ld日%ld时%ld分%ld秒",(long)year,(long)month,day,hour,min,(long)sec];
    
    return string;
}


///获取从1970年到现在的时间戳
+ (NSTimeInterval)getTimeIntervalSince1970{
    
    NSDate *date = [NSDate date];
    
    return date.timeIntervalSince1970;
}

///获取时间间隔
+ (NSTimeInterval)getTimeIntervalWithEarlierDate:(NSDate *)earlierDate laterDate:(NSDate *)laterDate{
    
    NSTimeInterval differenceTime = [laterDate timeIntervalSinceDate:earlierDate];
    
    return differenceTime;
}

//将yyyy-MM-dd HH:mm:ss格式时间转换成时间戳
+ (long)changeTimeToTimeSp:(NSString *)timeStr
{
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:timeStr];
    time= (long)[fromdate timeIntervalSince1970];
    NSLog(@"%ld",time);
    
    return time;
}


@end
