//
//  PublishVoteApi.h
//  GuluCheng
//
//  Created by 许坤志 on 16/8/5.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface PublishVoteApi : BaseRequest

- (instancetype)initWithTitle:(NSString *)title
                      option1:(NSString *)option1
                      option2:(NSString *)option2
                      option3:(NSString *)option3
                      option4:(NSString *)option4
                      option5:(NSString *)option5
                    eventCity:(NSString *)eventCity
                     latitude:(double)latitude
                    longitude:(double)longitude;

@end
