//
//  NSDate+Extend.m
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "NSDate+Extend.h"
#import "NSString+DateTime.h"

const NSInteger SECOND = 1;
const NSInteger MINUTE = 60 * SECOND;
const NSInteger HOUR = 60 * MINUTE;
const NSInteger DAY = 24 * HOUR;
const NSInteger MONTH = 30 * DAY;
const NSInteger YEAR = 12 * MONTH;


@implementation NSDate (Extend)

- (NSInteger)year {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                           fromDate:self].year;
}

- (NSInteger)month {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth
                                           fromDate:self].month;
}

- (NSInteger)day {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                           fromDate:self].day;
}

- (NSInteger)hour {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour
                                           fromDate:self].hour;
}

- (NSInteger)minute {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute
                                           fromDate:self].minute;
}

- (NSInteger)second {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                           fromDate:self].second;
}

- (NSInteger)weekday {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                           fromDate:self].weekday;
}

- (NSString *)stringWithDateFormat:(NSString *)format {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)timeLeft {
    long int delta = lround( [self timeIntervalSinceDate:[NSDate date]] );
    
    NSMutableString * result = [NSMutableString string];
    
    if ( delta >= YEAR )
    {
        NSInteger years = ( delta / YEAR );
        [result appendFormat:@"%ld年", (long)years];
        delta -= years * YEAR ;
    }
    
    if ( delta >= MONTH )
    {
        NSInteger months = ( delta / MONTH );
        [result appendFormat:@"%ld月", (long)months];
        delta -= months * MONTH ;
    }
    
    if ( delta >= DAY )
    {
        NSInteger days = ( delta / DAY );
        [result appendFormat:@"%ld天", (long)days];
        delta -= days * DAY ;
    }
    
    if ( delta >= HOUR )
    {
        NSInteger hours = ( delta / HOUR );
        [result appendFormat:@"%ld小时", (long)hours];
        delta -= hours * HOUR ;
    }
    
    if ( delta >= MINUTE )
    {
        NSInteger minutes = ( delta / MINUTE );
        [result appendFormat:@"%ld分钟", (long)minutes];
        delta -= minutes * MINUTE ;
    }
    
    NSInteger seconds = ( delta / SECOND );
    [result appendFormat:@"%ld秒", (long)seconds];
    
    return result;
}

+ (long long)timeStamp {
    return (long long)[[NSDate date] timeIntervalSince1970];
}

+ (NSString *)timeAgo:(double)timestamp {
    
    /*
     一小时之内的留言，显示X分钟前 ；
     24小时内的留言显示X小时前；
     48小时内的留言显示 昨天 mm：dd；
     7天内显示X天前；
     一年内显示的只显示月日时分不显示年，一年外的显示年月日时分
     */
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:confromTimesp];
    
    if (delta < 1 * MINUTE) {
        return @"刚刚";
    }
    else if (delta < 1 * HOUR) {
        int minutes = floor((double)delta / MINUTE);
        return [NSString stringWithFormat:@"%d分钟前", minutes];
    }
    else if (delta < 24 * HOUR) {
        int hours = floor((double)delta / HOUR);
        return [NSString stringWithFormat:@"%d小时前", hours];
    }
    else if (delta < 48 * HOUR) {
        return [NSString stringWithFormat:@"昨天 %@", [NSString timestampSwitchTime:timestamp andFormatter:@"HH:mm:ss"]];
    }
    else if (delta < 7 * DAY) {
        int days = floor((double)delta / DAY);
        return [NSString stringWithFormat:@"%d天前", days];
    }
    else if (delta < 1 * YEAR) {
        return [NSString timestampSwitchTime:timestamp andFormatter:@"MM月dd日 HH:mm:ss"];
    }
    
    return [NSString timestampSwitchTime:timestamp andFormatter:@"yyyy年MM月dd日 HH:mm:ss"];
    
    
    //    if (delta < 1 * MINUTE)
    //    {
    //        return @"刚刚";
    //    }
    //    else if (delta < 2 * MINUTE)
    //    {
    //        return @"1分钟前";
    //    }
    //    else if (delta < 45 * MINUTE)
    //    {
    //        int minutes = floor((double)delta/MINUTE);
    //        return [NSString stringWithFormat:@"%d分钟前", minutes];
    //    }
    //    else if (delta < 90 * MINUTE)
    //    {
    //        return @"1小时前";
    //    }
    //    else if (delta < 24 * HOUR)
    //    {
    //        int hours = floor((double)delta/HOUR);
    //        return [NSString stringWithFormat:@"%d小时前", hours];
    //    }
    //    else if (delta < 48 * HOUR)
    //    {
    //        return @"昨天";
    //    }
    //    else if (delta < 30 * DAY)
    //    {
    //        int days = floor((double)delta/DAY);
    //        return [NSString stringWithFormat:@"%d天前", days];
    //    }
    //    else if (delta < 12 * MONTH)
    //    {
    //        int months = floor((double)delta/MONTH);
    //        return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
    //    }
    //    
    //    int years = floor((double)delta/MONTH/12.0);
    //    return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}

+ (NSDate *)dateWithString:(NSString *)string format:(NSString*)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:string];
}

+ (NSDate *)now {
    return [NSDate date];
}

@end
