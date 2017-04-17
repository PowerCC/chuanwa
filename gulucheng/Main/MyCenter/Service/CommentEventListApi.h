//
//  CommentEventListApi.h
//  GuluCheng
//
//  Created by 许坤志 on 16/9/1.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface CommentEventListApi : BaseRequest

- (instancetype)initWithLimit:(NSInteger)limit
                       offset:(NSInteger)offset;


@end
