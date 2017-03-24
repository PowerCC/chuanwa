//
//  ResetPasswordApi.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/15.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "ResetPasswordApi.h"

@implementation ResetPasswordApi {
    NSString *_oldPassword;
    NSString *_lastPassword;
}

- (id)initWithOldPassword:(NSString *)oldPassword lastPassword:(NSString *)lastPassword {
    self = [super init];
    if (self) {
        _oldPassword = oldPassword;
        _lastPassword = lastPassword;
    }
    return self;
}

- (NSString *)requestUrl {
    return updatePassword;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"pwd": _oldPassword,
             @"newPwd": _lastPassword
             };
}

@end
