//
//  ReplyCommentApi.h
//  gulucheng
//
//  Created by PWC on 2017/1/2.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface ReplyCommentApi : YTKRequest

- (instancetype)initWithEid:(NSString *)eid
                    comment:(NSString *)comment
                 replyToUid:(NSString *)replyToUid
              fromCommentId:(NSString *)fromCommentId;
@end
