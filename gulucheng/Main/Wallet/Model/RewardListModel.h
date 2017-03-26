//
//  RewardListModel.h
//  gulucheng
//
//  Created by 邹程 on 2017/3/18.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface RewardListModel : BaseModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *eid;
@property (nonatomic, copy) NSString *spreadCount;
@property (nonatomic, copy) NSString *spreadRate;
@property (nonatomic, copy) NSString *reward;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *publishReward;
@property (nonatomic, copy) NSString *noSpreadReason;
@property (nonatomic, copy) NSString *noSpreadReasonDesc;
@property (nonatomic, copy) NSString *eventType;
@property (nonatomic, copy) NSString *spic;

@end
