//
//  CommentModel.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *eid;
@property (nonatomic, copy) NSString *eventCity;
@property (nonatomic, copy) NSString *fromCommentId;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *isDisplay;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *replyCount;
@property (nonatomic, copy) NSArray *replyList;
@property (nonatomic, copy) NSString *replyStatus;
@property (nonatomic, copy) NSString *replyToUid;
@property (nonatomic, copy) NSString *uid;


@property (nonatomic, strong) NSIndexPath *replyIndexPath;

@end



@interface CommentReplyModel : BaseModel

@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *commentSelf;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *fromCommentId;
@property (nonatomic, copy) NSString *commentReplyId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *replyToNickName;
@property (nonatomic, copy) NSString *replyToUid;
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *eid;

@end
