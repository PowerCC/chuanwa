//
//  InviteViewController.m
//  gulucheng
//
//  Created by 许坤志 on 2016/11/1.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "InviteViewController.h"
#import "UIViewController+HUD.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inviteButtonAction:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    [self shareContentWithShareButtonIndex:senderButton.tag - 1];
}

- (void)shareContentWithShareButtonIndex:(NSInteger)buttonIndex {
    
    // 分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
//    NSString *snsName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
    
    NSString *title = @"推荐传蛙app给你";
    NSString *content = @"我在传蛙上玩内容接力，还能扩大自己的影响力。挺有意思的，快来一起玩吧！";
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.91chuanwa.com/download/main.html"];
    
//    // qq 微信进行邀请好友
//    if ([snsName isEqualToString:@"wxsession"]) {
//        
//        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
//        [UMSocialData defaultData].extConfig.wechatSessionData.shareText = content;
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//    }
//
//    if ([snsName isEqualToString:@"qq"]) {
//        
//        [UMSocialData defaultData].extConfig.qqData.title = title;
//        [UMSocialData defaultData].extConfig.qqData.shareText = content;
//        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
//        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//    }
//    
//    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName]
//                                                       content:content
//                                                         image:[UIImage imageNamed:@"logo"]
//                                                      location:nil
//                                                   urlResource:nil
//                                           presentedController:self
//                                                    completion:^(UMSocialResponseEntity * response){
//                                                        if (response.responseCode == UMSResponseCodeSuccess) {
//                                                            NSLog(@"分享成功！");
//                                                        } else if(response.responseCode != UMSResponseCodeCancel) {
//                                                            NSLog(@"分享失败！");
//                                                        }
//                                                    }];
    
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
            break;
        case 5:
            platformType = UMSocialPlatformType_Qzone;
            break;
        case 6:
            platformType = UMSocialPlatformType_QQ;
            break;
            
        default:
            platformType = UMSocialPlatformType_WechatSession;
            break;
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:[UIImage imageNamed:@"logo"]];
    //设置网页地址
    shareObject.webpageUrl = shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
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

//下面得到分享完成的回调
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
