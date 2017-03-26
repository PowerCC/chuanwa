//
//  WalletWithdrawalSuccessViewController.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/16.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "WalletWithdrawalSuccessViewController.h"

@interface WalletWithdrawalSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *alipayUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation WalletWithdrawalSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.navigationItem.title = @"提现成功";
    
    [_okButton circularWithSize:CGSizeMake(3, 3)];
    
    _alipayUserNameLabel.text = _alipayUserName;
    _amountLabel.text = _amount;
}

- (IBAction)closeAction:(id)sender {
    if (self.navigationController.viewControllers.count >= 2) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)navigationShouldPopOnBackButton {
    [self closeAction:nil];
    return NO;
}

@end
