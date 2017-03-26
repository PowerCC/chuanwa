//
//  ResetPasswordViewController.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "ResetPasswordViewController.h"

#import "ResetPasswordApi.h"

#import "UIButton+Able.h"

@interface ResetPasswordViewController()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmLastPasswordTextField;

@property (copy, nonatomic) NSString *firstPwd;
@property (copy, nonatomic) NSString *secondPwd;

@end

@implementation ResetPasswordViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_confirmLastPasswordTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BGGrayColor;
    
    [_saveButton textDisableWithColor:Disable_orangeColor];
    
    [_oldPasswordTextField becomeFirstResponder];
}

- (IBAction)submitButtonAction:(id)sender {
    
    [MBProgressHUD showMessage:Loading toView:self.view];
    ResetPasswordApi *resetPasswordApi = [[ResetPasswordApi alloc] initWithOldPassword:_oldPasswordTextField.text
                                                                          lastPassword:_lastPasswordTextField.text];
    
    WEAKSELF
    [resetPasswordApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            [_confirmLastPasswordTextField resignFirstResponder];
            
            [MBProgressHUD showSuccess:@"保存成功" toView:weakSelf.view];
            
            GCD_AFTER(BackViewSeconds, ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    NSInteger textLength;
    if (strLength < 10) {
        textLength = strLength;
    } else {
        textLength = 9;
    }
    
    if (textField == _lastPasswordTextField) {
        _firstPwd = [toBeString substringToIndex:textLength];
    }
    
    if (textField == _confirmLastPasswordTextField) {
        _secondPwd = [toBeString substringToIndex:textLength];
    }
    
    if (_lastPasswordTextField.text.length + string.length - range.length >= 6 &&
        [_firstPwd isEqualToString:_secondPwd]) {
        [_saveButton textNormalWithColor:Them_orangeColor];
    } else {
        [_saveButton textDisableWithColor:Disable_orangeColor];
    }
    
    if (textField == _lastPasswordTextField || textField == _confirmLastPasswordTextField) {
        //限制输入字符个数
        if (textField.text.length + string.length - range.length > 9) {
            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;
}

@end
