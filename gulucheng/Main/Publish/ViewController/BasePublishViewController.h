//
//  BasePublishViewController.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/4.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseViewController.h"

@interface BasePublishViewController : BaseViewController

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *eventCity;

@property (nonatomic, copy) void (^publishBlock)(NSString *eid, NSString *eventType, NSString *shareText, UIImage *shareImage, BOOL isChat, BOOL isSina, BOOL isQQZone);

- (void)viewDismissAction;
- (void)publishButtonActionWithEid:(NSString *)eid eventType:(NSString *)eventType shareText:(NSString *)shareText shareImage:(UIImage *)shareImage;

@end
