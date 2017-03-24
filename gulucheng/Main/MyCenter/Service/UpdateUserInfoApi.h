//
//  UpdateUserInfoApi.h
//  GuluCheng
//
//  Created by 许坤志 on 16/7/31.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface UpdateUserInfoApi : YTKRequest

- (instancetype)initWithNickName:(NSString *)nickName
                        cityCode:(NSString *)cityCode
                          avatar:(UIImage *)avatar;


@end

// NSData * imageData = UIImageJPEGRepresentation(image, 1);
