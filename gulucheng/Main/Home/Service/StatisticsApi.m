//
//  StatisticsApi.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/27.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "StatisticsApi.h"

@implementation StatisticsApi {
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
    return statistics;
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
