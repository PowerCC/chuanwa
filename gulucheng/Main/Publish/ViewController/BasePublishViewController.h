//
//  BasePublishViewController.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/4.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseViewController.h"
#import "PublishModel.h"

@interface BasePublishViewController : BaseViewController

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *eventCity;

@property (nonatomic, copy) void (^publishBlock)(PublishModel *publishModel, NSString *eid, NSString *eventType, NSString *shareText, UIImage *shareImage, BOOL isChat, BOOL isSina, BOOL isQQZone);

- (void)viewDismissAction;
- (void)publishButtonActionWithEid:(PublishModel *)publishModel eid:(NSString *)eid eventType:(NSString *)eventType shareText:(NSString *)shareText shareImage:(UIImage *)shareImage;

@end
