//
//  CreatPersonInfoViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/29.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CreatPersonInfoViewController.h"
#import "ProvincialCitiesPickerview.h"
#import <YTKNetwork/YTKNetwork.h>
#import "RegisterApi.h"

#import "UIButton+Able.h"
#import "Tool.h"

@interface CreatPersonInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *boyButton;
@property (weak, nonatomic) IBOutlet UIButton *girlButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@property (nonatomic, copy) NSString *gender;
@property (nonatomic, assign) BOOL isNickName;
@property (nonatomic, assign) BOOL isCity;

@property (nonatomic,strong) ProvincialCitiesPickerview *regionPickerView;

@end

@implementation CreatPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addTarget:self action:@selector(resignKeyboard)];
    [_submitButton disableWithColor:Disable_orangeColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_nickNameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sexButtonAction:(id)sender {
    
    UIButton *senderButton = (id)sender;
    if (senderButton.tag == 1) {
        _boyButton.selected = YES;
        _girlButton.selected = NO;
    } else if (senderButton.tag == 2) {
        _boyButton.selected = NO;
        _girlButton.selected = YES;
    }
    _gender = [NSString stringWithFormat:@"%td", senderButton.tag];
    
    [self resignKeyboard];
    [self showSubmitButtonColor];
}

- (IBAction)cityButtonAction:(id)sender {
    
    NSString *address = _cityButton.titleLabel.text;
    NSArray *array = [address componentsSeparatedByString:@" "];
    
    NSString *province = @"";//省
    NSString *city = @"";//市
    if (array.count > 1) {
        province = array[0];
        city = array[1];
    } else if (array.count > 0) {
        province = array[0];
    }
    
    [self.regionPickerView showPickerWithProvinceName:province cityName:city];
    
    [self resignKeyboard];
    [self showSubmitButtonColor];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"%@",NSStringFromRange(range));
    
    if ([Tool noneSpaseString:_nickNameTextField.text].length + string.length - range.length >= 2 &&
        [Tool noneSpaseString:_nickNameTextField.text].length + string.length - range.length <= 8) {
        _isNickName = YES;
        [self showSubmitButtonColor];
    } else {
        _isNickName = NO;
        [self showSubmitButtonColor];
    }
    
    return YES;
}

- (IBAction)submitButtonAction:(id)sender {
    
    RegisterApi *registerApi = [[RegisterApi alloc] initWithMobile:_mobile
                                                        verifyCode:_checkCode
                                                          password:_password
                                                          nickName:_nickNameTextField.text
                                                          cityCode:_cityButton.titleLabel.text
                                                            gender:_gender];
    
    [MBProgressHUD showMessage:Loading toView:self.view];
    
    WEAKSELF
    [registerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            // 注册成功，继续执行操作,进入默认首页
            GlobalData.userModel = [UserModel JCParse:request.responseJSONObject[@"data"]];
            
            if (GlobalData.userModel) {
                YYDiskCache *yyDisk = [Tool yyDiskCache];
                [yyDisk setObject:GlobalData.userModel forKey:@"userModel"];
                [yyDisk setObject:weakSelf.mobile forKey:@"mobile"];
                [yyDisk setObject:weakSelf.password forKey:@"password"];
                
                [AppDelegateInstance showMainViewController];
            }
        }
        [MBProgressHUD hideHUDForView:weakSelf.view];
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

- (void)showSubmitButtonColor {
    
    if (_isNickName && _isCity && _gender) {
        [_submitButton normalWithColor:Them_orangeColor];
    } else {
        [_submitButton normalWithColor:Disable_orangeColor];
    }
}

- (ProvincialCitiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[ProvincialCitiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        WEAKSELF
        _regionPickerView.completion = ^(NSString *provinceName, NSString *cityName) {
            STRONGSELF
            if (strongSelf) {
                [strongSelf.cityButton setTitleColor:kCOLOR(68, 68, 68, 1.0)
                                            forState:UIControlStateNormal];
                [strongSelf.cityButton setTitle:[NSString stringWithFormat:@"%@ %@", provinceName, cityName]
                                       forState:UIControlStateNormal];
                _isCity = YES;
                [strongSelf showSubmitButtonColor];
            }
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

- (void)resignKeyboard {
    [UIView animateWithDuration:0.30
                     animations:^{
                         CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
                         self.view.frame = rect;
                     }];
    
    [_nickNameTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
