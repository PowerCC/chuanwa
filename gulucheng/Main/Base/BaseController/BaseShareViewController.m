//
//  BaseShareViewController.m
//  gulucheng
//
//  Created by xukz on 16/9/21.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseShareViewController.h"
#import "ShareAppsView.h"
#import "UIViewController+HUD.h"

@interface BaseShareViewController ()

@property (nonatomic, strong) ShareAppsView *shareAppView;

@property (strong, nonatomic) UIAlertView *chatAlter;
@property (strong, nonatomic) UIAlertView *sinaAlter;
@property (strong, nonatomic) UIAlertView *qqAlter;

@end

@implementation BaseShareViewController

- (void)dealloc {
    
}

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
//    NSString *snsName = @"";//[[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
    
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
            _shareImage = [TextConversionPictureService createTextSharePicture:_shareText];
        }
        if ([eventType isEqualToString:VoteEvent]) {
            _shareText = _currentRecommendModel.voteModel.title;
        }
        if ([eventType isEqualToString:PictureEvent]) {
            _shareText = _currentRecommendModel.remark;
        }
    }
    
    /*
     UMSocialPlatformType_Sina               = 0, //新浪
     UMSocialPlatformType_WechatSession      = 1, //微信聊天
     UMSocialPlatformType_WechatTimeLine     = 2, //微信朋友圈
     UMSocialPlatformType_WechatFavorite     = 3, //微信收藏
     UMSocialPlatformType_QQ                 = 4, //QQ聊天页面
     UMSocialPlatformType_Qzone              = 5, //qq空间
     */
    
    UMSocialPlatformType platformType = UMSocialPlatformType_WechatTimeLine;
    
    switch (buttonIndex) {
        case 3:
            platformType = UMSocialPlatformType_WechatTimeLine;
            break;
        case 0:
            platformType = UMSocialPlatformType_Sina;
            if (_shareText.length >= 140) {
                _shareText = [_shareText substringToIndex:70];
            }
            break;
        case 5:
            platformType = UMSocialPlatformType_Qzone;
            _shareImage = _shareImage ? _shareImage : [UIImage imageNamed:@"logo"];
            break;
        case 6:
            platformType = UMSocialPlatformType_QQ;
            break;
            
        default:
            platformType = UMSocialPlatformType_WechatSession;
            break;
    }
    
    content = [NSString stringWithFormat:@"%@%@ %@", title,
               (_shareText.length > 0 ? _shareText : @""),
               shareUrl];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    if ([eventType isEqualToString:VoteEvent]) {

        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:[UIImage imageNamed:@"logo"]];
        //设置网页地址
        shareObject.webpageUrl = shareUrl;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }
    else {
        
        //设置文本
        messageObject.title = title;
        messageObject.text = content;
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = _shareImage;
        [shareObject setShareImage:_shareImage];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            /*
             UMSocialPlatformErrorType_Unknow            = 2000,            // 未知错误
             UMSocialPlatformErrorType_NotSupport        = 2001,            // 不支持（url scheme 没配置，或者没有配置-ObjC， 或则SDK版本不支持或则客户端版本不支持）
             UMSocialPlatformErrorType_AuthorizeFailed   = 2002,            // 授权失败
             UMSocialPlatformErrorType_ShareFailed       = 2003,            // 分享失败
             UMSocialPlatformErrorType_RequestForUserProfileFailed = 2004,  // 请求用户信息失败
             UMSocialPlatformErrorType_ShareDataNil      = 2005,             // 分享内容为空
             UMSocialPlatformErrorType_ShareDataTypeIllegal = 2006,          // 分享内容不支持
             UMSocialPlatformErrorType_CheckUrlSchemaFail = 2007,            // schemaurl fail
             UMSocialPlatformErrorType_NotInstall        = 2008,             // 应用未安装
             UMSocialPlatformErrorType_Cancel            = 2009,             // 取消操作
             UMSocialPlatformErrorType_NotNetWork        = 2010,             // 网络异常
             UMSocialPlatformErrorType_SourceError       = 2011,             // 第三方错误
             
             UMSocialPlatformErrorType_ProtocolNotOverride = 2013,   // 对应的	UMSocialPlatformProvider的方法没有实现
             UMSocialPlatformErrorType_NotUsingHttps      = 2014,   // 没有用https的请求,@see UMSocialGlobal isUsingHttpsWhenShareContent
             */
            
            NSString *errorMsg = @"未知错误";
            
            switch (error.code) {
                case UMSocialPlatformErrorType_NotSupport:
                    errorMsg = @"不支持";
                    break;
                    
                case UMSocialPlatformErrorType_AuthorizeFailed:
                    errorMsg = @"授权失败";
                    break;
                    
                case UMSocialPlatformErrorType_ShareFailed:
                    errorMsg = @"分享失败";
                    break;
                    
                case UMSocialPlatformErrorType_RequestForUserProfileFailed:
                    errorMsg = @"请求用户信息失败";
                    break;
                    
                case UMSocialPlatformErrorType_ShareDataNil:
                    errorMsg = @"分享内容为空";
                    break;
                    
                case UMSocialPlatformErrorType_ShareDataTypeIllegal:
                    errorMsg = @"分享内容不支持";
                    break;
                    
                case UMSocialPlatformErrorType_NotInstall:
                    errorMsg = @"应用未安装";
                    break;
                    
                case UMSocialPlatformErrorType_Cancel:
                    errorMsg = @"取消操作";
                    break;
                    
                case UMSocialPlatformErrorType_NotNetWork:
                    errorMsg = @"网络异常";
                    break;
                
                case UMSocialPlatformErrorType_SourceError:
                    errorMsg = @"第三方错误";
                    break;
                    
                case UMSocialPlatformErrorType_NotUsingHttps:
                    errorMsg = @"未使用https的请求";
                    break;
                    
                default:
                    errorMsg = @"未知错误";
                    break;
            }
            
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法分享"
                                                  message:errorMsg
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"确定", nil];
            [alertView show];
            
        } else {
            NSLog(@"response data is %@",data);
            
            [self showHint:@"分享成功"];
        }
    }];
}

////下面得到分享完成的回调
//- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
//    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//    }
//}

@end
