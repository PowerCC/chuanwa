//
//  NotificationApi.h
//  GuluCheng
//
//  Created by 许坤志 on 16/8/22.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface NotificationApi : YTKRequest

- (instancetype)initWithOtherUserID:(NSString *)userID
                              limit:(NSInteger)limit
                             offset:(NSInteger)offset
                        currentFlag:(NSInteger)currentFlag;

@end