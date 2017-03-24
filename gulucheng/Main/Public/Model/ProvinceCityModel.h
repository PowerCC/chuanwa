//
//  ProvinceCityModel.h
//  GuluCheng
//
//  Created by 许坤志 on 16/7/30.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface ProvinceCityModel : BaseModel

@property(nonatomic,copy) NSString *name;
@property(nonatomic,strong) NSArray *cities;

@end
