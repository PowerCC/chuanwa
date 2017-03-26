//
//  SpreadListApi.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "SpreadListApi.h"

@implementation SpreadListApi {
    NSString *_eid;
    NSInteger _offset;
    NSInteger _limit;
}

- (instancetype)initWithEid:(NSString *)eid
                     offset:(NSInteger)offset
                      limit:(NSInteger)limit {
    
    self = [super init];
    if (self) {
        _eid = eid;
        _offset = offset;
        _limit = limit;
    }
    return self;
}

- (NSString *)requestUrl {
    return spreadList;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"eid": _eid,
             @"offset": [NSString stringWithFormat:@"%td", _offset],
             @"limit": [NSString stringWithFormat:@"%td", _limit]
             };
}

@end
