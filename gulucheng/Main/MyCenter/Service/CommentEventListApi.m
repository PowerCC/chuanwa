//
//  CommentEventListApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/9/1.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CommentEventListApi.h"

@implementation CommentEventListApi {
    
    NSInteger _limit;
    NSInteger _offset;
}

- (instancetype)initWithLimit:(NSInteger)limit
                       offset:(NSInteger)offset {
    
    self = [super init];
    if (self) {
        _limit = limit;
        _offset = offset;
    }
    return self;
}

- (NSString *)requestUrl {
    return commentedList;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"limit": [NSString stringWithFormat:@"%td", _limit],
             @"offset": [NSString stringWithFormat:@"%td", _offset]
             };
}

@end
