//
//  CheckNewNoticeApi.m
//  GuluCheng
//
//  Created by PWC on 2017/1/8.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "CheckNewNoticeApi.h"

@implementation CheckNewNoticeApi {
    NSString *_uid;
}

- (instancetype)initWithUid:(NSString *)uid {
    
    self = [super init];
    if (self) {
        _uid = uid;
    }
    return self;
}

- (NSString *)requestUrl {
    return chkNewNotice;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken
             };
}
@end
