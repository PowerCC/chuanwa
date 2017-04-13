//
//  NSString+DateTime.m
//  gulucheng
//
//  Created by 邹程 on 2017/3/19.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "NSString+DateTime.h"

@implementation NSString (DateTime)

+ (NSString *)timestampSwitchTime:(double)timestamp andFormatter:(NSString *)format {
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
    
    NSLog(@"1296035591  = %@", confromTimesp);

    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];

    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);

    return confromTimespStr;
}

//+ (NSString *)timeAgo:(double)timestamp {
//    return [NSDate timeAgo:timestamp];
//}
@end
