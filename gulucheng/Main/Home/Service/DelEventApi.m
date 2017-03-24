//
//  DelEventApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/9/16.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "DelEventApi.h"

@implementation DelEventApi {
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
    return delEvent;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"eid": _eid
             };
}

@end
