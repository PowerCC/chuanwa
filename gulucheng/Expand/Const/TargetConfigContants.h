//
//  TargetConfigContants.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#ifndef TargetConfigContants_h
#define TargetConfigContants_h

#if PRODUCT  //产品环境

static NSString* const MBTargetConfig_NetWork_s=@"";

//DDLog等级
static const int ddLogLevel = LOG_LEVEL_ERROR;

#else   //其它环境

//DDLog等级
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

#endif

#endif /* TargetConfigContants_h */
