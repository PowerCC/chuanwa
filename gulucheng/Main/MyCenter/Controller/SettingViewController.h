//
//  SettingViewController.h
//  GuluCheng
//
//  Created by 许坤志 on 16/7/31.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController

@property (nonatomic, copy) void (^editNicknameBlock)(NSString *nickName);
@property (nonatomic, copy) void (^editCityBlock)(NSString *city);
@property (nonatomic, copy) void (^editHeadImageBlock)(UIImage *headImage);

@end
