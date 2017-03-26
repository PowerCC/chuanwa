//
//  XAspect-LogAppDelegate.m
//  gulucheng 抽离原本应在AppDelegate的内容(日志预加载)
//
//  Created by 许坤志 on 16/7/19.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "AppDelegate.h"
#import "MyFileLogger.h"
#import "XAspect.h"

#define AtAspect LogAppDelegate

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions) {
    //日志初始化
    [MyFileLogger sharedManager];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}

@end
#undef AtAspectOfClass
#undef AtAspect
