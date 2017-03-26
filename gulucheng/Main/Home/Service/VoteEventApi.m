//
//  VoteEventApi.m
//  gulucheng
//
//  Created by xukz on 16/9/8.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "VoteEventApi.h"

@implementation VoteEventApi {
    
    NSString *_eventId;
    NSString *_voteId;
    NSString *_eid;
    NSString *_voteResult;
}

- (instancetype)initWithfromEid:(NSString *)eventId
                    EventVoteId:(NSString *)voteId
                            eid:(NSString *)eid
                           vote:(NSString *)voteResult {
    
    self = [super init];
    if (self) {
        _eventId = eventId;
        _voteId = voteId;
        _eid = eid;
        _voteResult = voteResult;
    }
    return self;
}

- (NSString *)requestUrl {
    return voteEvent;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"id": _voteId,
             @"eid": _eid,
             @"fromEid": _eventId,
             @"voteType": @"1",
             _voteResult: @"1"
             };
}

@end
