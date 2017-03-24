//
//  FaceBackApi.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/15.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "FaceBackApi.h"

@implementation FaceBackApi {
    NSString *_content;
}

- (id)initWithContent:(NSString *)content {
    self = [super init];
    if (self) {
        _content = content;
    }
    return self;
}

- (NSString *)requestUrl {
    return sendFeedBack;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"reason": @"0",
             @"content": _content
             };
}

@end
