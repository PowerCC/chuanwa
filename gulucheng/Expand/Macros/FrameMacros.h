//
//  FrameMacros.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/23.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#ifndef FrameMacros_h
#define FrameMacros_h

/*! 当前设备的屏幕宽度 */
#define SCREEN_WIDTH    ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

/*! 当前设备的屏幕高度 */
#define SCREEN_HEIGHT   ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

/*! 黄金比例的宽 */
#define WIDTH_0_618 WIDTH * 0.618

/*! Status bar height. */
#define StatusBarHeight      20.f

/*! Navigation bar height. */
#define NavigationBarHeight  64.f

/*! Tabbar height. self.tabBarController.tabBar.height */
#define getTabbarHeight      49.f

/*! Status bar & navigation bar height. */
#define StatusBarAndNavigationBarHeight   (20.f + 44.f)

/*! iPhone4 or iPhone4s */
#define iPhone4_4s     (SCREEN_WIDTH == 320.f && SCREEN_HEIGHT == 480.f)

/*! iPhone5 or iPhone5s */
#define iPhone5_5s     (SCREEN_WIDTH == 320.f && SCREEN_HEIGHT == 568.f)

/*! iPhone6 or iPhone6s */
#define iPhone6_6s     (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 667.f)

/*! iPhone6Plus or iPhone6sPlus */
#define iPhone6_6sPlus (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 736.f)

/*! cell的间距：10 */
#define StatusCellMargin 10

#endif /* FrameMacros_h */
