//
//  CWGuideView.h
//  gulucheng
//
//  Created by xukz on 2016/10/19.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWGuideView : UIView <UIScrollViewDelegate>

@property UIScrollView  *guidePageView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
