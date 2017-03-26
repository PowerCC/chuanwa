//
//  RegisterApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "RegisterApi.h"

@implementation RegisterApi {
    
    NSString *_mobile;
    NSString *_verifyCode;
    NSString *_password;
    NSString *_nickName;
    NSString *_cityCode;
    NSString *_gender;
}

- (instancetype)initWithMobile:(NSString *)mobile
                    verifyCode:(NSString *)verifyCode
                      password:(NSString *)password
                      nickName:(NSString *)nickName
                      cityCode:(NSString *)cityCode
                        gender:(NSString *)gender {
    
    self = [super init];
    if (self) {
        _mobile = mobile;
        _verifyCode = verifyCode;
        _password = password;
        _nickName = nickName;
        _cityCode = cityCode;
        _gender = gender;
    }
    return self;
}

- (NSString *)requestUrl {
    return userRegister;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"mobile":     _mobile,
             @"pwd":        _password,
             @"verifyCode": _verifyCode,
             @"nickName":   _nickName,
             @"cityCode":   _cityCode,
             @"gender":     _gender,
             @"deviceImei": @"100000"
             };
}

@end
