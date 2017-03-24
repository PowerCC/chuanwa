//
//  CardDetailViewController.h
//  GuluCheng
//
//  Created by 许坤志 on 16/8/16.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseShareViewController.h"
#import "RecommendModel.h"
#import "VoteCommendView.h"
#import "PhotoCommendView.h"
#import "CommendButtomView.h"
#import "ReplyInputView.h"

@interface CardDetailViewController : BaseShareViewController

// 该view是评论传递列表的载体，动画加载完成之前处于隐藏状态
@property (weak, nonatomic) IBOutlet UIView *cardDetailView;

@property (assign, nonatomic) BOOL isfromNewNotice;

@property (strong, nonatomic) ReplyInputView *replyInputView;
@property (nonatomic, strong) RecommendModel *recommendModel;
@property (nonatomic, strong) VoteCommendView *voteCommendView;

@property (nonatomic, strong) CommendButtomView *commendButtomView;

@property (copy, nonatomic) void (^removeThisCardBlock)();
@property (copy, nonatomic) void (^commentTimesBlock)(RecommendModel *recommendModel);

@end
