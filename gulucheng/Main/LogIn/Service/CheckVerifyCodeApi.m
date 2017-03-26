//
//  CheckVerifyCodeApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CheckVerifyCodeApi.h"

@implementation CheckVerifyCodeApi {
    NSString *_mobile;
    NSString *_verifyCode;
}

- (instancetype)initWithMobile:(NSString *)mobile verifyCode:(NSString *)verifyCode {
    self = [super init];
    if (self) {
        _mobile = mobile;
        _verifyCode = verifyCode;
    }
    return self;
}

- (NSString *)requestUrl {
    return checkVerifyCode;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"mobile": _mobile,
             @"code": _verifyCode
             };
}

@end
