//
//  FavoriteListApi.m
//  gulucheng
//
//  Created by PWC on 2016/12/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "FavoriteListApi.h"

@implementation FavoriteListApi {
    NSString *_uid;
    NSInteger _limit;
    NSInteger _offset;
}

- (instancetype)initWithUid:(NSString *)uid
                      limit:(NSInteger)limit
                     offset:(NSInteger)offset {
    
    self = [super init];
    if (self) {
        _uid = uid;
        _limit = limit;
        _offset = offset;
    }
    return self;
}

- (NSString *)requestUrl {
    return favoriteList;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"loginToken": GlobalData.userModel.loginToken,
             @"uid": _uid,
             @"limit" : [NSString stringWithFormat:@"%td", _limit],
             @"offset" : [NSString stringWithFormat:@"%td", _offset]
            };
}

@end
