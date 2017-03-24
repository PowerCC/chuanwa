//
//  ColorMacros.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/23.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#ifndef ColorMacros_h
#define ColorMacros_h

#pragma mark - ***** 颜色设置
/*! RGB色值 */
#define kCOLOR(R, G, B, A)      [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/*! 主题色 */
#define Them_orangeColor    kCOLOR(255, 129, 105, 1.0) //kCOLOR(253, 156, 39, 1.0)
/*! 导航栏深灰色 */
#define NaviTintColor       kCOLOR(44, 44, 44, 1.0)
/*! 设备蓝色 */
#define NaviBgBlueColor      kCOLOR(116, 135, 230, 1.0)
/*! 设备绿色 */
#define NaviBgGreenColor      kCOLOR(111, 211, 163, 1.0)

/*! 背景浅灰色 */
#define BGGrayColor         kCOLOR(244, 244, 244, 1.0)

#define TEXTGrayColor       kCOLOR(148, 147, 133, 1.0)
#define BLUEColor           kCOLOR(78, 164, 255, 1.0)
#define BGClearColor        [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.7f]

/*! 不能点击颜色 */
#define Disable_orangeColor   kCOLOR(255, 228, 224, 1.0) //kCOLOR(255, 227, 180, 1.0)
#define Disable_grayColor     kCOLOR(153, 153, 153, 1.0)

#endif /* ColorMacros_h */
