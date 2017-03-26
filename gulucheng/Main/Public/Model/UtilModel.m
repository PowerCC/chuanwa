//
//  UtilModel.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/30.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "UtilModel.h"

@implementation UtilModel

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

@end
