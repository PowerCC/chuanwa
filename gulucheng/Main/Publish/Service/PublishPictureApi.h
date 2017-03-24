//
//  PublishPictureApi.h
//  GuluCheng
//
//  Created by 许坤志 on 16/8/5.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface PublishPictureApi : YTKRequest

- (instancetype)initWithImages:(NSArray *)images
                        remark:(NSString *)remark
                     eventCity:(NSString *)eventCity
                      latitude:(double)latitude
                     longitude:(double)longitude;

@end
