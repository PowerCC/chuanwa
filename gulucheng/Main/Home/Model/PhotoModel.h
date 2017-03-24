//
//  PhotoModel.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/11.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface PhotoModel : BaseModel

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *eid;
@property (copy, nonatomic) NSString *picPath;
@property (copy, nonatomic) NSString *picType;
@property (copy, nonatomic) NSString *remark;

@end
