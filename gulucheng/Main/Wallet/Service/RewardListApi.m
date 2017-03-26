//
//  RewardListApi.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/17.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "RewardListApi.h"

@interface RewardListApi () {
    NSInteger _limit;
    NSInteger _offset;
}

@end

@implementation RewardListApi

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
    return rewardList;
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
