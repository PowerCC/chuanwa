//
//  RewardListApi.h
//  GuluCheng
//
//  Created by 邹程 on 2017/3/17.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface RewardListApi : BaseRequest

- (instancetype)initWithLimit:(NSInteger)limit
                       offset:(NSInteger)offset;

@end
