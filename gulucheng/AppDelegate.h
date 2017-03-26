//
//  AppDelegate.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/19.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) HomeViewController *homeViewController;
@property (strong, nonatomic) NSDictionary *launchOptionsDic;

- (void)showMainViewController;
- (void)gotoHomeLoginViewController;

@end

