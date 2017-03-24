//
//  ForgetPwdApi.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/14.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "ForgetPwdApi.h"

@implementation ForgetPwdApi {
    
    NSString *_mobile;
    NSString *_password;
    NSString *_verifyCode;
}

- (id)initWithMobile:(NSString *)mobile password:(NSString *)password verifyCode:(NSString *)verifyCode {
    self = [super init];
    if (self) {
        _mobile = mobile;
        _password = password;
        _verifyCode = verifyCode;
    }
    return self;
}

- (NSString *)requestUrl {
    return resetPassword;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"mobile": _mobile,
             @"code": _verifyCode,
             @"newPwd": _password,
             @"newPwdRept": _password
             };
}

@end
