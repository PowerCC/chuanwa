//
//  WalletRuleViewController.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/14.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "WalletRuleViewController.h"
#import "RewardRuleApi.h"
#import "RewardRuleModel.h"

@interface WalletRuleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *activeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardMaxNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *minWithdrawLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@end

@implementation WalletRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self requestForRewardRule];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.navigationItem.title = @"奖金规则";
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 480.0) {
        _viewHeightConstraint.constant = 568.0 - 64.0;
    }
    else {
        _viewHeightConstraint.constant = screenHeight - 64.0;
    }
}

- (void)fillRuleData:(RewardRuleModel *)rewardRuleModel {
    _activeDateLabel.text = [NSString stringWithFormat:@"传蛙奖金活动期限：%@-%@", rewardRuleModel.startDay, rewardRuleModel.endDay];
    
    _rewardMaxNumLabel.text = [NSString stringWithFormat:@"每日可获得奖金的卡片上限%@张（含%@张）", rewardRuleModel.rewardMaxNum, rewardRuleModel.rewardMaxNum];
    
    _publishPriceLabel.text = [NSString stringWithFormat:@"每发布一次卡片获得：%@元", rewardRuleModel.publishPrice];
    
    _unitPriceLabel.text = [NSString stringWithFormat:@"3.卡片每次传递一次获得%@元", rewardRuleModel.unitPrice];
    
    _maxRewardLabel.text = [NSString stringWithFormat:@"4.单张卡片奖金上限为%@元", rewardRuleModel.maxReward];
    
    _minWithdrawLabel.text = [NSString stringWithFormat:@"注：%@元以上可以提现", rewardRuleModel.minWithdraw];
}

- (void)requestForRewardRule {
    WEAKSELF
    RewardRuleApi *rewardRuleApi = [[RewardRuleApi alloc] initWithApiKey:@"E417813A6750D9FF704FEF990C5EC499"];
    [rewardRuleApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            RewardRuleModel *rewardRuleModel = [RewardRuleModel JCParse:request.responseJSONObject[@"data"]];
            if (rewardRuleModel) {
                [weakSelf fillRuleData:rewardRuleModel];
            }
            else {
                [MBProgressHUD showError:@"无法获取规则，请重试" toView:weakSelf.view];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD showError:@"无法获取规则，请重试" toView:self.view];
    }];
}
@end
