//
//  ResetPwdVerityCodeApi.m
//  gulucheng
//
//  Created by PWC on 2017/2/18.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "ResetPwdVerityCodeApi.h"

@implementation ResetPwdVerityCodeApi {
    NSString *_mobile;
}

- (id)initWithMobile:(NSString *)mobile {
    self = [super init];
    if (self) {
        _mobile = mobile;
    }
    return self;
}

- (NSString *)requestUrl {
    return resetPwdverifyCode;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"mobile": _mobile,
             };
}

@end
