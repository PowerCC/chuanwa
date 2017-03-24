//
//  EventNoticeListApi.m
//  GuluCheng
//
//  Created by PWC on 2017/1/8.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "EventNoticeListApi.h"

@implementation EventNoticeListApi {
    NSString *_userID;
    NSInteger _limit;
    NSInteger _offset;
    NSInteger _currentFlag;
    NSInteger _ownFlag;
}

- (instancetype)initWithOtherUserID:(NSString *)userID
                              limit:(NSInteger)limit
                             offset:(NSInteger)offset
                        currentFlag:(NSInteger)currentFlag
                            ownFlag:(NSInteger)ownFlag {
    
    self = [super init];
    if (self) {
        _userID = userID;
        _limit = limit;
        _offset = offset;
        _currentFlag = currentFlag;
        _ownFlag = ownFlag;
    }
    return self;
}

- (NSString *)requestUrl {
    return eventNoticeList;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
             @"uid": _userID,
             @"loginToken": GlobalData.userModel.loginToken,
             @"limit": [NSString stringWithFormat:@"%td", _limit],
             @"offset": [NSString stringWithFormat:@"%td", _offset],
             @"currentFlag": [NSString stringWithFormat:@"%td", _currentFlag],
             @"ownFlag": [NSString stringWithFormat:@"%td", _ownFlag],
             };
}

@end
