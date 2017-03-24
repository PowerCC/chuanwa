//
//  FavoriteUsersApi.m
//  gulucheng
//
//  Created by PWC on 2016/12/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "FavoriteUsersApi.h"

@implementation FavoriteUsersApi {
    NSString *_eid;
    NSInteger _limit;
    NSInteger _offset;
}

- (instancetype)initWithEid:(NSString *)eid
                      limit:(NSInteger)limit
                     offset:(NSInteger)offset {
    
    self = [super init];
    if (self) {
        _eid = eid;
        _limit = limit;
        _offset = offset;
    }
    return self;
}

- (NSString *)requestUrl {
    return favoriteUsers;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"loginToken": GlobalData.userModel.loginToken,
             @"uid": GlobalData.userModel.userID,
             @"eid" : _eid,
             @"limit" : [NSString stringWithFormat:@"%td", _limit],
             @"offset" : [NSString stringWithFormat:@"%td", _offset]
            };
}

@end
