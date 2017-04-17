//
//  VoteEventApi.h
//  gulucheng
//
//  Created by xukz on 16/9/8.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseRequest.h"

@interface VoteEventApi : BaseRequest

- (instancetype)initWithfromEid:(NSString *)eventId
                    EventVoteId:(NSString *)voteId
                            eid:(NSString *)eid
                           vote:(NSString *)voteNumber;

@end
