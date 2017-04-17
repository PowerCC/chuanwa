//
//  ListByImNamesApi.h
//  gulucheng
//
//  Created by PWC on 2017/2/4.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface ListByImNamesApi : BaseRequest

- (instancetype)initWithUserNames:(NSString *)userNames;

@end
