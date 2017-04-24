//
//  XAspect-UMSocialAppDelegate.m
//  GuluCheng
//
//  Created by 许坤志 on 16/9/20.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "AppDelegate.h"
#import "XAspect.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"

#define AtAspect UMSocialAppDelegate

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)

- (void)configUSharePlatforms {
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kSocial_WX_ID appSecret:kSocial_WX_Url redirectURL:kSocial_WX_Url];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kSocial_QQ_ID/*设置QQ平台的appID*/  appSecret:kSocial_QQ_Secret redirectURL:kSocial_QQ_Url];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kSocial_Sina_Account  appSecret:kSocial_Sina_Secret redirectURL:kSocial_Sina_RedirectURL];
}

AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions) {

    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUmengKey];
    
    [self configUSharePlatforms];
    
//    [self confitUShareSettings];
    
//    //设置友盟社会化组件appkey
//    [UMSocialData setAppKey:kUmengKey];
//    //设置微信AppId、appSecret，分享url
//    [UMSocialWechatHandler setWXAppId:kSocial_WX_ID appSecret:kSocial_WX_Secret url:kSocial_WX_Url];
//    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
//    [UMSocialQQHandler setQQWithAppId:kSocial_QQ_ID appKey:kSocial_QQ_Secret url:kSocial_QQ_Url];
//    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSocial_Sina_Account
//                                              secret:kSocial_Sina_Secret
//                                         RedirectURL:kSocial_Sina_RedirectURL];
    
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}

AspectPatch(-, BOOL, application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation) {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    
    return XAMessageForward(application:application openURL:url sourceApplication:sourceApplication annotation:annotation);
}

// 实现回调方法
//- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//    }
//}

@end
#undef AtAspectOfClass
#undef AtAspect
