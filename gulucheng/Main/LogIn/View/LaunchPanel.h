//
//  LaunchPanel.h
//  GuluCheng
//
//  Created by 许坤志 on 16/7/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LaunchCompleteBlock)(void);

@interface LaunchPanel : UIWindow

+ (void)displayWithCompleteBlock:(LaunchCompleteBlock)aBlock;
- (void)show;
- (void)launchAnimationDone;

@end
