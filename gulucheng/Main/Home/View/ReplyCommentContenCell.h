//
//  ReplyCommentContenCell.h
//  gulucheng
//
//  Created by PWC on 2017/1/18.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface ReplyCommentContenCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLabelBottomConstraint;

- (CGFloat)layoutContent:(CommentReplyModel *)commentReplyModel rowCount:(NSInteger)rowCount rowIndex:(NSInteger)rowIndex;

@property (copy, nonatomic) void (^nickNameTapBlock)(NSString *uid);
@property (copy, nonatomic) void (^replyNickNameTapBlock)(NSString *relpyUid);
@property (copy, nonatomic) void (^longPressReplyContentBlock)(CommentReplyModel *commentReplyModel);

@end
