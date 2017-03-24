//
//  ResetPasswordApi.h
//  JiaCheng
//
//  Created by 许坤志 on 16/6/15.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface ResetPasswordApi : YTKRequest

- (id)initWithOldPassword:(NSString *)oldPassword lastPassword:(NSString *)lastPassword;

@end
