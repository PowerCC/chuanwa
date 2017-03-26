//
//  RecommendOperateApi.h
//  GuluCheng
//
//  Created by 许坤志 on 16/8/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface RecommendOperateApi : YTKRequest

- (instancetype)initWithFromEid:(NSString *)fromEid
                            eid:(NSString *)eid
                    operateType:(NSString *)operateType
                       latitude:(double)latitude
                      longitude:(double)longitude;

@end
