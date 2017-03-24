//
//  BaseNavigationController.m
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIImage+ColorImage.h"

@implementation BaseNavigationController

+ (void)initialize {
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    navBar.tintColor = NaviTintColor;
    
    //设置返回按钮图片
    [navBar setBackIndicatorImage:[UIImage imageNamed:@"public-backButton"]];
    [navBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"public-backButton"]];
    
    // 设置导航分割线
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage imageNamed:@"public-horizonLine"]];
    
    //设置Status bar为white
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //[navBar setBarTintColor:kCOLOR(252, 252, 252, 1.0)];
    
    // 3.设置Navigationbar的字体
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName: kCOLOR(68, 68, 68, 1.0),
                                     NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
}

@end
