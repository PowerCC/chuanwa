//
//  BaseShareViewController.m
//  gulucheng
//
//  Created by xukz on 16/9/21.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseShareViewController.h"
#import "ShareAppsView.h"

@interface BaseShareViewController ()

@property (nonatomic, strong) ShareAppsView *shareAppView;

@property (strong, nonatomic) UIAlertView *chatAlter;
@property (strong, nonatomic) UIAlertView *sinaAlter;
@property (strong, nonatomic) UIAlertView *qqAlter;

@end

@implementation BaseShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareButtonAction {
    
    [self.shareAppView ssss];
}

- (ShareAppsView *)shareAppView {
    if (!_shareAppView) {
        _shareAppView = [[ShareAppsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.navigationController.view addSubview:_shareAppView];
        
        WEAKSELF
        _shareAppView.ShareChannelButtonCompleteBlock = ^(NSInteger index) {
            [weakSelf shareChannelButtonActionWithTapIndex:index];
        };
    }
    return _shareAppView;
}

- (void)shareChannelButtonActionWithTapIndex:(NSInteger)buttonIndex {
    
    if ([_currentRecommendModel.eventType isEqualToString:PictureEvent]) {
        
        PhotoModel *photoModel = [_currentRecommendModel.eventPicVos objectAtIndex:_pageControlIndex];
        _shareImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:photoModel.picPath];
    }
    
    [self shareContentWithShareButtonIndex:buttonIndex eid:self.currentRecommendModel.eid eventType:self.currentRecommendModel.eventType];
}

- (void)showAlertWithChat:(BOOL)isChat isSina:(BOOL)isSina isQQZone:(BOOL)isQQZone {
    if (isChat) {
        _chatAlter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                message:@"确定分享到微信朋友圈吗？"
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"确定", nil];
        
        [_chatAlter show];
    }
    
    if (isSina) {
        _sinaAlter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                message:@"确定分享到新浪微博吗？"
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"确定", nil];
        
        [_sinaAlter show];
    }
    
    if (isQQZone) {
        _qqAlter = [[UIAlertView alloc] initWithTitle:@"提示"
                                              message:@"确定分享到QQ空间吗？"
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                                    otherButtonTitles:@"确定", nil];
        [_qqAlter show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView == _chatAlter) {
        if (buttonIndex == 1) {
            [self shareContentWithShareButtonIndex:3
                                               eid:self.eid
                                         eventType:self.eventType];
        }
    }
    
    if (alertView == _sinaAlter) {
        if (buttonIndex == 1) {
            [self shareContentWithShareButtonIndex:0
                                               eid:self.eid
                                         eventType:self.eventType];
        }
    }
    
    if (alertView == _qqAlter) {
        if (buttonIndex == 1) {
            [self shareContentWithShareButtonIndex:5
                                               eid:self.eid
                                         eventType:self.eventType];
        }
    }
}

- (void)shareContentWithShareButtonIndex:(NSInteger)buttonIndex eid:(NSString *)eid eventType:(NSString *)eventType {
    
    // 分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
    NSString *snsName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
    
    NSString *title;
    NSString *content;
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.91chuanwa.com/fx/main.html?eid=%@", eid];
    
    if ([eventType isEqualToString:TextEvent]) {
        title = @"【来自传蛙APP-文字卡】";
    }
    if ([eventType isEqualToString:VoteEvent]) {
        title = @"【来自传蛙APP-投票卡】";
    }
    if ([eventType isEqualToString:PictureEvent]) {
        title = @"【来自传蛙APP-图片卡】";
    }
    
    if (_currentRecommendModel) {
        if ([eventType isEqualToString:TextEvent]) {
            _shareText = _currentRecommendModel.textModel.content;
        }
        if ([eventType isEqualToString:VoteEvent]) {
            _shareText = _currentRecommendModel.voteModel.title;
        }
        if ([eventType isEqualToString:PictureEvent]) {
            _shareText = _currentRecommendModel.remark;
        }
    }
    
    // 投票 文字 会进行h5网址的分享
    if ([eventType isEqualToString:VoteEvent] || [eventType isEqualToString:TextEvent]) {
        
        if ([snsName isEqualToString:@"wxsession"]) {
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
            [UMSocialData defaultData].extConfig.wechatSessionData.shareText = _shareText;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        }
        
        if ([snsName isEqualToString:@"wxtimeline"]) {
            
            _shareImage = _shareImage ? _shareImage : [UIImage imageNamed:@"logo"];
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"%@%@", title, _shareText];
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        }
        
        if ([snsName isEqualToString:@"qq"]) {
            
            _shareImage = _shareImage ? _shareImage : [UIImage imageNamed:@"logo"];
            
            [UMSocialData defaultData].extConfig.qqData.title = title;
            [UMSocialData defaultData].extConfig.qqData.shareText = _shareText;
            [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        }
    }
    
    if ([eventType isEqualToString:PictureEvent]) {
        
        if ([snsName isEqualToString:@"wxsession"] || [snsName isEqualToString:@"wxtimeline"]) {
            [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        }
        
        if ([snsName isEqualToString:@"qq"]) {
            [UMSocialData defaultData].extConfig.qqData.title = title;
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
        }
    }
    
    // qqzone 全部是网址分享出去
    if ([snsName isEqualToString:@"qzone"]) {
        
        _shareImage = _shareImage ? _shareImage : [UIImage imageNamed:@"logo"];
        
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
        [UMSocialData defaultData].extConfig.qzoneData.shareText = _shareText;
        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
    }
    
    // 新浪微博 全部是网址分享出去格式统一的
    if ([snsName isEqualToString:@"sina"]) {
        
        if (_shareText.length >= 140) {
            _shareText = [_shareText substringToIndex:70];
        }
        
        content = [NSString stringWithFormat:@"%@%@ %@", title,
                   (_shareText.length > 0 ? _shareText : @""),
                   shareUrl];
        
//        if ([eventType isEqualToString:TextEvent]) {
//            content = [NSString stringWithFormat:@"【来自传蛙APP-文字卡】%@ %@", _currentRecommendModel.textModel.content, shareUrl];
//        }
//        if ([eventType isEqualToString:VoteEvent]) {
//            content = [NSString stringWithFormat:@"【来自传蛙APP-投票卡】%@ %@", _currentRecommendModel.voteModel.title, shareUrl];
//        }
//        if ([eventType isEqualToString:PictureEvent]) {
//            content = [NSString stringWithFormat:@"【来自传蛙APP-图片卡】%@ %@", _currentRecommendModel.remark, shareUrl];
//        }
    }
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName]
                                                       content:content ? content : nil
                                                         image:_shareImage
                                                      location:nil
                                                   urlResource:nil
                                           presentedController:self
                                                    completion:^(UMSocialResponseEntity * response){
                                                        if (response.responseCode == UMSResponseCodeSuccess) {
                                                            NSLog(@"分享成功！");
                                                        } else if(response.responseCode != UMSResponseCodeCancel) {
                                                            NSLog(@"分享失败！");
                                                        }
                                                    }];
}

//下面得到分享完成的回调
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

@end
