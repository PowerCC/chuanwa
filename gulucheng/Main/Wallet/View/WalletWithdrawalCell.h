//
//  WalletWithdrawalCell.h
//  GuluCheng
//
//  Created by 邹程 on 2017/3/16.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeLogsModel.h"

@interface WalletWithdrawalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *exRealnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeAmountLabel;

@property (weak, nonatomic) TradeLogsModel *tradeLogsModel;

@end
