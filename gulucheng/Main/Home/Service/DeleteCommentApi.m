//
//  DeleteCommentApi.m
//  gulucheng
//
//  Created by xukz on 2016/11/2.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "DeleteCommentApi.h"

@implementation DeleteCommentApi {
    NSString *_eid;
    NSString *_commentId;
}

- (instancetype)initWithEid:(NSString *)eid commentId:(NSString *)commentId {
    
    self = [super init];
    if (self) {
        _eid = eid;
        _commentId = commentId;
    }
    return self;
}

- (NSString *)requestUrl {
    return delCommentEvent;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"eid": _eid,
             @"id": _commentId
             };
}

@end
