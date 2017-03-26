//
//  PublishTextApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/3.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "PublishTextApi.h"

@implementation PublishTextApi {
    NSString *_content;
    NSString *_eventCity;
    double _latitude;
    double _longitude;
}

- (id)initWithContent:(NSString *)content
            eventCity:(NSString *)eventCity
             latitude:(double)latitude
            longitude:(double)longitude {
    self = [super init];
    if (self) {
        _content = content;
        _eventCity = eventCity;
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

- (NSString *)requestUrl {
    return publishText;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"deviceId": @"0",
             @"deviceType": @"iOS",
             @"eventType": @"text",
             @"eventTextVo.content": _content,
             
             @"eventCity": _eventCity,
             @"lat": [NSString stringWithFormat:@"%f", _latitude],
             @"lon": [NSString stringWithFormat:@"%f", _longitude]
             };
}

@end
