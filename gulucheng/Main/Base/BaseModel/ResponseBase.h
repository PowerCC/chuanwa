//
//  ResponseBase.h
//  JiaCheng
//
//  Created by 许坤志 on 16/6/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseModel.h"

@interface ResponseBase : BaseModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSDictionary *data;

@end
