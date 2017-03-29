//
//  GroupLoadingView.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/29.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "GroupLoadingView.h"

@implementation GroupLoadingView

- (id)initWithFrame:(CGRect)frame superView:(UIView *)view {
    self = [super initWithFrame:frame];
    
    self.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"home-group-loading1"],
                                      [UIImage imageNamed:@"home-group-loading3"],
                                      [UIImage imageNamed:@"home-group-loading5"],
                                      [UIImage imageNamed:@"home-group-loading7"],
                                      [UIImage imageNamed:@"home-group-loading9"],
                                      [UIImage imageNamed:@"home-group-loading11"],
                                      [UIImage imageNamed:@"home-group-loading13"],
                                      [UIImage imageNamed:@"home-group-loading15"],
                                      [UIImage imageNamed:@"home-group-loading17"],
                                      [UIImage imageNamed:@"home-group-loading19"],
                                      [UIImage imageNamed:@"home-group-loading21"],
                                      [UIImage imageNamed:@"home-group-loading23"],
                                      [UIImage imageNamed:@"home-group-loading25"],
                                      [UIImage imageNamed:@"home-group-loading27"],
                                      [UIImage imageNamed:@"home-group-loading29"],
                                      [UIImage imageNamed:@"home-group-loading31"],
                                      [UIImage imageNamed:@"home-group-loading33"],
                                      [UIImage imageNamed:@"home-group-loading35"],
                                      [UIImage imageNamed:@"home-group-loading37"],
                                      [UIImage imageNamed:@"home-group-loading39"],
                                      [UIImage imageNamed:@"home-group-loading41"],
                                      [UIImage imageNamed:@"home-group-loading43"],
                                      [UIImage imageNamed:@"home-group-loading45"],
                                      [UIImage imageNamed:@"home-group-loading47"],
                                      [UIImage imageNamed:@"home-group-loading49"],
                                      [UIImage imageNamed:@"home-group-loading51"],
                                      [UIImage imageNamed:@"home-group-loading53"],
                                      [UIImage imageNamed:@"home-group-loading55"], nil];
    
    self.animationDuration = 2.0;
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
