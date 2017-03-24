//
//  EditNicknameViewController.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/15.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "EditNicknameViewController.h"

#import "UpdateUserInfoApi.h"
#import "UIButton+Able.h"

@interface EditNicknameViewController()

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end

@implementation EditNicknameViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_nickNameTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BGGrayColor;
    
    [_submitButton textDisableWithColor:Disable_orangeColor];
    
    _nickNameTextField.text = GlobalData.userModel.nickName;
    
    [_nickNameTextField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_nickNameTextField.text.length + string.length - range.length >= 2 &&
        _nickNameTextField.text.length + string.length - range.length <= 10) {
        [_submitButton textNormalWithColor:Them_orangeColor];
    } else {
        [_submitButton textDisableWithColor:Disable_orangeColor];
    }
    
    return YES;
}

- (IBAction)submitButtonAction:(id)sender {
    
    [_nickNameTextField resignFirstResponder];
    
    [MBProgressHUD showMessage:Loading toView:self.view];
    UpdateUserInfoApi *updateUserInfoApi = [[UpdateUserInfoApi alloc] initWithNickName:_nickNameTextField.text
                                                                              cityCode:nil
                                                                                avatar:nil];
    
    WEAKSELF
    [updateUserInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            [weakSelf.nickNameTextField resignFirstResponder];
            
            [MBProgressHUD showSuccess:@"保存成功" toView:weakSelf.view];
            
            GCD_AFTER(BackViewSeconds, ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            if (weakSelf.editNicknameBlock) {
                weakSelf.editNicknameBlock(_nickNameTextField.text);
            }
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

@end
