//
//  FavoriteUserModel.h
//  gulucheng
//
//  Created by PWC on 2016/12/29.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface FavoriteUserModel : BaseModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *avatar;

@end
