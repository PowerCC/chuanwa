//
//  RecommendOperateApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "RecommendOperateApi.h"

@implementation RecommendOperateApi {
    NSString *_fromEid;
    NSString *_eid;
    NSString *_operateType;
    double _latitude;
    double _longitude;
}

- (instancetype)initWithFromEid:(NSString *)fromEid
                            eid:(NSString *)eid
                    operateType:(NSString *)operateType
                       latitude:(double)latitude
                      longitude:(double)longitude {
    self = [super init];
    if (self) {
        _fromEid = fromEid;
        _eid = eid;
        _operateType = operateType;
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

- (NSString *)requestUrl {
    return _operateType;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"deviceType": @"iOS",

             @"fromEid": _fromEid,
             @"eid": _eid,
             @"lat": [NSString stringWithFormat:@"%f", _latitude],
             @"lon": [NSString stringWithFormat:@"%f", _longitude]
             };
}

@end
