//
//  BaseModel.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (id)JCParse:(id)responseObj {
    if ([responseObj isKindOfClass:[NSArray class]]) {
        return [self mj_objectArrayWithKeyValuesArray:responseObj];
    }
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        return [self mj_objectWithKeyValues:responseObj];
    }
    
    return responseObj;
}

@end
