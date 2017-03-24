//
//  MBProgressHUD+GLC.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (GLC)

/**
 *  显示自定义图片信息提示框
 *
 *  @param text       成功信息
 *  @param customIcon 图标名称
 *  @param view       指定显示信息的view
 */
+ (void)show:(NSString *)text customIcon:(NSString *)iconName view:(UIView *)view;

/**
 *  显示成功信息提示框
 *
 *  @param success 成功信息
 *  @param view    指定显示信息的view
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示失败信息提示框
 *
 *  @param success 失败信息
 *  @param view    指定显示信息的view
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 *  显示消息提示框
 *
 *  @param message 消息
 *  @param view    指定显示信息的view
 *
 *  @return 提示框
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/**
 *  显示成功信息提示框
 *
 *  @param success 成功信息
 */
+ (void)showSuccess:(NSString *)success;

/**
 *  显示失败信息提示框
 *
 *  @param success 失败信息
 */
+ (void)showError:(NSString *)error;

/**
 *  显示消息提示框
 *
 *  @param message 消息
 *
 *  @return 提示框
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;

/**
 *  隐藏提示框
 *
 *  @param view 指定隐藏提示框的view
 */
+ (void)hideHUDForView:(UIView *)view;

/**
 *  隐藏提示框
 */
+ (void)hideHUD;

@end
