//
//  RecommendApi.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/9.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface RecommendApi : YTKRequest

- (instancetype)initWithLatitude:(double)latitude
                       longitude:(double)longitude;

@end

/*
 备注：推荐事件返回数据说明样例
 •	事件列表里的evnetType，是事件类型,比如vote 就是投票，text就是文本。根据这个去取不同的key值拿子json下面的数据。比如vote类型对应对象eventVoteVo
 •	json第一层中的id 是当用户传播，忽略 或投票的时候 作为fromEid进行使用的。
 •	子json，及例如eventVoteVo中的id，是这个事件的子事件的主建id。
 •	主事件id， json第一层的eid或者json第二层的eid。
 */