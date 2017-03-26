//
//  HeadUpLoadViewController.h
//  GuluCheng
//
//  Created by 许坤志 on 16/9/5.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseViewController.h"

@interface HeadUpLoadViewController : BaseViewController

@property (nonatomic, strong) UIImage *headImage;

@property (nonatomic, copy) void (^photoButtonAction)(NSInteger index);

@end
