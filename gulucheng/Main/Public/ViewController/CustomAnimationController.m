//
//  CustomAnimationController.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/31.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "CustomAnimationController.h"

@interface CustomAnimationController () <UIViewControllerAnimatedTransitioning>

@end

@implementation CustomAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *detailView = _presenting ? toView : [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    detailView.alpha = _presenting ? 0.0 : 1.0;
    [containerView addSubview:detailView];
    
    [UIView animateWithDuration:_duration animations:^{
        if (_presenting == NO) {
            [detailView removeFromSuperview];
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end





@interface CustomPublishAnimationController ()

@end

@implementation CustomPublishAnimationController

- (id)init {
    self = [super init];
    self.duration = 0.3;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *detailView = self.presenting ? toView : [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    if (self.presenting) {
        detailView.transform = CGAffineTransformScale(detailView.transform, 0.7, 0.7);
        
        CGRect rect = detailView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        detailView.frame = rect;
        
        [containerView addSubview:detailView];
        
        [UIView animateWithDuration:self.duration animations:^{
            CGRect rect = detailView.frame;
            rect.origin.y = (SCREEN_HEIGHT - rect.size.height) / 2;
            detailView.frame = rect;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                detailView.transform = CGAffineTransformConcat(detailView.transform, CGAffineTransformInvert(detailView.transform));
            } completion:^(BOOL finished) {

            }];
            
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        [UIView animateWithDuration:self.duration animations:^{
            detailView.transform = CGAffineTransformScale(detailView.transform, 0.7, 0.7);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.6 animations:^{
                CGRect rect = detailView.frame;
                rect.origin.y = -SCREEN_HEIGHT;
                detailView.frame = rect;
            } completion:^(BOOL finished) {
                [detailView removeFromSuperview];
                [transitionContext completeTransition:YES];
            }];
        }];
    }
}

@end
