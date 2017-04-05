//
//  PublishModel.h
//  GuluCheng
//
//  Created by 邹程 on 2017/3/30.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface PublishModel : BaseModel

@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSString *oneDayMaxRewards;
@property (nonatomic, copy) NSString *rewardFail;
@property (nonatomic, copy) NSString *publishReward;

@end
