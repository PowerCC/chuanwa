//
//  EventListApi.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface EventListApi : YTKRequest

- (instancetype)initWithOtherUserID:(NSString *)userID
                              limit:(NSString *)limit
                             offset:(NSString *)offset
                        currentFlag:(NSString *)currentFlag;

@end