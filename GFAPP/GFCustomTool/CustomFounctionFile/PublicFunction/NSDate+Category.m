//
//  NSDate+Category.m
//  
//  参考链接：https://www.jianshu.com/p/c092b9da5d7d
//  Created by sl on 2018/7/20.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import "NSDate+Category.h"

#define D_MINUTE    60
#define D_HOUR      3600
#define D_DAY       86400
#define D_WEEK      604800
#define D_YEAR      31556926

static const unsigned componentFlags = (NSCalendarUnitYear
                                        | NSCalendarUnitMonth
                                        | NSCalendarUnitDay
                                        | NSCalendarUnitWeekOfMonth
                                        | NSCalendarUnitWeekOfYear
                                        |  NSCalendarUnitHour
                                        | NSCalendarUnitMinute
                                        | NSCalendarUnitSecond
                                        | NSCalendarUnitWeekday
                                        | NSCalendarUnitWeekdayOrdinal
                                        );

@implementation NSDate (Category)

+ (NSCalendar *)currentCalendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar) {
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    }
    return sharedCalendar;
}

#pragma mark - 获取指定日期天数
+ (NSInteger)getDaysWithYear:(NSInteger)year month:(NSInteger)month {
    NSInteger days = 0;
    if (1 == month
        || 3 == month
        || 5 == month
        || 7 == month
        || 8 == month
        || 10 == month
        || 12 == month) {
        days = 31;
    } else if (4 == month || 6 == month || 9 == month || 11 == month) {
        days = 30;
    } else {// 2月份，闰年29天、平年28天
        if (((0 == year % 4) && (0 != year % 100))
            || (0 == (year % 400))) {
            days = 29;
        } else {
            days = 28;
        }
    }
    
    return days;
}

#pragma mark - 日期转换
+ (NSDate *)convertDateToLocalTime:(NSDate *)forDate {
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:forDate];
    NSDate *newDate = [forDate dateByAddingTimeInterval:timeOffset];
    return newDate;
}

+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)formatterString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatterString];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)formatterString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatterString];
    NSDate *fromdate = [format dateFromString:string];
    
    return fromdate;
}

#pragma mark - 日期调整
- (NSDate *)dateByAddingYears:(NSInteger)dYear {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYear];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)dateBySubtractingYears:(NSInteger)dYear {
    return [self dateByAddingYears:-dYear];
}

- (NSDate *)dateByAddingMonths:(NSInteger)dMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonth];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)dateBySubtractingMonths:(NSInteger)dMonth {
    return [self dateByAddingMonths:-dMonth];
}

- (NSDate *)dateByAddingDays:(NSInteger)dDay {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDay];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)datebySubtractingDays:(NSInteger)dDay {
    return [self dateByAddingDays:-dDay];
}

- (NSDate *)dateByAddingHours:(NSInteger)dHour {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHour;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingHours:(NSInteger)dHour {
    return [self dateByAddingHours:(dHour * -1)];
}

#pragma mark - 极端日期
- (NSDate *)dateAtStartOfYear {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.month = 1;
    components.day = 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateAtEndOfYear {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.month = 12;
    components.day = [NSDate getDaysWithYear:components.year month:components.month];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateAtStartOfMonth {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.day = 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateAtEndOfMonth {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.day = [NSDate getDaysWithYear:components.year month:components.month];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateAtStartOfDay {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateAtEndOfDay {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

#pragma mark - 日期比较
- (BOOL)isSameYearAsDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:date];
    return (components1.year == components2.year);
}

- (BOOL)isSameMonthAsDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL)isSameDayAsDate:(NSDate *)date {
    NSDateComponents *sComponents = [[NSDate currentCalendar] components:NSCalendarUnitYear
                                     | NSCalendarUnitMonth
                                     | NSCalendarUnitDay
                                                fromDate:self];
    NSDateComponents *dComponents = [[NSDate currentCalendar] components:NSCalendarUnitYear
                                     | NSCalendarUnitMonth
                                     | NSCalendarUnitDay
                                                fromDate:date];
    
    return ((sComponents.month == dComponents.month)
            && (sComponents.year == dComponents.year)
            && (sComponents.day == dComponents.day));
}

- (BOOL)isSameHourAsDate:(NSDate *)date {
    NSDateComponents *sComponents = [[NSDate currentCalendar] components:NSCalendarUnitYear
                                     | NSCalendarUnitMonth
                                     | NSCalendarUnitDay
                                     | NSCalendarUnitHour
                                                fromDate:self];
    NSDateComponents *dComponents = [[NSDate currentCalendar] components:NSCalendarUnitYear
                                     | NSCalendarUnitMonth
                                     | NSCalendarUnitDay
                                     | NSCalendarUnitHour
                                                fromDate:date];
    
    return ((sComponents.month == dComponents.month)
            && (sComponents.year == dComponents.year)
            && (sComponents.day == dComponents.day)
            && sComponents.hour == dComponents.hour);
}

#pragma mark - 日期分解
- (NSInteger)year {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}

- (NSInteger)month {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

- (NSInteger)day {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}

- (NSInteger)hour {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

- (NSInteger)minute {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

- (NSInteger)second {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}

- (NSInteger)weekOfYear {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfYear;
}

- (NSInteger)weekOfMonth {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfMonth;
}

- (NSInteger)weekday {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekday;
}

- (NSInteger)weekdayOrdinal {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger)nearestHour {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    
    return components.hour;
}

@end
