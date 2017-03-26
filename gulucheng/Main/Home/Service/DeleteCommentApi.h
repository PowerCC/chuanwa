//
//  DeleteCommentApi.h
//  gulucheng
//
//  Created by xukz on 2016/11/2.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface DeleteCommentApi : YTKRequest

- (instancetype)initWithEid:(NSString *)eid commentId:(NSString *)commentId;

@end
