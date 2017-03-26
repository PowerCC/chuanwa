//
//  ReplyCommentContenCell.m
//  gulucheng
//
//  Created by PWC on 2017/1/18.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "ReplyCommentContenCell.h"

@interface ReplyCommentContenCell ()

@property (strong, nonatomic) UIButton *name1Button;
@property (strong, nonatomic) UIButton *name2Button;

@property (strong, nonatomic) CommentReplyModel *commentReplyModel;

@end

@implementation ReplyCommentContenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.name1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.name2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_name1Button addTarget:self action:@selector(nickNameTap) forControlEvents:UIControlEventTouchUpInside];
    [_name2Button addTarget:self action:@selector(replyNickNameTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_name1Button];
    [self addSubview:_name2Button];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressReplyContent:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        self.backgroundColor = kCOLOR(237, 237, 237, 1);
    }
    else {
        self.backgroundColor = [UIColor clearColor];
    }
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    if (self.selected) {
//        self.backgroundColor = kCOLOR(237, 237, 237, 1);
//    }
//    else {
//        self.backgroundColor = [UIColor clearColor];
//    }
//}

- (CGFloat)layoutContent:(CommentReplyModel *)commentReplyModel rowCount:(NSInteger)rowCount rowIndex:(NSInteger)rowIndex {
    
    _commentReplyModel = commentReplyModel;
    
    _commentLabel.numberOfLines = 0;
    
    _commentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 112;
    
    UIColor *nameColor = kCOLOR(80, 125, 175, 1.0);
    NSMutableAttributedString *name1AttStr = [[NSMutableAttributedString alloc] initWithString:commentReplyModel.nickName];
    [name1AttStr addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, name1AttStr.length)];
    
    NSMutableAttributedString *name2AttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：", commentReplyModel.replyToNickName]];
    [name2AttStr addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, name2AttStr.length - 1)];
    
    UIColor *commentColor = kCOLOR(68, 68, 68, 1.0);
    NSMutableAttributedString *tempAttStr = [[NSMutableAttributedString alloc] initWithString:@"回复"];
    [tempAttStr addAttribute:NSForegroundColorAttributeName value:commentColor range:NSMakeRange(0, tempAttStr.length)];
    
    NSMutableAttributedString *commentAttStr = [[NSMutableAttributedString alloc] initWithString:commentReplyModel.comment];
    [commentAttStr addAttribute:NSForegroundColorAttributeName value:commentColor range:NSMakeRange(0, commentAttStr.length)];
    
    NSMutableAttributedString *contentAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:name1AttStr];
    [contentAttStr appendAttributedString:tempAttStr];
    [contentAttStr appendAttributedString:name2AttStr];
    [contentAttStr appendAttributedString:commentAttStr];
    [contentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, contentAttStr.length)];
    _commentLabel.attributedText = contentAttStr;
    
    [_commentLabel layoutIfNeeded];
    [self setNeedsLayout];
    
    _name1Button.backgroundColor = [UIColor clearColor];
    [_name1Button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_name1Button setTitle:commentReplyModel.nickName forState:UIControlStateNormal];
    [_name1Button layoutIfNeeded];
    CGFloat name1Width = [_name1Button systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    _name1Button.frame = CGRectMake(0, 0, name1Width, self.bounds.size.height);
    
    _name2Button.backgroundColor = [UIColor clearColor];
    [_name2Button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_name2Button setTitle:commentReplyModel.replyToNickName forState:UIControlStateNormal];
    [_name2Button layoutIfNeeded];
    CGFloat name2Width = [_name2Button systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    _name2Button.frame = CGRectMake(name1Width + 30.0, 0, name2Width, self.bounds.size.height);
    
    [_name1Button setTitle:@"" forState:UIControlStateNormal];
    [_name2Button setTitle:@"" forState:UIControlStateNormal];
    
    CGFloat systemLayoutSizeHeight = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    if (rowIndex == 0) {
        return systemLayoutSizeHeight + 12;
    }
    
    if (rowIndex == rowCount - 1) {
        return systemLayoutSizeHeight + 12;
    }
    
    return systemLayoutSizeHeight + 6;
}

- (void)nickNameTap {
    if (_nickNameTapBlock) {
        _nickNameTapBlock(_commentReplyModel.uid);
    }
}

- (void)replyNickNameTap {
    if (_replyNickNameTapBlock) {
        _replyNickNameTapBlock(_commentReplyModel.replyToUid);
    }
}

- (void)longPressReplyContent:(UILongPressGestureRecognizer *)recognizer {
    
    if (recognizer.state != UIGestureRecognizerStateBegan) return;
    
    if (_longPressReplyContentBlock) {
        _longPressReplyContentBlock(_commentReplyModel);
    }
    
    NSLog(@"longPressReplyContent");
}

@end
