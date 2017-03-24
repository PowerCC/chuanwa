//
//  RegisterSetPwdViewController.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/10.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "RegisterSetPwdViewController.h"
#import "CreatPersonInfoViewController.h"

#import "ForgetPwdApi.h"
#import "UIButton+Able.h"
//#import "YTKNetworkPrivate.h"
#import "Tool.h"

@interface RegisterSetPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerDoneButton;

@property (copy, nonatomic) NSString *firstPwd;
@property (copy, nonatomic) NSString *secondPwd;

@end

@implementation RegisterSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addTarget:self action:@selector(resignKeyboard)];
    [_registerDoneButton disableWithColor:Disable_orangeColor];
    
    [_passwordTextField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_passwordTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resignKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerDoneButtonAction:(id)sender {
    
    if ([_sendType isEqualToString:@"1"]) {
        
        [self performSegueWithIdentifier:@"personInfoSegue" sender:nil];
        
    } else {
        
        ForgetPwdApi *forgetPwdApi = [[ForgetPwdApi alloc] initWithMobile:_mobile
                                                                 password:_passwordTextField.text
                                                               verifyCode:_checkCode];
        
        [MBProgressHUD showMessage:Loading toView:self.view];
        
        WEAKSELF
        [forgetPwdApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            [MBProgressHUD hideHUDForView:weakSelf.view];
            
            if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
                // 密码修改成功，继续执行操作,进入登录页面
                [MBProgressHUD showSuccess:@"密码设置成功" toView:weakSelf.view];
                GCD_AFTER(BackViewSeconds, ^{
                    [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1]
                                                          animated:YES];
                });
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
        }];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect frame = textField.frame;
    CGFloat heights = self.view.frame.size.height;
    int offset = frame.origin.y + 135 - ( heights - 216.0-35.0);//键盘高度216
    [UIView animateWithDuration:0.30
                     animations:^{
                         float width = self.view.frame.size.width;
                         float height = self.view.frame.size.height;
                         
                         if(offset > 0) {
                             CGRect rect = CGRectMake(0.0f, -offset, width, height);
                             self.view.frame = rect;
                         }
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
    
    if (textField == _passwordTextField) {
        _firstPwd = [toBeString substringToIndex:textLength];
    }
    
    if (textField == _confirmPasswordTextField) {
        _secondPwd = [toBeString substringToIndex:textLength];
    }
    
    if (_passwordTextField.text.length + string.length - range.length >= 6 &&
        [_firstPwd isEqualToString:_secondPwd]) {
        [_registerDoneButton normalWithColor:Them_orangeColor];
    } else {
        [_registerDoneButton disableWithColor:Disable_orangeColor];
    }
    
    if (textField == _passwordTextField || textField == _confirmPasswordTextField) {
        //限制输入字符个数
        if (textField.text.length + string.length - range.length > 9) {
            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;
}

- (void)resignKeyboard {
    [UIView animateWithDuration:0.30
                     animations:^{
                         CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
                         self.view.frame = rect;
                     }];
    
    [_passwordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CreatPersonInfoViewController *creatPersonInfoViewController = [segue destinationViewController];
    creatPersonInfoViewController.mobile = _mobile;
    creatPersonInfoViewController.checkCode = _checkCode;
    creatPersonInfoViewController.password = _passwordTextField.text;
}

@end
