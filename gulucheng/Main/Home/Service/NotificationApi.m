//
//  NotificationApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/22.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "NotificationApi.h"

@implementation NotificationApi {
    
    NSString *_userID;
    NSInteger _limit;
    NSInteger _offset;
    NSInteger _currentFlag;
}

- (instancetype)initWithOtherUserID:(NSString *)userID
                              limit:(NSInteger)limit
                             offset:(NSInteger)offset
                        currentFlag:(NSInteger)currentFlag {
    
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
    return eventCommentedList;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
             @"myUid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"uid": _userID,
             @"limit": [NSString stringWithFormat:@"%td", _limit],
             @"offset": [NSString stringWithFormat:@"%td", _offset],
             @"currentFlag": [NSString stringWithFormat:@"%td", _currentFlag]
             };
}

@end
