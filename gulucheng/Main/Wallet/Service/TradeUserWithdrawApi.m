//
//  TradeUserWithdrawApi.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/17.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "TradeUserWithdrawApi.h"

@interface TradeUserWithdrawApi () {
    NSString *_withdrawAccount;
    NSString *_withdrawRealName;
    
    NSInteger _withdrawType;
    NSInteger _channel;
    double _amount;
}

@end

@implementation TradeUserWithdrawApi

- (instancetype)initWithWithdrawAccount:(NSString *)withdrawAccount
                       withdrawRealName:(NSString *)withdrawRealName
                           withdrawType:(NSInteger)withdrawType
                                channel:(NSInteger)channel
                                 amount:(float)amount {
    
    self = [super init];
    if (self) {
        _withdrawAccount = withdrawAccount;
        _withdrawRealName = withdrawRealName;
        _withdrawType = withdrawType;
        _channel = channel;
        _amount = amount;
    }
    return self;
}

- (NSString *)requestUrl {
    return tradeUserWithdraw;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    return @{
             @"uid": GlobalData.userModel.userID,
             @"loginToken": GlobalData.userModel.loginToken,
             @"withdrawAccount": _withdrawAccount,
             @"withdrawRealName": _withdrawRealName,
             @"withdrawType" : [NSString stringWithFormat:@"%td", _withdrawType],
             @"channel" : [NSString stringWithFormat:@"%td", _channel],
             @"amount" : [NSString stringWithFormat:@"%f", _amount]
             };
}

@end
