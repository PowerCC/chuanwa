//
//  MagicMoveInverseTransition.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/29.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "MagicMoveInverseTransition.h"
#import "HomeViewController.h"
#import "CardDetailViewController.h"
#import "PhotoCommendCell.h"

@implementation MagicMoveInverseTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 获取动画前后两个VC 和 发生的容器containerView
    CardDetailViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    HomeViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    
    // textCommendView 组件
    UIView *textSnapShotView;
    if ([fromVC.recommendModel.eventType isEqualToString:TextEvent]) {
        textSnapShotView = [fromVC.textCommendView.textView snapshotViewAfterScreenUpdates:NO];
        textSnapShotView.frame = [containerView convertRect:fromVC.textCommendView.textView.frame fromView:fromVC.textCommendView.textView.superview];
        fromVC.textCommendView.textView.hidden = YES;
    }
    
    // voteCommendView 组件
    UIView *voteSnapShotView;
    if ([fromVC.recommendModel.eventType isEqualToString:VoteEvent]) {
        voteSnapShotView = [fromVC.voteCommendView.voteView snapshotViewAfterScreenUpdates:NO];
        voteSnapShotView.frame = [containerView convertRect:fromVC.voteCommendView.voteView.frame fromView:fromVC.voteCommendView.voteView.superview];
        fromVC.voteCommendView.voteView.hidden = YES;
    }
    
    if ([fromVC.recommendModel.eventType isEqualToString:PictureEvent]) {
        
    }
    
    // buttomView 组件
    UIView *buttomSnapShotView = [fromVC.commendButtomView snapshotViewAfterScreenUpdates:NO];
    buttomSnapShotView.frame = [containerView convertRect:fromVC.commendButtomView.frame fromView:fromVC.commendButtomView.superview];
    fromVC.commendButtomView.hidden = YES;
    
    /*
    PhotoCommendCell *fromCell = (PhotoCommendCell *)[fromVC.photoCommendView.photoCollectionView cellForItemAtIndexPath:toVC.indexPath];
    
    // 在前一个VC上创建一个截图
    UIView *snapShotView = [fromCell.photoImageView snapshotViewAfterScreenUpdates:NO];
    snapShotView.backgroundColor = [UIColor clearColor];
    snapShotView.frame = [containerView convertRect:fromCell.photoImageView.frame fromView:fromCell.photoImageView.superview];
    fromCell.photoImageView.hidden = YES;
    
    // 初始化后一个VC的位置
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    
    // 获取toVC中图片的位置
    PhotoCommendCell *toCell = (PhotoCommendCell *)[toVC.photoCommendView.photoCollectionView cellForItemAtIndexPath:toVC.indexPath];
    toCell.photoImageView.hidden = YES;
    
    // 顺序很重要，
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:snapShotView];
     */
    
    // 发生动画
    
    // 把动画前后的两个ViewController加到容器中,顺序很重要,snapShotView在上方
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    // [containerView addSubview:snapShotView];
    
    // 公共部分
    fromVC.cardDetailView.hidden = YES;
    fromVC.replyInputView.hidden = YES;
    
    // textCommendView 组件
    fromVC.textCommendView.textView.hidden = YES;
    [containerView addSubview:textSnapShotView];
    
    // voteCommendView 组件
    fromVC.voteCommendView.voteView.hidden = YES;
    [containerView addSubview:voteSnapShotView];
    
    // buttomView 组件
    toVC.commendButtomView.hidden = YES;
    [containerView addSubview:buttomSnapShotView];
    
    // 动起来。第二个控制器的透明度0~1；让截图SnapShotView的位置更新到最新；
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0f
         usingSpringWithDamping:1 initialSpringVelocity:0.f options:0 animations:^{
             
             [containerView layoutIfNeeded];
             toVC.view.alpha = 1.0;
             
             // textCommendView 组件
             textSnapShotView.frame = [containerView convertRect:toVC.textCommendView.textView.frame fromView:toVC.textCommendView.textView.superview];
             
             // voteCommendView 组件
             voteSnapShotView.frame = [containerView convertRect:toVC.voteCommendView.voteView.frame fromView:toVC.voteCommendView.voteView.superview];
             
             // buttomView 组件
             buttomSnapShotView.frame = [containerView convertRect:toVC.commendButtomView.frame fromView:toVC.commendButtomView.superview];
             
         } completion:^(BOOL finished) {
             
             // 公共部分
             fromVC.cardDetailView.hidden = NO;
             fromVC.replyInputView.hidden = NO;
             
             // textCommendView 组件
             fromVC.textCommendView.textView.hidden = NO;
             toVC.textCommendView.textView.hidden = NO;
             [textSnapShotView removeFromSuperview];
             
             // voteCommendView 组件
             fromVC.voteCommendView.voteView.hidden = NO;
             toVC.voteCommendView.voteView.hidden = NO;
             [voteSnapShotView removeFromSuperview];
             
             // buttomView 组件
             toVC.commendButtomView.hidden = NO;
             fromVC.commendButtomView.hidden = NO;
             [buttomSnapShotView removeFromSuperview];
             
             // 告诉系统动画结束
             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
         }];
}

@end
