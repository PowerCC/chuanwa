//
//  TargetConfigMacros.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/23.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#ifndef TargetConfigMacros_h
#define TargetConfigMacros_h

#if PRODUCT  //产品环境

// 输出转换成DDLog
#define NSLog(...) DDLogVerbose(__VA_ARGS__)
#define Log(...) DDLogVerbose(__VA_ARGS__)

#else   //其它环境

// 输出转换成DDLog
#define NSLog(...) DDLogVerbose(__VA_ARGS__)
#define Log(...) DDLogVerbose(__VA_ARGS__)

#endif

#endif /* TargetConfigMacros_h */
