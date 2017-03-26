//
//  WalletWithdrawalCell.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/16.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "WalletWithdrawalCell.h"

@implementation WalletWithdrawalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTradeLogsModel:(TradeLogsModel *)tradeLogsModel {
    _tradeLogsModel = tradeLogsModel;
    
    _dateTimeLabel.text = [NSString timestampSwitchTime:tradeLogsModel.createTime.integerValue andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    _tradeStatusLabel.text = [NSString stringWithFormat:@"交易状态：%@", tradeLogsModel.tradeInfo];
    
    _exRealnameLabel.text = [NSString stringWithFormat:@"提现至支付宝 %@", tradeLogsModel.exRealname];
    
    _tradeAmountLabel.text = [NSString stringWithFormat:@"%.2f", tradeLogsModel.tradeAmount.floatValue];
}

@end
