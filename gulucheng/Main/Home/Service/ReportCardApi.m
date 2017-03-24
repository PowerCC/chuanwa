//
//  ReportCardApi.m
//  GuluCheng
//
//  Created by xukz on 16/9/14.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "ReportCardApi.h"

@implementation ReportCardApi {
    NSString *_eid;
    NSInteger _reason;
}

- (instancetype)initWithEid:(NSString *)eid
                     reason:(NSInteger)reason {
    
    self = [super init];
    if (self) {
        _eid = eid;
        _reason = reason;
    }
    return self;
}

- (NSString *)requestUrl {
    return eventTipOffs;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"eid": _eid,
             @"reason": [NSString stringWithFormat:@"%td", _reason]
             };
}

@end
