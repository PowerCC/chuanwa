//
//  DeleteCardApi.m
//  GuluCheng
//
//  Created by xukz on 16/9/14.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "DeleteCardApi.h"

@implementation DeleteCardApi {
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
    return YTKRequestMethodDelete;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"eid": _eid
             };
}

@end
