//
//  ReplyCommentContentView.h
//  gulucheng
//
//  Created by PWC on 2017/1/3.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@protocol ReplyCommentContentViewDelegate <NSObject>

- (void)replyCommentContentItemAction:(CommentReplyModel *)commentReplyModel;

@end


@interface ReplyCommentContentView : UIView

@property (strong, nonatomic) NSLayoutConstraint *viewHeightConstraint;

@property (strong, nonatomic) NSMutableArray *replyCommentModelArray;

@property (weak, nonatomic) id<ReplyCommentContentViewDelegate> replyDelegate;

+ (instancetype)initWithAutoLayout:(UIView *)superView commentView:(UIView *)commentView replyCommentModelArray:(NSMutableArray *)replyCommentModelArray;

@end
