//
//  EventApi.m
//  GuluCheng
//
//  Created by xukz on 2016/10/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "EventApi.h"

@implementation EventApi {
    
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
    return getEventByEid;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"eid": _eid
             };
}

@end
