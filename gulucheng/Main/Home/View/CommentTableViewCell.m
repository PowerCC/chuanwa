//
//  CommentTableViewCell.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "NSDate+Extend.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentModel:(CommentModel *)commentModel {
    if (commentModel) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.avatar]
                                     placeholderImage:[UIImage imageNamed:@"home-commentDefaultHead"]];
        _genderImageView.image = [UIImage imageNamed:commentModel.gender.integerValue == 1 ? @"home-boy" : @"home-girl"];
        _nickNameLabel.text = commentModel.nickName;
        _commentLabel.text = commentModel.comment;
        NSDate *confromDate = [NSDate dateWithTimeIntervalSince1970:commentModel.createTime.integerValue / 1000];
        _timeLabel.text = [confromDate timeAgo];
        
        _commentModel = commentModel;
        
        if (commentModel.replyCount.integerValue > 0) {
            self.replyCommentModelArray = [NSMutableArray arrayWithArray:commentModel.replyList];
        }
    }
}

- (void)setReplyCommentModelArray:(NSMutableArray *)replyCommentModelArray {
    _replyCommentModelArray = replyCommentModelArray;
    if (_replyCommentModelArray.count > 0) {
        [self addReplyView];
    }
}

- (void)addReplyView {
    if (_replyCommentModelArray && _replyCommentModelArray.count > 0) {
        self.replyCommentContentView = [ReplyCommentContentView initWithAutoLayout:self.contentView commentView:_commentLabel replyCommentModelArray:_replyCommentModelArray];
    }
}

- (IBAction)headButtonAction:(id)sender {
    if (_headButtonTapBlock) {
        _headButtonTapBlock(_commentModel);
    }
}

- (IBAction)commentContentButtonAction:(id)sender {
    if (_commentContentButtonTapBlock) {
        _commentContentButtonTapBlock(_commentModel);
    }
}

@end
