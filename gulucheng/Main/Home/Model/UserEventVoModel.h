//
//  UserEventVoModel.h
//  GuluCheng
//
//  Created by PWC on 2017/1/8.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface UserEventVoModel : BaseModel

@property (nonatomic, copy) NSString *bizUid;
@property (nonatomic, copy) NSString *commentTimes;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, copy) NSString *eid;
@property (nonatomic, copy) NSString *eventCity;
@property (nonatomic, copy) NSString *eventType;
@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *isDisplay;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *locationHash;
@property (nonatomic, copy) NSString *locationLongCode;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *lastCommentTimes;
@property (nonatomic, copy) NSString *lastNoticeTimes;
@property (nonatomic, copy) NSString *pushFlag;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *reviewTime;
@property (nonatomic, copy) NSString *skipTimes;
@property (nonatomic, copy) NSString *spic;
@property (nonatomic, copy) NSString *spreadTimes;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *weight;

@property (nonatomic, strong) PhotoModel *photoModel;
@property (nonatomic, strong) VoteModel *voteModel;
@property (nonatomic, strong) TextModel *textModel;

@property (nonatomic, strong) NSArray *eventPicVos;

@end
