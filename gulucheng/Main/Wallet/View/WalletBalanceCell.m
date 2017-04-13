//
//  WalletBalanceCell.m
//  gulucheng
//
//  Created by 邹程 on 2017/3/15.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "WalletBalanceCell.h"

@implementation WalletBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_spicImageView circularWithSize:CGSizeMake(2, 2)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRewardListModel:(RewardListModel *)rewardListModel {
    _rewardListModel = rewardListModel;
    
    if ([rewardListModel.eventType isEqualToString:@"text"]) {
        _spicImageView.image = [TextConversionPictureService createWalletBalanceCellTextPicture:rewardListModel.txtContent];
    }
    else if ([rewardListModel.eventType isEqualToString:@"vote"]) {
        _spicImageView.image = [TextConversionPictureService createWalletBalanceCellVotePicture:rewardListModel.txtContent];
    }
    else {
        [_spicImageView sd_setImageWithURL:[NSURL URLWithString:rewardListModel.spic] placeholderImage:[UIImage imageNamed:@"wallet-balance-logo"]];
    }
    
    _createTimeLable.text = [NSString timestampSwitchTime:rewardListModel.createTime.doubleValue andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    _publishRewardLable.text = [NSString stringWithFormat:@"发布奖金 %.3f", rewardListModel.publishReward.floatValue];
    
    if (rewardListModel.reward.floatValue > 0) {
        _noSpreadReasonDescLabel.hidden = YES;
        _rewardLabel.text = [NSString stringWithFormat:@"传递奖金 %.3f", rewardListModel.reward.floatValue];
    }
    else {
        _rewardLabel.text = @"传递奖金 ";
        _noSpreadReasonDescLabel.hidden = NO;
    }
    
    _rewardCountLabel.text = [NSString stringWithFormat:@"奖金总额 %.3f", rewardListModel.publishReward.floatValue + rewardListModel.reward.floatValue];
    
    _spreadCountLabel.text = rewardListModel.spreadCount.floatValue > 0 ? [NSString stringWithFormat:@"传递次数 %@", rewardListModel.spreadCount] : nil;

    _spreadRateLabel.text = rewardListModel.spreadRate.floatValue > 0 ? [NSString stringWithFormat:@"传递率 %.f%@", rewardListModel.spreadRate.floatValue, @"%"] : nil;
    
    if ([rewardListModel.noSpreadReasonDesc isEqualToString:@"传递中"]) {
        _noSpreadReasonDescLabel.text = [NSString stringWithFormat:@"%@...", rewardListModel.noSpreadReasonDesc];
        _noSpreadReasonDescLabel.hidden = NO;
        _noSpreadReasonDescLabel2.hidden = YES;
    }
    else {
        _noSpreadReasonDescLabel2.text = rewardListModel.noSpreadReasonDesc;
        _noSpreadReasonDescLabel2.hidden = NO;
        _noSpreadReasonDescLabel.hidden = YES;
    }
}
@end
