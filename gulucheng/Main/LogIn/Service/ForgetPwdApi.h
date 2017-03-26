//
//  ForgetPwdApi.h
//  JiaCheng
//
//  Created by 许坤志 on 16/6/14.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface ForgetPwdApi : YTKRequest

- (id)initWithMobile:(NSString *)mobile
            password:(NSString *)password
          verifyCode:(NSString *)verifyCode;


@end
