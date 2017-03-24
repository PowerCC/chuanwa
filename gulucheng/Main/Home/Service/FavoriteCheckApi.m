//
//  FavoriteCheckApi.m
//  gulucheng
//
//  Created by PWC on 2016/12/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "FavoriteCheckApi.h"

@implementation FavoriteCheckApi {
    NSString *_eid;
}

- (instancetype)initWithEid:(NSString *)eid {
    
    self = [super init];
    if (self) {
        _eid = eid;
    }
    return self;
}

- (NSString *)requestUrl {
    return favoriteCheck;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"eid" : _eid,
             @"loginToken": GlobalData.userModel.loginToken,
             @"uid": GlobalData.userModel.userID
            };
}

@end
