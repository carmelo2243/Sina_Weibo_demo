//
//  WeiboStatus.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-22.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboStatus.h"
#import "NSDate+WeiboDate.h"
#import "MJExtension.h"
#import "WeiboPicture.h"

@implementation WeiboStatus

//+ (instancetype)statusWithDict:(NSDictionary *)dict {
//    return [[self alloc] initWithDict:dict];
//}
//- (instancetype)initWithDict:(NSDictionary *)dict {
//    if (self == [super init]) {
//        self.idStr = dict[@"idStr"];
//        self.text = dict[@"text"];
//        self.source = dict[@"source"];
//        self.reposts_count = [dict[@"reposts_count"] intValue];
//        self.comments_count = [dict[@"comments_count"] intValue];
//        self.user = [WeiboUser userWithDict:dict];
//    }
//    return self;
//}

//
- (NSDictionary *)objectClassInArray {
    return @{@"pic_urls" : [WeiboPicture class]};
}

/**
 *  重写created_at的getter方法，转化时间格式
 */
- (NSString *)created_at {
    //1.首先拿到微博的发出时间
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    //格式对应关系的转发 Tue May 31 17:46:55 +0800 2011 -> EEE MMM dd HH:mm:ss Z yyyy
    dateFormater.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    dateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //将日期字符串转化为NSDate
    NSDate *createDate = [dateFormater dateFromString:_created_at];
////    NSDate *createDate = [dateFormater dateFromString:@"Tue May 31 17:46:55 +0800 2011"];
    
    //2.与现在的时间进行比较 得到时间差
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];//拿到当前时间
    NSDateComponents *deltaDate = [calender components:unit fromDate:createDate toDate:now options:0];
    
    //3.通过时间差判断显示内容
    if ([calender isDateInToday:createDate] == YES) {//日期为今天
        if (deltaDate.hour >= 1) {//返回日期与当前时间的间隔 大于等于一小时
            return [NSString stringWithFormat:@"%ld 小时前",deltaDate.hour];
        } else if (deltaDate.minute >= 1) {//返回日期与当前时间的间隔 大于等于一分钟
            return [NSString stringWithFormat:@"%ld 分钟前",deltaDate.minute];
        }else {
            return @"刚刚";
        }
    } else if ([calender isDateInYesterday:createDate] == YES) {//日期为昨天
        //显示昨天 HH:mm
        dateFormater.dateFormat = @"昨天 HH:mm";
        return [dateFormater stringFromDate:createDate];
    } else if (createDate.isDateInYear) {//日期为昨天之前，但在今年
        //显示月和日
        dateFormater.dateFormat = @"MMM-dd";
        return [dateFormater stringFromDate:createDate];
    } else {//日期在今年之前
        //显示年月日
        dateFormater.dateFormat = @"EEE-MMM-dd";
        return [dateFormater stringFromDate:createDate];
    }
}

/**
 *  重写source的setter方法
 */
- (void)setSource:(NSString *)source {
    _source = source;
    
    if (_source.length) {
//        NSLog(@"source:%@",source);
        NSUInteger loc = [source rangeOfString:@">"].location + 1;
        NSUInteger length = [source rangeOfString:@"</"].location - loc;
        //    NSLog(@"loc:%lu\nlength:%lu",(unsigned long)loc,(unsigned long)length);
        
        source = [source substringWithRange:NSMakeRange(loc, length)];
        
        _source = [NSString stringWithFormat:@"来自 %@",source];
    } else {
        _source = @"";
    }
}

@end








