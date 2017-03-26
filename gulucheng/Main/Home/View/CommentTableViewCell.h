//
//  CommentTableViewCell.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyCommentContentView.h"
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *commmentButton;

@property (weak, nonatomic) IBOutlet UITableView *replyCommentTableView;

//@property (strong, nonatomic) ReplyCommentContentView *replyCommentContentView;
@property (strong, nonatomic) CommentModel *commentModel;

@property (strong, nonatomic) NSMutableArray *replyCommentModelArray;

@property (assign, nonatomic) CGFloat cellHeight;

@property (weak, nonatomic) NSIndexPath *cellIndexPath;

@property (copy, nonatomic) void (^headButtonTapBlock)();
@property (copy, nonatomic) void (^commentContentButtonTapBlock)(CommentModel *commentModel, NSIndexPath *cellIndexPath);
@property (copy, nonatomic) void (^longPressCommentContentBlock)(CommentModel *commentReplyModel, NSIndexPath *cellIndexPath);

@property (copy, nonatomic) void (^nickNameTapBlock)(NSString *uid);
@property (copy, nonatomic) void (^replyNickNameTapBlock)(NSString *relpyUid);
@property (copy, nonatomic) void (^replyContentTapBlock)(CommentReplyModel *commentReplyModel);
@property (copy, nonatomic) void (^longPressReplyContentBlock)(CommentReplyModel *commentReplyModel, NSIndexPath *replyIndexPath);

- (void)loadReplyData;
- (void)deleteReply:(NSIndexPath *)deleteIndexPath;

@end
