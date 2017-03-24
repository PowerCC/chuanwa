//
//  LogInApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "LogInApi.h"

@implementation LogInApi {
    NSString *_mobile;
    NSString *_password;
}

- (instancetype)initWithMobile:(NSString *)mobile password:(NSString *)password {
    self = [super init];
    if (self) {
        _mobile = mobile;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return userLogin;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"mobile": _mobile,
             @"pwd": _password
             };
}

@end
