//
//  NSString+DateTime.h
//  gulucheng
//
//  Created by 邹程 on 2017/3/19.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DateTime)

+ (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

@end