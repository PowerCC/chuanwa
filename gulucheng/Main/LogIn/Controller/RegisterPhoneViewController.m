//
//  RegisterPhoneViewController.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/10.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "RegisterPhoneViewController.h"
#import "RegisterSmsCodeViewController.h"

#import "CheckPhoneApi.h"
#import "VerifyCodeApi.h"
#import "UIButton+Able.h"
#import "Tool.h"

@interface RegisterPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeButton;

@end

@implementation RegisterPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addTarget:self action:@selector(resignKeyboard)];
    [_checkCodeButton disableWithColor:Disable_orangeColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_mobileTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resignKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [_checkCodeButton disableWithColor:Disable_orangeColor];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([Tool noneSpaseString:_mobileTextField.text].length + string.length - range.length >= 11) {
        [_checkCodeButton normalWithColor:Them_orangeColor];
    } else {
        [_checkCodeButton disableWithColor:Disable_orangeColor];
    }
    
    if (textField == _mobileTextField) {
        return [Tool isAvilableWithTextField:textField string:string range:range];
    }
    
    return YES;
}

- (IBAction)verifyCodeButtonAction:(id)sender {
    
    // 检查手机号是否注册
    CheckPhoneApi *checkPhoneApi = [[CheckPhoneApi alloc] initWithMobile:[Tool noneSpaseString:_mobileTextField.text]];
    
    WEAKSELF
    [checkPhoneApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            [weakSelf checkCodeButtonAction:nil];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

- (IBAction)checkCodeButtonAction:(id)sender {
    // 发送注册验证码
    VerifyCodeApi *verifyCodeApi = [[VerifyCodeApi alloc] initWithMobile:[Tool noneSpaseString:_mobileTextField.text]];
    
    [MBProgressHUD showMessage:Loading toView:self.view];
    
    WEAKSELF
    [verifyCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            // 获取验证码成功，继续执行操作
            [weakSelf performSegueWithIdentifier:@"goCheckCodeSegue" sender:nil];
        }
        [MBProgressHUD hideHUDForView:weakSelf.view];
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        NSLog(@"failed");
    }];
}

- (IBAction)loginButtonAction:(id)sender {
    if (self.navigationController.childViewControllers.count < 3) {
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)resignKeyboard {
    [UIView animateWithDuration:0.30
                     animations:^{
                         CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
                         self.view.frame = rect;
                     }];
    
    [_mobileTextField resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[RegisterSmsCodeViewController class]]) {
        RegisterSmsCodeViewController *smsCodeViewController = (RegisterSmsCodeViewController *)[segue destinationViewController];
        smsCodeViewController.mobile = _mobileTextField.text;
        smsCodeViewController.sendType = _sendType;
    }
}

@end
