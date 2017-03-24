//
//  BaseTableViewController.m
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResponseBase.h"

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    // 去掉下面没有数据呈现的cell
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _navView.frame = CGRectMake(_navView.frame.origin.x,
                                (self.navigationController.navigationBar.translucent ? 0 : -64) + scrollView.contentOffset.y,
                                _navView.frame.size.width,
                                _navView.frame.size.height);
}

@end
