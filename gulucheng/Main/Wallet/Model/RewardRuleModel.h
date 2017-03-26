//
//  RewardRuleModel.h
//  gulucheng
//
//  Created by 邹程 on 2017/3/20.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface RewardRuleModel : BaseModel

@property (nonatomic, copy) NSString *startDay;
@property (nonatomic, copy) NSString *endDay;
@property (nonatomic, copy) NSString *unitPrice;
@property (nonatomic, copy) NSString *minSpreadRate;
@property (nonatomic, copy) NSString *maxReward;
@property (nonatomic, copy) NSString *minWithdraw;
@property (nonatomic, copy) NSString *maxWithdraw;
@property (nonatomic, copy) NSString *publishPrice;
@property (nonatomic, copy) NSString *rewardMaxNum;

@end
