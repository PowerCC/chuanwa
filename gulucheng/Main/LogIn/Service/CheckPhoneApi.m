//
//  CheckPhoneApi.m
//  gulucheng
//
//  Created by xukz on 16/10/8.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CheckPhoneApi.h"

@implementation CheckPhoneApi {
    
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
    return checkMobile;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"apiKey": @"E417813A6750D9FF704FEF990C5EC499",
             @"mobile": _mobile
             };
}

@end
