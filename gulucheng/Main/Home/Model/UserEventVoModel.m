//
//  UserEventVoModel.m
//  GuluCheng
//
//  Created by PWC on 2017/1/8.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "UserEventVoModel.h"

@implementation UserEventVoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"eventId" : @"id",
             @"lastCommentTimes" : @"newCommentTimes",
             @"lastNoticeTimes" : @"newNoticeTimes",
             @"photoModel" : @"eventPicVo",
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
