//
//  TradeLogsModel.h
//  GuluCheng
//
//  Created by 邹程 on 2017/3/21.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface TradeLogsModel : BaseModel

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *tradeChannel;
@property (nonatomic, copy) NSString *tradeAmount;
@property (nonatomic, copy) NSString *tradeType;
@property (nonatomic, copy) NSString *tradeStatus;
@property (nonatomic, copy) NSString *tradeInfo;
@property (nonatomic, copy) NSString *exRealname;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *excuteUseTime;

@end
