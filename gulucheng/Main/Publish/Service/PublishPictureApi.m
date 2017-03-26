//
//  PublishPictureApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/5.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "PublishPictureApi.h"
#import "Tool.h"
#import "AFURLRequestSerialization.h"

@implementation PublishPictureApi {
    NSArray *_imageArray;
    NSString *_remark;
    NSString *_eventCity;
    double _latitude;
    double _longitude;
}

- (instancetype)initWithImages:(NSArray *)images
                        remark:(NSString *)remark
                     eventCity:(NSString *)eventCity
                      latitude:(double)latitude
                     longitude:(double)longitude {
    self = [super init];
    if (self) {
        _imageArray = images;
        _remark = remark;
        _eventCity = eventCity;
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

- (NSString *)requestUrl {
    return publishMedia;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        
        NSString *type = @"image/jpg/png/jpeg";
        
        int i;
        for (UIImage *image in _imageArray) {
            // 给图片起随机名字
            i ++;
            [formData appendPartWithFileData:[Tool compressImage:image toTargetWidth:1024 maxFileSize:100]
                                        name:[NSString stringWithFormat:@"img%d", i+1]
                                    fileName:[NSString stringWithFormat:@"img%d.jpg", i+1]
                                    mimeType:type];
        }
    };
}

- (id)requestArgument {
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"deviceId": @"0",
             @"deviceType": @"iOS",
             @"eventType": @"pic",
             
             @"eventPicVo.remark": _remark,
             
             @"eventCity": _eventCity,
             @"lat": [NSString stringWithFormat:@"%f", _latitude],
             @"lon": [NSString stringWithFormat:@"%f", _longitude]
             
             };
}

@end
