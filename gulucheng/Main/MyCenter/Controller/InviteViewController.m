//
//  InviteViewController.m
//  gulucheng
//
//  Created by 许坤志 on 2016/11/1.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "InviteViewController.h"
#import "UMSocial.h"

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
    NSString *snsName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
    
    NSString *title = @"推荐传蛙app给你";
    NSString *content = @"我在传蛙上玩内容接力，还能扩大自己的影响力。挺有意思的，快来一起玩吧！";
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.chuanwa.ltd/download/main.html"];
    
    // qq 微信进行邀请好友
    if ([snsName isEqualToString:@"wxsession"]) {
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText = content;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    }
    
    if ([snsName isEqualToString:@"qq"]) {
        
        [UMSocialData defaultData].extConfig.qqData.title = title;
        [UMSocialData defaultData].extConfig.qqData.shareText = content;
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    }
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName]
                                                       content:content
                                                         image:[UIImage imageNamed:@"logo"]
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
