//
//  RegisterSmsCodeViewController.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/10.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "RegisterSmsCodeViewController.h"
#import "RegisterSetPwdViewController.h"

#import "CheckVerifyCodeApi.h"
#import "VerifyCodeApi.h"

#import "UIButton+Able.h"
#import "Tool.h"

@interface RegisterSmsCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (assign, nonatomic) BOOL isTimeCountDownOver;

@end

@implementation RegisterSmsCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addTarget:self action:@selector(resignKeyboard)];
    [_submitButton disableWithColor:Disable_orangeColor];
    _mobileTextField.text = [NSString stringWithFormat:@"＋86  %@", _mobile];
    [_countDownLabel addTarget:self action:@selector(retrieveCheckCode)];
    
    [self timeCountBegin];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_codeTextField becomeFirstResponder];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"%@",NSStringFromRange(range));
    
    if ([Tool noneSpaseString:_codeTextField.text].length + string.length - range.length >= 6) {
        [_submitButton normalWithColor:Them_orangeColor];
    } else {
        [_submitButton disableWithColor:Disable_orangeColor];
    }
    
    return YES;
}

- (void)timeCountBegin {
    
    WEAKSELF
    [Tool countDownWithTime:59
             countDownBlock:^(NSInteger timeLeft) {
                 //设置界面的按钮显示 根据自己需求设置
                 NSString *strTime = [NSString stringWithFormat:@"验证码已发送，发送有效期%td秒", timeLeft];
                 weakSelf.countDownLabel.textColor = kCOLOR(153, 153, 153, 1.0);
                 weakSelf.countDownLabel.attributedText = [weakSelf addAttribute:strTime
                                                       andSecondName:[NSString stringWithFormat:@"%td", timeLeft]];
                 weakSelf.isTimeCountDownOver = NO;
             } endBlock:^{
                 //设置界面的按钮显示 根据自己需求设置
                 weakSelf.countDownLabel.text = @"重新获取验证码";
                 weakSelf.countDownLabel.textColor = Them_orangeColor;
                 
                 weakSelf.isTimeCountDownOver = YES;
             }];
}

- (IBAction)submitButtonAction:(id)sender {
    CheckVerifyCodeApi *checkCodeApi = [[CheckVerifyCodeApi alloc] initWithMobile:[Tool noneSpaseString:_mobile]
                                                                       verifyCode:_codeTextField.text];
    [MBProgressHUD showMessage:Loading toView:self.view];
    
    WEAKSELF
    [checkCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            // 验证码提交成功，继续执行操作
            if ([weakSelf.sendType isEqualToString:@"1"]) {
                [weakSelf performSegueWithIdentifier:@"gotoSetPasswordSegue" sender:nil];
            } else {
                [weakSelf performSegueWithIdentifier:@"gotoResetPasswordSegue" sender:nil];
            }
        }
        [MBProgressHUD hideHUDForView:weakSelf.view];
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
}

- (void)retrieveCheckCode {
    if (_isTimeCountDownOver) {
        VerifyCodeApi *verifyCodeApi = [[VerifyCodeApi alloc] initWithMobile:[Tool noneSpaseString:_mobile]];
        
        WEAKSELF
        [verifyCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
                // 获取验证码成功，继续执行操作
                [weakSelf timeCountBegin];
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            
        }];
    }
}

- (NSMutableAttributedString *)addAttribute:(NSString *)attributeString andSecondName:(NSString *)secondString {
    NSMutableAttributedString *declareString = [[NSMutableAttributedString alloc] initWithString:attributeString];
    
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                   Them_orangeColor, NSForegroundColorAttributeName, nil];
    
    [declareString addAttributes:attributeDict range:NSMakeRange(attributeString.length - secondString.length - 1,
                                                                 secondString.length)];
    return declareString;
}

- (void)resignKeyboard {
    [UIView animateWithDuration:0.30
                     animations:^{
                         CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
                         self.view.frame = rect;
                     }];
    
    [_mobileTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    RegisterSetPwdViewController *registerSetPwdViewController = (RegisterSetPwdViewController *)[segue destinationViewController];
    registerSetPwdViewController.mobile = [Tool noneSpaseString:_mobile];
    registerSetPwdViewController.checkCode = _codeTextField.text;
    registerSetPwdViewController.sendType = _sendType;
}

@end
