//
//  MyWalletModel.h
//  gulucheng
//
//  Created by 邹程 on 2017/3/18.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWalletModel : BaseModel

@property (nonatomic, copy) NSString *rewardTotal;
@property (nonatomic, copy) NSString *rewardBalance;
@property (nonatomic, copy) NSString *payforTotal;
@property (nonatomic, copy) NSString *payforBalance;
@property (nonatomic, copy) NSString *balanceTotal;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *status;

@end
