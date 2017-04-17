//
//  CommentApi.h
//  gulucheng
//
//  Created by 许坤志 on 16/9/6.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface CommentApi : BaseRequest

- (instancetype)initWithEid:(NSString *)eid
                     comment:(NSString *)comment;

@end
