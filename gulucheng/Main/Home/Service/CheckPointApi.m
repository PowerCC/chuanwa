//
//  CheckPointApi.m
//  gulucheng
//
//  Created by xukz on 2016/11/2.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CheckPointApi.h"

@implementation CheckPointApi

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)requestUrl {
    return chkNewComment;
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
