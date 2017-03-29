//
//  SingleLoadingView.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/29.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "SingleLoadingView.h"

@implementation SingleLoadingView

- (id)initWithFrame:(CGRect)frame superView:(UIView *)view {
    self = [super initWithFrame:frame];
    
    self.animationImages = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"home-single-loading1"],
                            [UIImage imageNamed:@"home-single-loading2"],
                            [UIImage imageNamed:@"home-single-loading3"],
                            [UIImage imageNamed:@"home-single-loading4"],
                            [UIImage imageNamed:@"home-single-loading5"],
                            [UIImage imageNamed:@"home-single-loading6"],
                            [UIImage imageNamed:@"home-single-loading7"],
                            [UIImage imageNamed:@"home-single-loading8"],
                            [UIImage imageNamed:@"home-single-loading9"],
                            [UIImage imageNamed:@"home-single-loading10"],
                            [UIImage imageNamed:@"home-single-loading11"], nil];
    
    self.animationDuration = 1.0;
    self.animationRepeatCount = 0;
    
    [view addSubview:self];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
