//
//  ReplyCommentApi.m
//  gulucheng
//
//  Created by PWC on 2017/1/2.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "ReplyCommentApi.h"

@implementation ReplyCommentApi {
    NSString *_eid;
    NSString *_comment;
    NSString *_replyToUid;
    NSString *_fromCommentId;
}

- (instancetype)initWithEid:(NSString *)eid
                    comment:(NSString *)comment
                 replyToUid:(NSString *)replyToUid
              fromCommentId:(NSString *)fromCommentId {
    
    self = [super init];
    if (self) {
        _eid = eid;
        _comment = comment;
        _replyToUid = replyToUid;
        _fromCommentId = fromCommentId;
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
             @"comment": _comment,
             @"replyToUid": _replyToUid,
             @"fromCommentId": _fromCommentId
            };
}

@end
