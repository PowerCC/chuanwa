//
//  CommentModel.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"commentId" : @"id"
             };
}

@end


@implementation CommentReplyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"commentReplyId" : @"id"
             };
}

@end
