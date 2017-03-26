//
//  GravityView.h
//  GuluCheng
//
//  Created by 许坤志 on 16/9/7.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GravityView : UIView

@property (nonatomic, strong, readonly) UIImageView *gravityImageView;
@property (nonatomic, strong) UIImage *gravityImage;

/**
 *  开始重力感应
 */
-(void)startGravity;

/**
 *  停止重力感应
 */
-(void)stopGravity;

@end
