//
//  SpreadListApi.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface SpreadListApi : BaseRequest

- (instancetype)initWithEid:(NSString *)eid
                     offset:(NSInteger)offset
                      limit:(NSInteger)limit;

@end
