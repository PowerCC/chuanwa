//
//  FavoriteUsersApi.h
//  gulucheng
//
//  Created by PWC on 2016/12/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface FavoriteUsersApi : BaseRequest

- (instancetype)initWithEid:(NSString *)eid
                      limit:(NSInteger)limit
                     offset:(NSInteger)offset;
@end
