//
//  ReportCardApi.h
//  GuluCheng
//
//  Created by xukz on 16/9/14.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "YTKRequest.h"

@interface ReportCardApi : YTKRequest

- (instancetype)initWithEid:(NSString *)eid
                     reason:(NSInteger)reason;

@end
