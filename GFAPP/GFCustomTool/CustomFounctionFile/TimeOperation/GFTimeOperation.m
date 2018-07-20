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
  精确到 微秒格式：yyyy-MM-dd hh:mm:ss.SSS
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
    /**
     好了，接下来就是问题所在了：其实呢，并不是我们代码出错了，而是因为 [[NSDate date] timeIntervalSince1970] 虽然可以获取到后面的毫秒、微秒 ，但是在保存的时候省略掉了。如一个时间戳不省略的情况下为 1395399556.862046 ，省略掉后为一般所见 1395399556 。所以想取得毫秒时用获取到的时间戳 *1000 ，想取得微秒时 用取到的时间戳 * 1000 * 1000 。这样就解释了上面的10位数值的问题，当你取毫秒的时候，就会变成13位数值了。我想这样大家应该明白了吧！
     
         获取时间戳*1000
         转化时：毫秒时间戳/1000.0    注意：必须加小数点 ，否则除以整数后结果为0
     */
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
