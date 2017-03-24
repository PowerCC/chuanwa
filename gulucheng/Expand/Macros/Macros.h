//
//  Macros.h
//  gulucheng 常见的配置项
//
//  Created by 许坤志 on 16/7/19.
//  Copyright © 2016年 许坤志. All rights reserved.
//

/*! 全局单例 */
#define AppDelegateInstance ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define GlobalData [UtilModel sharedInstance]

/*! 系统目录 */
// Library/Caches 文件路径
#define FilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])
// 获取temp
#define kPathTemp NSTemporaryDirectory()
// 获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// 获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

/*! 字体 */
#define kFontSize(fontSize) [UIFont systemFontOfSize:fontSize]

/*! App版本号 */
#define appMPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 当前版本
#define SSystemVersion ([[UIDevice currentDevice] systemVersion])

//获取图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

/*! 用safari打开URL */
#define kOpenUrl(urlStr) [BASharedApplication openURL:urlStr]

/*! 复制文字内容 */
#define kCopyContent(content) [[UIPasteboard generalPasteboard] setString:content]

/*! 随机数据 */
#define kRandomData arc4random_uniform(5)

/*! weakSelf */
#define WEAKSELF typeof(self) __weak weakSelf = self;

/*! strongSelf */
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

/*! 通知 */
#define Noti [NSNotificationCenter defaultCenter]

/*! 本地存储 */
#define UserDefault [NSUserDefaults standardUserDefaults]

/*! 全局队列 */
#define AppBackgroundQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

/*! 隐藏或者现实navigationbar*/
#define NavigationBarHidden_Animated(isHidden, isAnimated) [self.navigationController setNavigationBarHidden:isHidden animated:isAnimated]

/*! 是否空对象 */
#define IS_NULL_CLASS(OBJECT) [OBJECT isKindOfClass:[NSNull class]]

/*! GCD */
#define GCD_GLOBAL(block)   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCD_MAIN(block)     dispatch_async(dispatch_get_main_queue(), block)
#define GCD_AFTER(second, block)     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), block)

/*! 警告框-一个按钮【VC】 */
#define BA_SHOW_ALERT(title, msg)  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title  message:msg preferredStyle:UIAlertControllerStyleAlert];\
[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {\
BALog(@"你点击了确定按钮！");\
}]];\
[self presentViewController:alert animated:YES completion:nil];\







