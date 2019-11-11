//
//  NSDate+Category.h
//
//  参考链接：https://www.jianshu.com/p/c092b9da5d7d
//  Created by sl on 2018/7/20.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

#pragma mark - 日期分解
@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;

/**
 *  当前年的第几周
 *
 *  @return 当前年的第几周
 */
@property (nonatomic, readonly) NSInteger weekOfYear;

/**
 *  当前月的第几周
 *
 *  @return 当前月的第几周
 */
@property (nonatomic, readonly) NSInteger weekOfMonth;

/**
 *  当前日期所在周的第几天
 *
 *  @return 第几天
 */
@property (nonatomic, readonly) NSInteger weekday;

/**
 *  当前日期所在年的第几季度
 *
 *  @return 获得的季度
 */
@property (nonatomic, readonly) NSInteger weekdayOrdinal;

/**
 *  距离当前时间最近的小时 比如9：55 就是10：00 9：25就是9：00
 *
 *  @return 最近的小时
 */
@property (nonatomic, readonly) NSInteger nearestHour;

#pragma mark - 当前客户端的逻辑日历
/**
 *  获获取当前客户端的逻辑日历
 *
 *  @return 当前客户端的逻辑日历
 */
+ (NSCalendar *)currentCalendar;

#pragma mark - 获取指定日期天数
/**
 指定日期天数
 
 @param year 指定年
 @param month 指定月
 @return 天数
 */
+ (NSInteger)getDaysWithYear:(NSInteger)year month:(NSInteger)month;

#pragma mark - 日期转换
/**
 *  将日期转换为当前时区的日期
 *
 *  @param forDate 要转换的日期
 *
 *  @return 转换过的日期
 */
+ (NSDate *)convertDateToLocalTime:(NSDate *)forDate;

/**
 指定NSDate、指定格式转换日期字符串
 
 @param date            指定NSDate
 @param formatterString 指定格式
 @return                转换后的字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)formatterString;

/**
 指定日期字符串、指定格式转换NSDate
 
 @param string          指定日期字符串
 @param formatterString 指定格式
 @return                转换后的NSDate
 */
+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)formatterString;

#pragma mark - 日期调整
/**
 指定日期后推指定年得到的日期
 
 @param dYear 后推的年数
 @return      后推指定年数后的日期
 */
- (NSDate *)dateByAddingYears:(NSInteger)dYear;

/**
 指定日期前推指定年得到的日期
 
 @param dYear 前推的年数
 @return      前推指定年数后的日期
 */
- (NSDate *)dateBySubtractingYears:(NSInteger)dYear;

/**
 指定日期后推指定月得到的日期
 
 @param dMonth 后推的月数
 @return       后推指定月数后的日期
 */
- (NSDate *)dateByAddingMonths:(NSInteger)dMonth;

/**
 指定日期前推指定月得到的日期
 
 @param dMonth 前推的月数
 @return       前推指定月数后的日期
 */
- (NSDate *)dateBySubtractingMonths:(NSInteger)dMonth;

/**
 指定日期后推指定天得到的日期
 
 @param dDay 后推的天数
 @return     后推指定天数后的日期
 */
- (NSDate *)dateByAddingDays:(NSInteger)dDay;

/**
 指定日期前推指定月得到的日期
 
 @param dDay 前推的月数
 @return     前推指定月数后的日期
 */
- (NSDate *)datebySubtractingDays:(NSInteger)dDay;

/**
 *  指定日期后推指定小时得到的日期
 *
 *  @param dHour 后推的几个小时
 *  @return 后推后的日期
 */
- (NSDate *)dateByAddingHours:(NSInteger)dHour;

/**
 *  指定日期前推几小时得到的日期
 *
 *  @param dHour 前推的小时数
 *  @return 前推后得到的日期
 */
- (NSDate *)dateBySubtractingHours:(NSInteger)dHour;

#pragma mark - 极端日期
/**
 指定日期当年的开始时间(如：2018-01-01 00：00：00)
 
 @return 当年开始日期
 */
- (NSDate *)dateAtStartOfYear;

/**
 指定日期当年的结束时间(如：2018-12-31 23：59：59)
 
 @return 当年结束日期
 */
- (NSDate *)dateAtEndOfYear;

/**
 指定日期当月的开始时间(如：2018-01-01 00：00：00)
 
 @return 当月开始日期
 */
- (NSDate *)dateAtStartOfMonth;

/**
 指定日期当月的结束时间(如：2018-01-31 23：59：59)
 
 @return 当月结束日期
 */
- (NSDate *)dateAtEndOfMonth;

/**
 指定日期当天开始时间(如：2018-01-01 00：00：00)
 
 @return 当天开始时间
 */
- (NSDate *)dateAtStartOfDay;

/**
 指定日期当天结束时间(如：2018-01-01 23：59：59)
 
 @return 当天结束时间
 */
- (NSDate *)dateAtEndOfDay;

#pragma mark - 日期比较
/**
 判断是否是同一年
 
 @param date 比较的日期
 @return     yes：是，no：不是
 */
- (BOOL)isSameYearAsDate:(NSDate *)date;

/**
 判断是否是同一个月
 
 @param date  比较的日期
 @return      yes：是，no：不是
 */
- (BOOL)isSameMonthAsDate:(NSDate *)date;

/**
 判断是否是同一天
 
 @param date 比较的日期
 @return     yes：是，no：不是
 */
- (BOOL)isSameDayAsDate:(NSDate *)date;

/**
 判断是否是同一小时
 
 @param date 比较的日期
 @return     yes：是，no：不是
 */
- (BOOL)isSameHourAsDate:(NSDate *)date;

@end
