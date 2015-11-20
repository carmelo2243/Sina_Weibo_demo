//
//  NSDate+WeiboDate.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/12.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "NSDate+WeiboDate.h"

@implementation NSDate (WeiboDate)

- (BOOL)isDateInYear {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDate *now = [NSDate date];//拿到当前时间
    
    //分别获取当前和self的时间
    NSDateComponents *nowDate = [calender components:unit fromDate:now];
    NSDateComponents *selfDate = [calender components:unit fromDate:self];
    
    return nowDate.year == selfDate.year;
}

//- (NSDateComponents *)deltaDate {
//    NSCalendar *calender = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    NSDate *now = [NSDate date];//拿到当前时间
//    return [calender components:unit fromDate:self toDate:now options:0];
//}

//--------
/**
 *  是否为今天
 */
//- (BOOL)isToday
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
//    
//    // 1.获得当前时间的年月日
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    
//    // 2.获得self的年月日
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//    
//    return
//    (selfCmps.year == nowCmps.year) &&
//    (selfCmps.month == nowCmps.month) &&
//    (selfCmps.day == nowCmps.day);
//}
//
///**
// *  是否为昨天
// */
//- (BOOL)isYesterday
//{
//    //    NSCalendar *calendar = [NSCalendar currentCalendar];
//    //    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
//    //
//    //    // 1.获得当前时间的年月日
//    //    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    //
//    //    // 2.获得self的年月日
//    //    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//    //    return
//    //    (selfCmps.year == nowCmps.year) &&
//    //    (selfCmps.month == nowCmps.month) &&
//    //    (selfCmps.day == nowCmps.day);
//    return NO;
//}
//
///**
// *  是否为今年
// */
//- (BOOL)isThisYear
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    int unit = NSCalendarUnitYear;
//    
//    // 1.获得当前时间的年月日
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    
//    // 2.获得self的年月日
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//    
//    return nowCmps.year == selfCmps.year;
//}
//
//- (NSDateComponents *)deltaWithNow
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
//}
//--------
@end
