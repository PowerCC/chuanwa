//
//  TradeUserWithdrawApi.h
//  GuluCheng
//
//  Created by 邹程 on 2017/3/17.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface TradeUserWithdrawApi : YTKRequest

- (instancetype)initWithWithdrawAccount:(NSString *)withdrawAccount
                       withdrawRealName:(NSString *)withdrawRealName
                           withdrawType:(NSInteger)withdrawType
                                channel:(NSInteger)channel
                                 amount:(float)amount;

@end
