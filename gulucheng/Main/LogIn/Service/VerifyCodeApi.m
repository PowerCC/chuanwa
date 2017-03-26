//
//  VerifyCodeApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "VerifyCodeApi.h"

@implementation VerifyCodeApi {
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
    return verifyUserCode;
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
