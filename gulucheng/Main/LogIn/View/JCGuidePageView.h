//
//  JCGuidePageView.h
//  JiaCheng
//
//  Created by 许坤志 on 16/7/2.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCGuidePageView : UIView <UIScrollViewDelegate>

@property UIPageControl *imagePageControl;
@property UIScrollView  *guidePageView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
