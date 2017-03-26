//
//  FavoriteAddApi.m
//  gulucheng
//
//  Created by PWC on 2016/12/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "FavoriteAddApi.h"

@implementation FavoriteAddApi {
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
    return favoriteAdd;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"eid": _eid,
             @"loginToken": GlobalData.userModel.loginToken,
             @"uid": GlobalData.userModel.userID
            };
}

@end