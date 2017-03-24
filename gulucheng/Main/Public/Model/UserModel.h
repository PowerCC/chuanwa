//
//  UserModel.h
//  JiaCheng
//
//  Created by 许坤志 on 16/6/16.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel <NSCoding>

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *thisScore;
@property (nonatomic, copy) NSString *nextScore;
@property (nonatomic, copy) NSString *sendAround;
@property (nonatomic, copy) NSString *events;
@property (nonatomic, copy) NSString *textEvents;
@property (nonatomic, copy) NSString *voteEvents;
@property (nonatomic, copy) NSString *picEvents;

@property (nonatomic, copy) NSString *loginToken;

@end
