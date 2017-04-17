//
//  PublishTextApi.h
//  GuluCheng
//
//  Created by 许坤志 on 16/8/3.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface PublishTextApi : BaseRequest

- (instancetype)initWithContent:(NSString *)content
                      eventCity:(NSString *)eventCity
                       latitude:(double)latitude
                      longitude:(double)longitude;

@end
