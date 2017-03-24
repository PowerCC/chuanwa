//
//  AppDelegate.m
//  gulucheng
//
//  Created by 许坤志 on 16/7/19.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "AppDelegate.h"
#import "CheckPointApi.h"
#import "Tool.h"
#import "YTKNetworkConfig.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <JPUSHRegisterDelegate>
@property (nonatomic, assign) BOOL isNewNotification;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置网络请求域名
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = host;
    
    // 设置高德地图apikey
    [AMapServices sharedServices].apiKey = APIKey;
    
    // 极光推送设置
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    if (launchOptions) {
        // 截取apns推送的消息
        NSDictionary *pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSString *typeString = [NSString stringWithFormat:@"%@", pushInfo[@"type"]];
        if ([typeString isEqualToString:@"1"]) {
            _isNewNotification = YES;
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    [application cancelAllLocalNotifications];
    
    if (GlobalData.userModel.userID.length > 0) {
        CheckPointApi *checkPointApi = [[CheckPointApi alloc] init];
        [checkPointApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSString *checkCode = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
            if ([checkCode isEqualToString:@"200"]) {
                _isNewNotification = YES;
            } else {
                _isNewNotification = NO;
            }
            
            if (_homeViewController) {
                if ([checkCode isEqualToString:@"200"]) {
                    [_homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-haveNotice"] forState:UIControlStateNormal];
                } else {
                    [_homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-notice"] forState:UIControlStateNormal];
                }
                
                [_homeViewController reGeocodeAction];
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            
        }];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0 || application.applicationState > 0) {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
        NSString *typeString = [NSString stringWithFormat:@"%@", userInfo[@"type"]];
        if ([typeString isEqualToString:@"1"]) {
            if (_homeViewController) {
                [_homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-haveNotice"] forState:UIControlStateNormal];
            }
        }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
        NSString *typeString = [NSString stringWithFormat:@"%@", userInfo[@"type"]];
        if ([typeString isEqualToString:@"1"]) {
            if (_homeViewController) {
                [_homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-haveNotice"] forState:UIControlStateNormal];
            }
        }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData
                                                              options:NSPropertyListImmutable
                                                               format:NULL
                                                                error:NULL];
    return str;
}

- (void)showMainViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController *homeNavViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = homeNavViewController;
    
    _homeViewController = (HomeViewController *)homeNavViewController.topViewController;
    if (_isNewNotification) {
        [_homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-haveNotice"] forState:UIControlStateNormal];
        _isNewNotification = NO;
    }
    
    [JPUSHService setAlias:GlobalData.userModel.userID
          callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                    object:self];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    NSLog(@"Alias回调:%@", alias);
}

- (void)gotoHomeLoginViewController {
    
    YYDiskCache *yyDisk = [Tool yyDiskCache];
    NSString *mobile = (NSString *)[yyDisk objectForKey:@"mobile"];
    [yyDisk removeAllObjects];
    [yyDisk setObject:mobile forKey:@"mobile"];
    
    GlobalData.userModel = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LogIn" bundle:nil];
    UIViewController *homeLoginViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = homeLoginViewController;
    
    [JPUSHService setAlias:@""
          callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                    object:self];
}

@end
