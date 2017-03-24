//
//  UserInfoApi.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface UserInfoApi : YTKRequest

- (instancetype)initWithOtherUserID:(NSString *)userID;

@end
