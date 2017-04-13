//
//  WalletWithdrawViewController.m
//  gulucheng
//
//  Created by 邹程 on 2017/3/15.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "WalletWithdrawViewController.h"
#import "RewardRuleApi.h"
#import "TradeUserWithdrawApi.h"
#import "RewardRuleModel.h"

@interface WalletWithdrawViewController ()

@property (weak, nonatomic) IBOutlet UILabel *withdrawCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *withdrawAmountLabel;

@property (weak, nonatomic) IBOutlet UITextField *alipayUserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *alipayRealNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;

@end

@implementation WalletWithdrawViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self requestForRewardRule];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_withdrawButton circularWithSize:CGSizeMake(3, 3)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    if ([vc respondsToSelector:@selector(setAlipayUserName:)]) {
        [vc setValue:_alipayUserNameTextField.text forKey:@"alipayUserName"];
    }
    
    if ([vc respondsToSelector:@selector(setAmount:)]) {
        [vc setValue:_amountTextField.text forKey:@"amount"];
    }
}

- (void)initUI {
    self.navigationItem.title = @"支付宝提现";
    
    _withdrawCountLabel.text = @"";
    _withdrawButton.enabled = NO;
    _withdrawButton.backgroundColor = kCOLOR(255, 191, 184, 1);
    
    [_alipayUserNameTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [_alipayRealNameTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [_amountTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
}

- (void)requestForRewardRule {
    WEAKSELF
    RewardRuleApi *rewardRuleApi = [[RewardRuleApi alloc] initWithApiKey:@"E417813A6750D9FF704FEF990C5EC499"];
    [rewardRuleApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            RewardRuleModel *rewardRuleModel = [RewardRuleModel JCParse:request.responseJSONObject[@"data"]];
            if (rewardRuleModel) {
                weakSelf.withdrawAmountLabel.text = [NSString stringWithFormat:@"注：%@元以上可以提现", rewardRuleModel.minWithdraw];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD showError:@"无法获取规则，请重试" toView:self.view];
    }];
}

- (void)requestForWithdraw {
    WEAKSELF
    TradeUserWithdrawApi *tradeUserWithdrawApi = [[TradeUserWithdrawApi alloc] initWithWithdrawAccount:_alipayUserNameTextField.text withdrawRealName:_alipayRealNameTextField.text withdrawType:1 channel:1 amount:_amountTextField.text.floatValue];
    
    [tradeUserWithdrawApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            NSString *identifier = @"walletWithdrawalSuccessSegue";
            [weakSelf performSegueWithIdentifier:identifier sender:nil];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD showError:@"提现失败，请重试" toView:self.view];
    }];
}

- (IBAction)withdrawAction:(id)sender {
    [self requestForWithdraw];
}

- (void)textFieldValueChanged:(UITextField *)textField {
    if (_alipayUserNameTextField.text.length > 0 && _alipayRealNameTextField.text.length > 0 && _amountTextField.text.length > 0) {
        _withdrawButton.enabled = YES;
        _withdrawButton.backgroundColor = kCOLOR(255, 129, 105, 1);
    }
    else if (_withdrawButton.enabled) {
        _withdrawButton.enabled = NO;
        _withdrawButton.backgroundColor = kCOLOR(255, 191, 184, 1);
    }
}

@end
