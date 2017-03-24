//
//  CommentApi.m
//  gulucheng
//
//  Created by 许坤志 on 16/9/6.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CommentApi.h"

@implementation CommentApi {
    NSString *_eid;
    NSString *_comment;
}

- (instancetype)initWithEid:(NSString *)eid
                    comment:(NSString *)comment {
    
    self = [super init];
    if (self) {
        _eid = eid;
        _comment = comment;
    }
    return self;
}

- (NSString *)requestUrl {
    return commentEvent;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"eid": _eid,
             @"comment": _comment
             };
}

@end
