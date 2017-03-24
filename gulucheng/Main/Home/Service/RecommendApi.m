//
//  RecommendApi.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/9.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "RecommendApi.h"

@implementation RecommendApi {
    double _latitude;
    double _longitude;
}

- (instancetype)initWithLatitude:(double)latitude
                       longitude:(double)longitude {
    self = [super init];
    if (self) {
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

- (NSString *)requestUrl {
    return recommendEvent;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"deviceId": @"0",
             
             @"lat": [NSString stringWithFormat:@"%f", _latitude],
             @"lon": [NSString stringWithFormat:@"%f", _longitude]
             };
}

@end
