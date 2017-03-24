//
//  MagicMoveTransition.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/29.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "MagicMoveTransition.h"
#import "HomeViewController.h"
#import "CardDetailViewController.h"
#import "PhotoCommendCell.h"

@implementation MagicMoveTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // 获取两个VC 和 动画发生的容器
    HomeViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CardDetailViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // textCommendView 组件
    UIView *textSnapShotView;
    if ([fromVC.currentRecommendModel.eventType isEqualToString:TextEvent]) {
        textSnapShotView = [fromVC.textCommendView.textView snapshotViewAfterScreenUpdates:NO];
        textSnapShotView.frame = [containerView convertRect:fromVC.textCommendView.textView.frame fromView:fromVC.textCommendView.textView.superview];
        fromVC.textCommendView.textView.hidden = YES;
    }
    
    // voteCommendView 组件
    UIView *voteSnapShotView;
    if ([fromVC.currentRecommendModel.eventType isEqualToString:VoteEvent]) {
        voteSnapShotView = [fromVC.voteCommendView.voteView snapshotViewAfterScreenUpdates:NO];
        voteSnapShotView.frame = [containerView convertRect:fromVC.voteCommendView.voteView.frame fromView:fromVC.voteCommendView.voteView.superview];
        fromVC.voteCommendView.voteView.hidden = YES;
    }
    
    if ([fromVC.currentRecommendModel.eventType isEqualToString:PictureEvent]) {
        
    }
    
    // buttomView 组件
    UIView *buttomSnapShotView = [fromVC.commendButtomView snapshotViewAfterScreenUpdates:NO];
    buttomSnapShotView.frame = [containerView convertRect:fromVC.commendButtomView.frame fromView:fromVC.commendButtomView.superview];
    fromVC.commendButtomView.hidden = YES;
    
    /*
    // 对Cell上的 imageView 截图，同时将这个 imageView 本身隐藏
    PhotoCommendCell *fromCell = (PhotoCommendCell *)[fromVC.photoCommendView.photoCollectionView cellForItemAtIndexPath:fromVC.indexPath];
    
    UIView *snapShotView = [fromCell.photoImageView snapshotViewAfterScreenUpdates:NO];
    
    snapShotView.frame = fromVC.finalCellRect = [containerView convertRect:fromCell.photoImageView.frame fromView:fromCell.photoImageView.superview];
    fromCell.photoImageView.hidden = YES;
    
    
    
    // 设置第二个控制器的位置、透明度
    PhotoCommendCell *toCell = (PhotoCommendCell *)[toVC.photoCommendView.photoCollectionView cellForItemAtIndexPath:fromVC.indexPath];
    NSLog(@"--------------%@------------", toCell);
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toCell.photoImageView.hidden = YES;
     
    [containerView addSubview:snapShotView];
     */
    
    
    // 把动画前后的两个ViewController加到容器中,顺序很重要,snapShotView在上方
    [containerView addSubview:toVC.view];
    
    // textCommendView 组件
    toVC.cardDetailView.hidden = YES;
    toVC.textCommendView.textView.hidden = YES;
    [containerView addSubview:textSnapShotView];
    
    // voteCommendView 组件
    toVC.cardDetailView.hidden = YES;
    toVC.voteCommendView.voteView.hidden = YES;
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
             
             // snapShotView.frame = CGRectMake(0, -16, snapShotView.frame.size.width, snapShotView.frame.size.height);
             
             // textCommendView 组件
             textSnapShotView.frame = [containerView convertRect:toVC.textCommendView.textView.frame fromView:toVC.textCommendView.textView.superview];
             
             // voteCommendView 组件
             voteSnapShotView.frame = [containerView convertRect:toVC.voteCommendView.voteView.frame fromView:toVC.voteCommendView.voteView.superview];
             
             // buttomView 组件
             buttomSnapShotView.frame = [containerView convertRect:toVC.commendButtomView.frame fromView:toVC.commendButtomView.superview];
             
         } completion:^(BOOL finished) {
             
             // 为了让回来的时候，cell上的图片显示，必须要让cell上的图片显示出来
//             toCell.photoImageView.hidden = NO;
//             fromCell.photoImageView.hidden = NO;
//             [snapShotView removeFromSuperview];
             
             // textCommendView 组件
             toVC.cardDetailView.hidden = NO;
             toVC.textCommendView.textView.hidden = NO;
             fromVC.textCommendView.textView.hidden = NO;
             [textSnapShotView removeFromSuperview];
             
             // voteCommendView 组件
             toVC.cardDetailView.hidden = NO;
             toVC.voteCommendView.voteView.hidden = NO;
             fromVC.voteCommendView.voteView.hidden = NO;
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
