//
//  EditNicknameViewController.h
//  JiaCheng
//
//  Created by 许坤志 on 16/6/15.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseViewController.h"

@interface EditNicknameViewController : BaseViewController

@property (nonatomic, copy) void (^editNicknameBlock)(NSString *nickName);

@end
