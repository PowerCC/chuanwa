//
//  BaseShareViewController.h
//  gulucheng
//
//  Created by xukz on 16/9/21.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseViewController.h"
#import "TextCommendView.h"
#import "RecommendModel.h"
#import "PhotoModel.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "Tool.h"

@interface BaseShareViewController : BaseViewController <UMSocialPlatformProvider>

@property (strong, nonatomic) RecommendModel *currentRecommendModel;

@property (nonatomic, strong) TextCommendView *textCommendView;

@property (assign, nonatomic) NSInteger pageControlIndex;

@property (nonatomic, strong) NSString *eid;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) UIImage *shareImage;

- (void)shareButtonAction;
- (void)showAlertWithChat:(BOOL)isChat isSina:(BOOL)isSina isQQZone:(BOOL)isQQZone;

@end
