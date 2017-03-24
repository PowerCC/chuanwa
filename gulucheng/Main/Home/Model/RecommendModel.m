//
//  RecommendModel.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/11.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"eventId" : @"id",
             @"lastCommentTimes" : @"newCommentTimes",
             @"voteModel" : @"eventVoteVo",
             @"textModel" : @"eventTextVo"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"eventPicVos" : @"PhotoModel"
             };
}

@end
