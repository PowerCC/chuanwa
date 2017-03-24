//
//  UserInfoApi.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "UserInfoApi.h"

@implementation UserInfoApi {
    
    NSString *_userID;
}

- (instancetype)initWithOtherUserID:(NSString *)userID {
    
    self = [super init];
    if (self) {
        _userID = userID;
    }
    return self;
}

- (NSString *)requestUrl {
    return profile;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
             @"myUid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"uid": _userID
             };
}

@end
