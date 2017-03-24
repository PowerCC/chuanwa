//
//  LaunchPanel.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "LaunchPanel.h"

static LaunchPanel *launchPanel = nil;

@interface LaunchPanel ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, copy) LaunchCompleteBlock   block;

@end

@implementation LaunchPanel

- (void)dealloc {
    _backgroundView = nil;
}

#pragma mark - public
+ (void)displayWithCompleteBlock:(LaunchCompleteBlock)aBlock
{
    if (launchPanel == nil) {
        launchPanel = [[LaunchPanel alloc] init];
        launchPanel.rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    }
    launchPanel.block = aBlock;
    [launchPanel show];
}

#pragma mark - life cycle
- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 100;
        
        _backgroundView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        NSString *imageName = @"";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (iPhone5_5s) {
                imageName = @"LaunchImage-700-568h";
            }else if (iPhone6_6s){
                imageName = @"LaunchImage-800-667h";
            }else if (iPhone6_6sPlus){
                imageName = @"LaunchImage-800-Portrait-736h";
            }
            else {
                imageName = @"LaunchImage-700";
            }
        }
        UIImage *image = [UIImage imageNamed:imageName];
        _backgroundView.image = image;
        [self addSubview:_backgroundView];
        [self bringSubviewToFront:_backgroundView];
    }
    return self;
}

#pragma mark - methods
- (void)show {
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:2.f];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    //    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDidStopSelector:@selector(launchAnimationDone)];
    //    _backgroundView.alpha = 0.99f;
    //    [UIView commitAnimations];
    
    _backgroundView.alpha = 0.99f;
    [self setHidden:NO];
}

- (void)launchAnimationDone {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(launchTransitionDone)];
    
    _backgroundView.transform = CGAffineTransformScale(_backgroundView.transform, 1.1, 1.1);
    _backgroundView.alpha = 0.f;
    
    [UIView commitAnimations];
}

- (void)launchTransitionDone {
    
    [_backgroundView removeFromSuperview];
    [self setHidden:YES];
    
    if (_block) {
        _block();
    }
    
    if (launchPanel) {
        launchPanel = nil;
    }
}

@end
