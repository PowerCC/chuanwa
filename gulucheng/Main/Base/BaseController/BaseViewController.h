//
//  BaseViewController.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "CustomAnimationController.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIView *navView;

@property (nonatomic, weak) BaseNavigationController *baseNav;

@property (nonatomic, strong) CustomAnimationController *customAnimationController;

- (BOOL)isSuccessWithRequest:(NSDictionary *)response;
- (NSDictionary *)responseDictionaryWithRequest:(NSDictionary *)response;

@end
