//
//  CheckVerifyCodeApi.h
//  GuluCheng
//
//  Created by 许坤志 on 16/7/28.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface CheckVerifyCodeApi : BaseRequest

- (instancetype)initWithMobile:(NSString *)mobile verifyCode:(NSString *)verifyCode;

@end
