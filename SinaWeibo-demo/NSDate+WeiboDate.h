//
//  NSDate+WeiboDate.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/12.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WeiboDate)

/**日期是否在今年*/
- (BOOL)isDateInYear;

/**计算时间差*/
//- (NSDateComponents *)deltaDate;

//---------
/**
 *  是否为今天
 */
//- (BOOL)isToday;
///**
// *  是否为昨天
// */
//- (BOOL)isYesterday;
///**
// *  是否为今年
// */
//- (BOOL)isThisYear;
//
///**
// *  获得与当前时间的差距
// */
//- (NSDateComponents *)deltaWithNow;
//---------
@end
