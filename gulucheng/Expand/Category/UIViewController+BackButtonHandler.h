//
//  UIViewController+BackButtonHandler.h
//  GuluCheng
//
//  Created by 邹程 on 2017/3/21.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BackButtonHandlerProtocol <NSObject>

@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
- (BOOL)navigationShouldPopOnBackButton;

@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end
