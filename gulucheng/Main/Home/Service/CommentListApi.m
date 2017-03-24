//
//  CommentListApi.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CommentListApi.h"

@implementation CommentListApi {
    NSString *_eid;
    NSInteger _offset;
    BOOL _isFromNewNotification;
}

- (instancetype)initWithEid:(NSString *)eid
                     offset:(NSInteger)offset
              fromNewNotice:(BOOL)isFromNewNotification {
    
    self = [super init];
    if (self) {
        _eid = eid;
        _offset = offset;
        _isFromNewNotification = isFromNewNotification;
    }
    return self;
}

- (NSString *)requestUrl {
    return commentList;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"eid": _eid,
             @"offset": [NSString stringWithFormat:@"%td", _offset],
             @"fromNewNotice": [NSString stringWithFormat:@"%d", _isFromNewNotification]
             };
}

@end
