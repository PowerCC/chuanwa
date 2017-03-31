//
//  CustomAnimationController.h
//  GuluCheng
//
//  Created by 邹程 on 2017/3/31.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAnimationController : NSObject

@property (assign, nonatomic) BOOL presenting;

@property (assign, nonatomic) CGFloat duration;

@end



@interface CustomPublishAnimationController : CustomAnimationController

@end
