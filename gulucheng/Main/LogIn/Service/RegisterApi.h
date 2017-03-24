//
//  RegisterApi.h
//  GuluCheng
//
//  Created by 许坤志 on 16/7/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface RegisterApi : YTKRequest

- (instancetype)initWithMobile:(NSString *)mobile
                    verifyCode:(NSString *)verifyCode
                      password:(NSString *)password
                      nickName:(NSString *)nickName
                      cityCode:(NSString *)cityCode
                        gender:(NSString *)gender;


@end
