//
//  HomeLoginViewController.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/9.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "HomeLoginViewController.h"
#import "RegisterPhoneViewController.h"
#import "JCGuidePageView.h"
#import "GravityView.h"

//#import "PersonInfoApi.h"
#import "LoginApi.h"

#import "Tool.h"

#import "YTKNetworkConfig.h"
#import "YTKUrlArgumentsFilter.h"

#import "LaunchPanel.h"

@interface HomeLoginViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *adWebView;

@end

@implementation HomeLoginViewController

- (void)dealloc {
    self.navigationController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 去掉导航分割线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navView.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.delegate = self;
    // 去掉导航分割线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setShadowImage:[UIImage new]];
    
    // 设置导航栏返回按钮颜色
    navigationBar.tintColor = Them_orangeColor;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstBeenUsed"]) {
        NSLog(@"第一次使用app客户端！");
        // 首次使用app进入引导页面
        [self showGuideView];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstBeenUsed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [self loadAd];
    }
}

- (void)loadAd {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navView.hidden = YES;
    [_adWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.91chuanwa.com/apphtml/index.html"]]];
    
    WEAKSELF
    GCD_AFTER(3, ^{
        [weakSelf login];
    });
}

- (void)login {
    YYDiskCache *yyDisk = [Tool yyDiskCache];
    if ([yyDisk containsObjectForKey:@"password"]) {
        
        // 显示启动动画
        LaunchPanel *launchPanel = [[LaunchPanel alloc] init];
        [launchPanel show];
        
        LogInApi *loginApi = [[LogInApi alloc] initWithMobile:[Tool noneSpaseString:(NSString *)[yyDisk objectForKey:@"mobile"]]
                                                     password:(NSString *)[yyDisk objectForKey:@"password"]];
        
        WEAKSELF
        [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
                
            }
            
            [launchPanel launchAnimationDone];
            
            if ([request.responseJSONObject[@"code"] intValue] == 200) {
                // 登录成功执行操作
                GlobalData.userModel = [UserModel JCParse:request.responseJSONObject[@"data"]];
                [AppDelegateInstance showMainViewController];
            }
            else {
                [weakSelf performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            [weakSelf performSegueWithIdentifier:@"loginSegue" sender:nil];
            [launchPanel launchAnimationDone];
        }];
    } else if ([yyDisk containsObjectForKey:@"mobile"]) {
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }
}

- (void)showGuideView {

    // 创建引导页视图
    JCGuidePageView *pageView = [[JCGuidePageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:pageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[RegisterPhoneViewController class]]) {
        RegisterPhoneViewController *registerPhoneViewController = [segue destinationViewController];
        registerPhoneViewController.sendType = @"1";
    }
}

@end
