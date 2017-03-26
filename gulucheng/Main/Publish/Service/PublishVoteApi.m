//
//  PublishVoteApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/5.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "PublishVoteApi.h"

@implementation PublishVoteApi {
    NSString *_title;
    NSString *_option1;
    NSString *_option2;
    NSString *_option3;
    NSString *_option4;
    NSString *_option5;
    NSString *_eventCity;
    double _latitude;
    double _longitude;
}

- (instancetype)initWithTitle:(NSString *)title
                      option1:(NSString *)option1
                      option2:(NSString *)option2
                      option3:(NSString *)option3
                      option4:(NSString *)option4
                      option5:(NSString *)option5
                    eventCity:(NSString *)eventCity
                     latitude:(double)latitude
                    longitude:(double)longitude {

    self = [super init];
    if (self) {
        _title = title;
        _option1 = option1;
        _option2 = option2;
        _option3 = option3;
        _option4 = option4;
        _option5 = option5;
        _eventCity = eventCity;
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

- (NSString *)requestUrl {
    return publishVote;
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
             @"eventType": @"vote",
             @"eventVoteVo.voteType": @"1",
             
             @"eventVoteVo.title": _title,
             @"eventVoteVo.option1": _option1 ? _option1 : @"",
             @"eventVoteVo.option2": _option2 ? _option2 : @"",
             @"eventVoteVo.option3": _option3 ? _option3 : @"",
             @"eventVoteVo.option4": _option4 ? _option4 : @"",
             @"eventVoteVo.option5": _option5 ? _option5 : @"",
             
             @"eventCity": _eventCity,
             @"lat": [NSString stringWithFormat:@"%f", _latitude],
             @"lon": [NSString stringWithFormat:@"%f", _longitude]
             };
}

@end
