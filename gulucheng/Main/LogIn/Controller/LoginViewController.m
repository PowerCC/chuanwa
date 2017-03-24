//
//  LoginViewController.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/10.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterPhoneViewController.h"

#import "LogInApi.h"
#import "YTKNetworkConfig.h"
#import "YTKUrlArgumentsFilter.h"

#import "UIButton+Able.h"

#import "Tool.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (copy, nonatomic) NSString *sendType;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addTarget:self action:@selector(resignKeyboard)];
    
    // 18911065988
    YYDiskCache *yyDisk = [Tool yyDiskCache];
    _mobileTextField.text = (NSString *)[yyDisk objectForKey:@"mobile"];
    _passwordTextField.text = (NSString *)[yyDisk objectForKey:@"password"];
    
    if (_passwordTextField.text.length < 6) {
        [_loginButton disableWithColor:Disable_orangeColor];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_mobileTextField becomeFirstResponder];
    
    //[AppDelegateInstance showMainViewController];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resignKeyboard];
}

- (IBAction)loginButtonAction:(id)sender {
    
    LogInApi *loginApi = [[LogInApi alloc] initWithMobile:[Tool noneSpaseString:_mobileTextField.text]
                                                 password:_passwordTextField.text];
    
    [MBProgressHUD showMessage:Loading toView:self.view];
    
    WEAKSELF
    [loginApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            // 登录成功执行操作
            GlobalData.userModel = [UserModel JCParse:request.responseJSONObject[@"data"]];
            
            YYDiskCache *yyDisk = [Tool yyDiskCache];
            [yyDisk setObject:GlobalData.userModel forKey:@"userModel"];
            [yyDisk setObject:weakSelf.mobileTextField.text forKey:@"mobile"];
            [yyDisk setObject:weakSelf.passwordTextField.text forKey:@"password"];
            
            [AppDelegateInstance showMainViewController];
        }
        [MBProgressHUD hideHUDForView:weakSelf.view];
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

- (IBAction)registerButtonAction:(id)sender {
    if (self.navigationController.childViewControllers.count < 3) {
        // @"1" 判断为新注册用户
        _sendType = @"1";
        [self performSegueWithIdentifier:@"registerSegue" sender:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect frame = textField.frame;
    CGFloat heights = self.view.frame.size.height;
    
    // 当前点击textfield的坐标的Y值 + 当前点击textFiled的高度 - （屏幕高度- 键盘高度 - 键盘上tabbar高度）
    // 在这一部 就是了一个 当前textfile的的最大Y值 和 键盘的最全高度的差值，用来计算整个view的偏移量

    int offset = frame.origin.y + 135 - (heights - 216.0 - 35.0); // 键盘高度216
    
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
    
    if (([Tool noneSpaseString:_mobileTextField.text].length + string.length - range.length >= 8) &&
        ([Tool noneSpaseString:_passwordTextField.text].length + string.length - range.length >= 6)) {
        [_loginButton normalWithColor:Them_orangeColor];
    } else {
        [_loginButton disableWithColor:Disable_orangeColor];
    }
    
    if (textField == _mobileTextField) {
        return [Tool isAvilableWithTextField:textField string:string range:range];
    }
    
    if (textField == _passwordTextField) {
        //限制输入字符个数
        if (([Tool noneSpaseString:textField.text].length + string.length - range.length > 9) ) {
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
    
    [_mobileTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    RegisterPhoneViewController *registerPhoneViewController = [segue destinationViewController];
    registerPhoneViewController.sendType = _sendType;
}

@end
