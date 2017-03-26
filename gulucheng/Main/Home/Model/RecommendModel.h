//
//  RecommendModel.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/11.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseModel.h"
#import "VoteModel.h"
#import "TextModel.h"

@interface RecommendModel : BaseModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *bizUid;
@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSString *eid;
@property (nonatomic, copy) NSString *fromEid;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *avaterUrl;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *spic;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *slogen;
@property (nonatomic, copy) NSString *eventType;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *commentTimes;
@property (nonatomic, copy) NSString *lastCommentTimes;
@property (nonatomic, copy) NSString *spreadTimes;
@property (nonatomic, copy) NSString *skipTimes;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *eventCity;

@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;

@property (nonatomic, strong) TextModel *textModel;
@property (nonatomic, strong) VoteModel *voteModel;
@property (nonatomic, strong) NSArray *eventPicVos;

@end
