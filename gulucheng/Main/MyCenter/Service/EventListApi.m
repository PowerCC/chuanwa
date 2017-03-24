//
//  EventListApi.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "EventListApi.h"

@implementation EventListApi {
    
    NSString *_userID;
    NSString *_limit;
    NSString *_offset;
    NSString *_currentFlag;
}

- (instancetype)initWithOtherUserID:(NSString *)userID
                              limit:(NSString *)limit
                             offset:(NSString *)offset
                        currentFlag:(NSString *)currentFlag {
    
    self = [super init];
    if (self) {
        _userID = userID;
        _limit = limit;
        _offset = offset;
        _currentFlag = currentFlag;
    }
    return self;
}

- (NSString *)requestUrl {
    return eventList;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
             @"myUid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"uid": _userID,
             @"limit": _limit,
             @"offset": _offset,
             @"currentFlag": _currentFlag
             };
}

@end
