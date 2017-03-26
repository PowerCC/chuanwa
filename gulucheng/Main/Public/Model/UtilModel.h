//
//  UtilModel.h
//  GuluCheng
//
//  Created by 许坤志 on 16/7/30.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UtilModel : NSObject

@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, copy) NSString *loginToken;

+ (UtilModel *)sharedInstance;

@end
