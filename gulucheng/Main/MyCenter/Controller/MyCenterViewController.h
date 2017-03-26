//
//  MyCenterViewController.h
//  GuluCheng
//
//  Created by 许坤志 on 16/7/31.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCenterViewController : BaseViewController

@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) void (^PublishContentBlock)();

@end
