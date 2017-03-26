//
//  NSDate+Extend.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSInteger SECOND;
extern const NSInteger MINUTE;
extern const NSInteger HOUR;
extern const NSInteger DAY;
extern const NSInteger MONTH;
extern const NSInteger YEAR;

@interface NSDate (Extend)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;

- (NSString *)stringWithDateFormat:(NSString *)format;
- (NSString *)timeAgo;
- (NSString *)timeLeft;

+ (long long)timeStamp;

+ (NSDate *)dateWithString:(NSString *)string format:(NSString*)format;
+ (NSDate *)now;

@end
