//
//  TextModel.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/12.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface TextModel : BaseModel

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *eid;
@property (copy, nonatomic) NSString *content;

@end
