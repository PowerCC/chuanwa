//
//  UpdateUserInfoApi.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/31.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "UpdateUserInfoApi.h"
#import "Tool.h"
#import "AFURLRequestSerialization.h"

@implementation UpdateUserInfoApi {
    
    NSString *_nickName;
    NSString *_cityCode;
    UIImage *_avatar;
}

- (instancetype)initWithNickName:(NSString *)nickName
                        cityCode:(NSString *)cityCode
                          avatar:(UIImage *)avatar {
    
    self = [super init];
    if (self) {
        _nickName = nickName;
        _cityCode = cityCode;
        _avatar = avatar;
    }
    return self;
}

- (NSString *)requestUrl {
    return updateUserInfo;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        
        if (_avatar) {
            NSString *type = @"image/jpeg";
            
            NSString *filename = [NSString stringWithFormat:@"%d.png",arc4random_uniform(100)];
            
            [formData appendPartWithFileData:[Tool compressImage:_avatar toTargetWidth:150 maxFileSize:20]
                                        name:filename
                                    fileName:filename
                                    mimeType:type];
            
            
        }
    };
}

- (id)requestArgument {
    
    return @{
             @"id": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             
             @"nickName":   _nickName ? _nickName : @"",
             @"cityCode":   _cityCode ? _cityCode : @""
             };
}

@end
