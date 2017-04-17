//
//  DeleteCommentApi.h
//  gulucheng
//
//  Created by xukz on 2016/11/2.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteCommentApi : BaseRequest

- (instancetype)initWithEid:(NSString *)eid commentId:(NSString *)commentId;

@end
