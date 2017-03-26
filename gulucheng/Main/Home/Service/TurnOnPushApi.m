//
//  TurnOnPushApi.m
//  GuluCheng
//
//  Created by PWC on 2016/12/29.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "TurnOnPushApi.h"

@implementation TurnOnPushApi {
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
    return turnOnPush;
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
