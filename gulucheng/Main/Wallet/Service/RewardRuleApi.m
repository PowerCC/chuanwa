//
//  RewardRuleApi.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/17.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "RewardRuleApi.h"

@interface RewardRuleApi () {
    NSString *_apiKey;
}

@end

@implementation RewardRuleApi

- (instancetype)initWithApiKey:(NSString *)apiKey {
    
    self = [super init];
    if (self) {
        _apiKey = apiKey;
    }
    return self;
}

- (NSString *)requestUrl {
    return rewardRule;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
             @"apiKey": _apiKey
             };
}


@end
