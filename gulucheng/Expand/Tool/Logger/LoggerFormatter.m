//
//  LoggerFormatter.m
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "LoggerFormatter.h"
#import "NSDate+Extend.h"

@implementation LoggerFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    
    NSString *logLevel = nil;
    switch (logMessage.flag) {
        case DDLogFlagError:
            logLevel = @"[ERROR]";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARN]";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG]";
            break;
        default:
            logLevel = @"[VBOSE]";
            break;
    }
    
    NSString *formatStr
    = [NSString stringWithFormat:@"%@ %@ [%@][line %td] %@ %@", logLevel, [logMessage.timestamp stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss.S"], logMessage.fileName, logMessage.line, logMessage.function, logMessage.message];
    return formatStr;
}

@end
