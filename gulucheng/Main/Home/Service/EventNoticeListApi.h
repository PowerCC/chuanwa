//
//  EventNoticeListApi.h
//  GuluCheng
//
//  Created by PWC on 2017/1/8.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface EventNoticeListApi : BaseRequest

- (instancetype)initWithOtherUserID:(NSString *)userID
                              limit:(NSInteger)limit
                             offset:(NSInteger)offset
                        currentFlag:(NSInteger)currentFlag
                            ownFlag:(NSInteger)ownFlag;

@end
