//
//  TurnOffPushApi.m
//  GuluCheng
//
//  Created by PWC on 2016/12/29.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "TurnOffPushApi.h"

@implementation TurnOffPushApi {
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
    return turnOffPush;
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
