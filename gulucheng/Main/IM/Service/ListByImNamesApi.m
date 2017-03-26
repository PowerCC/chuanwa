//
//  ListByImNamesApi.m
//  gulucheng
//
//  Created by PWC on 2017/2/4.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "ListByImNamesApi.h"

@implementation ListByImNamesApi {
    NSString *_userNames;
}

- (instancetype)initWithUserNames:(NSString *)userNames {
    
    self = [super init];
    if (self) {
        _userNames = userNames;
    }
    return self;
}

- (NSString *)requestUrl {
    return listByImNames;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             @"usernames": _userNames
             };
}

@end
