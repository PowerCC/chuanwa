//
//  CommentListApi.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface CommentListApi : YTKRequest

- (instancetype)initWithEid:(NSString *)eid
                     offset:(NSInteger)offset
              fromNewNotice:(BOOL)isFromNewNotification;

@end
