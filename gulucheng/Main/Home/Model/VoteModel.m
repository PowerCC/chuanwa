//
//  VoteModel.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/12.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "VoteModel.h"

@implementation VoteModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"voteId" : @"id"
             };
}

@end
