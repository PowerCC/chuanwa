//
//  UserInfoApi.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface UserInfoApi : BaseRequest

- (instancetype)initWithOtherUserID:(NSString *)userID;

@end
