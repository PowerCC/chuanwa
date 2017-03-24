//
//  FavoriteUserModel.m
//  gulucheng
//
//  Created by PWC on 2016/12/29.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "FavoriteUserModel.h"

@implementation FavoriteUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"uid" : @"id"
             };
}

@end
