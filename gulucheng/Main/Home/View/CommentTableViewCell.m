//
//  CommentTableViewCell.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "ReplyCommentContenCell.h"
#import "NSDate+Extend.h"
#import "UITableViewCell+WHC_AutoHeightForCell.h"

static NSString *const ReplyCommentCell = @"replyCommentCell";

@interface CommentTableViewCell () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyCommentTableViewHeightConstraint;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCommentContent:)];
    [self.commmentButton addGestureRecognizer:longPressGestureRecognizer];
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
        _commentLabel.numberOfLines = 0;
        NSDate *confromDate = [NSDate dateWithTimeIntervalSince1970:commentModel.createTime.integerValue / 1000];
        _timeLabel.text = [confromDate timeAgo];
        
        _commentModel = commentModel;
        
        if (commentModel.replyCount.integerValue > 0) {
            self.replyCommentModelArray = [NSMutableArray arrayWithArray:commentModel.replyList];
        }
        else {
            self.replyCommentModelArray = [NSMutableArray array];
        }
    }
}

- (void)setReplyCommentModelArray:(NSMutableArray *)replyCommentModelArray {
    _replyCommentModelArray = replyCommentModelArray;
//    if (_replyCommentModelArray.count > 0) {
//        [self addReplyView];
//    }
}

- (void)loadReplyData {
    _replyCommentTableView.contentSize = CGSizeMake(0, 0);
    [_replyCommentTableView reloadData];
    _replyCommentTableViewHeightConstraint.constant = _replyCommentTableView.contentSize.height;
    
    [self layoutIfNeeded];
    NSLog(@"replyCommentTableViewHeightConstraint = %f", _replyCommentTableViewHeightConstraint.constant);
}

//- (void)addReplyView {
//    if (_replyCommentModelArray && _replyCommentModelArray.count > 0) {
//        self.replyCommentContentView = [ReplyCommentContentView initWithAutoLayout:self.contentView commentView:_commentLabel replyCommentModelArray:_replyCommentModelArray];
//    }
//}

- (void)deleteReply:(NSIndexPath *)deleteIndexPath {
    // 从数据源中删除
    [_replyCommentModelArray removeObjectAtIndex:deleteIndexPath.row];
    
//    if (_replyCommentModelArray.count > 0) {
//        // 从列表中删除
//        [_replyCommentTableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [_replyCommentTableView layoutIfNeeded];
//        _replyCommentTableViewHeightConstraint.constant = _replyCommentTableView.contentSize.height;
//    }
//    else {
////        _replyCommentTableViewHeightConstraint.constant = 0;
//        [_replyCommentTableView reloadData];
//    }
    
    [_replyCommentTableView reloadData];
    _replyCommentTableViewHeightConstraint.constant = _replyCommentTableView.contentSize.height;
    [self layoutIfNeeded];
}

- (IBAction)headButtonAction:(id)sender {
    if (_headButtonTapBlock) {
        _headButtonTapBlock(_commentModel);
    }
}

- (IBAction)commentContentButtonAction:(id)sender {
    if (_commentContentButtonTapBlock &&_commentModel && _cellIndexPath) {
        _commentContentButtonTapBlock(_commentModel, _cellIndexPath);
    }
}

- (void)longPressCommentContent:(UILongPressGestureRecognizer *)recognizer {
    
    if (recognizer.state != UIGestureRecognizerStateBegan) return;
    
    if (_longPressCommentContentBlock &&_commentModel && _cellIndexPath) {
        _longPressCommentContentBlock(_commentModel, _cellIndexPath);
    }
    
    NSLog(@"longPressCommentContent");
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _replyCommentModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReplyCommentContenCell *commentCell = [tableView dequeueReusableCellWithIdentifier:ReplyCommentCell];
    
    NSInteger row = indexPath.row;
    
    commentCell.commentLabelTopConstraint.constant = 6;
    commentCell.commentLabelBottomConstraint.constant = 6;
    
    if (row == 0) {
        commentCell.commentLabelTopConstraint.constant = 12;
    }
    else if (row == _replyCommentModelArray.count - 1) {
        commentCell.commentLabelBottomConstraint.constant = 12;
    }
    
    WEAKSELF
    commentCell.nickNameTapBlock = ^(NSString *uid) {
        if (weakSelf.nickNameTapBlock) {
            weakSelf.nickNameTapBlock(uid);
        }
    };
    
    commentCell.replyNickNameTapBlock = ^(NSString *replyUid) {
        if (weakSelf.replyNickNameTapBlock) {
            weakSelf.replyNickNameTapBlock(replyUid);
        }
    };
    
    commentCell.longPressReplyContentBlock = ^(CommentReplyModel *commentReplyModel) {
        if (weakSelf.longPressReplyContentBlock) {
            weakSelf.longPressReplyContentBlock(commentReplyModel, indexPath);
        }
    };
    
    NSDictionary *commentReplyDic = _replyCommentModelArray[row];
    if (commentReplyDic && commentReplyDic.count) {
        CommentReplyModel *commentReplyModel = [CommentReplyModel JCParse:commentReplyDic];
        if (commentReplyModel) {
            commentReplyModel.eid = _commentModel.eid;
            [commentCell layoutContent:commentReplyModel rowCount:_replyCommentModelArray.count rowIndex:row];
        }
    }
    
    return commentCell;
}

#pragma mark = UITableViewDelegate Methods
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 41;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReplyCommentContenCell *commentCell = [tableView dequeueReusableCellWithIdentifier:ReplyCommentCell];
    
    NSInteger row = indexPath.row;

    NSDictionary *commentReplyDic = _replyCommentModelArray[row];
    if (commentReplyDic && commentReplyDic.count) {
        CommentReplyModel *commentReplyModel = [CommentReplyModel JCParse:commentReplyDic];
        if (commentReplyModel) {
            CGFloat systemLayoutSizeHeight = [commentCell layoutContent:commentReplyModel rowCount:_replyCommentModelArray.count rowIndex:row];
            NSLog(@"%f", systemLayoutSizeHeight);
            
            return systemLayoutSizeHeight;
        }
        else {
            return 0;
        }
    }
    else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_replyContentTapBlock) {
        NSDictionary *commentReplyDic = _replyCommentModelArray[indexPath.row];
        if (commentReplyDic && commentReplyDic.count) {
            CommentReplyModel *commentReplyModel = [CommentReplyModel JCParse:commentReplyDic];
            if (commentReplyModel) {
                _replyContentTapBlock(commentReplyModel);
            }
        }
    }
}

@end
