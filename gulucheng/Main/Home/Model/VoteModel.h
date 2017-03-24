//
//  VoteModel.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/12.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface VoteModel : BaseModel

@property (copy, nonatomic) NSString *voteId;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *eid;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *voteType;

@property (copy, nonatomic) NSString *option1;
@property (copy, nonatomic) NSString *option2;
@property (copy, nonatomic) NSString *option3;
@property (copy, nonatomic) NSString *option4;
@property (copy, nonatomic) NSString *option5;
@property (copy, nonatomic) NSString *option6;

@property (copy, nonatomic) NSString *votes1;
@property (copy, nonatomic) NSString *votes2;
@property (copy, nonatomic) NSString *votes3;
@property (copy, nonatomic) NSString *votes4;
@property (copy, nonatomic) NSString *votes5;
@property (copy, nonatomic) NSString *votes6;

@end
