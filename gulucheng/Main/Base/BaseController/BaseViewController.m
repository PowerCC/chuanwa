//
//  BaseViewController.m
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseViewController.h"
#import "ResponseBase.h"

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                        self.navigationController.navigationBar.translucent ? 0 : -64,
                                                        SCREEN_WIDTH,
                                                        64)];
    _navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navView];
    
    // 隐藏返回按钮的字
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
}

- (BOOL)isSuccessWithRequest:(NSDictionary *)response {
    
    NSLog(@"请求结果--------:%@", response);
    
    ResponseBase *responseBase = [ResponseBase JCParse:response];
    
    if (responseBase.code == 200) {
        return YES;
    } else {
        
        if (responseBase.code == 2011) {
            GCD_AFTER(2.0, ^{
                [AppDelegateInstance gotoHomeLoginViewController];
            });
        }
        
        if (responseBase.message && responseBase.message.length > 0) {
            [MBProgressHUD showError:responseBase.message];
        }
    }
    return NO;
}

- (NSDictionary *)responseDictionaryWithRequest:(NSDictionary *)response {
    if ([self isSuccessWithRequest:response]) {
        ResponseBase *responseBase = [ResponseBase JCParse:response];
        return responseBase.data;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
