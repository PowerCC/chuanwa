//
//  BaseNavigationController.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAnimationController.h"

@interface BaseNavigationController : UINavigationController

- (void)presentToAnyViewControllerWithCustomAnimation:(UIViewController *)vc
                                      customAnimation:(CustomAnimationController *)customAnimation
                                            hiddenNav:(BOOL)hiddenNav;

@end
