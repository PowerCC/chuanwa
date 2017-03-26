//
//  WalletBalanceCell.h
//  gulucheng
//
//  Created by 邹程 on 2017/3/15.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardListModel.h"

@interface WalletBalanceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *spicImageView;

@property (weak, nonatomic) IBOutlet UILabel *createTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *publishRewardLable;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *spreadCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *spreadRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noSpreadReasonDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *noSpreadReasonDescLabel2;
@property (weak, nonatomic) IBOutlet UILabel *rewardCountLabel;

@property (weak, nonatomic) RewardListModel *rewardListModel;

@end
