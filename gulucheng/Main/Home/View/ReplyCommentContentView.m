//
//  ReplyCommentContentView.m
//  gulucheng
//
//  Created by PWC on 2017/1/3.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "ReplyCommentContentView.h"

@interface ReplyCommentContentView ()

@property (strong, nonatomic) NSMutableArray *commentReplyModelArray;
@property (assign, nonatomic) CGFloat tempV;
@property (assign, nonatomic) NSUInteger replyIndex;

@end

@implementation ReplyCommentContentView

- (void)dealloc {
    self.replyDelegate = nil;
}

+ (instancetype)initWithAutoLayout:(UIView *)superView commentView:(UIView *)commentView replyCommentModelArray:(NSMutableArray *)replyCommentModelArray {
    
    ReplyCommentContentView *view = [[ReplyCommentContentView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.autoresizingMask = UIViewAutoresizingNone;
    view.backgroundColor = kCOLOR(247, 247, 247, 1.0);
    [superView insertSubview:view belowSubview:commentView];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(68)-[view]-(16)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(view)]];
    
    NSString *v = [NSString stringWithFormat:@"V:|-(%f)-[view]-(16)-|", CGRectGetMaxY(commentView.frame) + 12];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:v
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(commentView, view)]];
    
    view.tempV = 12.0;
    view.replyIndex = 0;
    view.commentReplyModelArray = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *commentReplyDic in replyCommentModelArray) {
        CommentReplyModel *commentReplyModel = [CommentReplyModel JCParse:commentReplyDic];
        
        [view.commentReplyModelArray addObject:commentReplyModel];
        [view layoutContent:commentReplyModel];
        view.replyIndex += 1;
    }
    
    return view;
}

- (void)replyComment:(UIButton *)button {
    if (self.replyDelegate && [self.replyDelegate respondsToSelector:@selector(replyCommentContentItemAction:)]) {
        CommentReplyModel *commentReplyModel = self.commentReplyModelArray[button.tag];
        [self.replyDelegate replyCommentContentItemAction:commentReplyModel];
    }
}

- (void)layoutContent:(CommentReplyModel *)commentReplyModel {
    
    UIView *commentReplyView = [[UIView alloc] init];
    commentReplyView.translatesAutoresizingMaskIntoConstraints = NO;
    commentReplyView.autoresizingMask = UIViewAutoresizingNone;
    
//    commentReplyView.backgroundColor = kCOLOR(249, 87, 84, 1);
    [self addSubview:commentReplyView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(14)-[commentReplyView]-(14)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(commentReplyView)]];
    
    NSString *v = [NSString stringWithFormat:@"V:|-(%f)-[commentReplyView]-(>=12)-|", self.tempV];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:v
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(commentReplyView)]];
    
    
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    commentLabel.numberOfLines = 0;
    commentLabel.autoresizingMask = UIViewAutoresizingNone;
    commentLabel.tag = 2017;
    
    UIColor *nameColor = kCOLOR(80, 125, 175, 1.0);
    NSMutableAttributedString *name1AttStr = [[NSMutableAttributedString alloc] initWithString:commentReplyModel.nickName];
    [name1AttStr addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, name1AttStr.length)];
    
    NSMutableAttributedString *name2AttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:", commentReplyModel.replyToNickName]];
    [name2AttStr addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, name2AttStr.length - 1)];
    
    NSMutableAttributedString *tempAttStr = [[NSMutableAttributedString alloc] initWithString:@"回复"];
    
    NSMutableAttributedString *commentAttStr = [[NSMutableAttributedString alloc] initWithString:commentReplyModel.comment];
    
    NSMutableAttributedString *contentAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:name1AttStr];
    [contentAttStr appendAttributedString:tempAttStr];
    [contentAttStr appendAttributedString:name2AttStr];
    [contentAttStr appendAttributedString:commentAttStr];
    [contentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, contentAttStr.length)];
    commentLabel.attributedText = contentAttStr;
                                                                       
    [commentReplyView addSubview:commentLabel];
    [commentReplyView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[commentLabel]-(0)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(commentLabel)]];
    
    [commentReplyView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[commentLabel]-(2)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(commentLabel)]];

    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nameButton.translatesAutoresizingMaskIntoConstraints = NO;
    nameButton.autoresizingMask = UIViewAutoresizingNone;
//    nameButton.backgroundColor = kCOLOR(0, 0, 0, 0.4);
    nameButton.tag = self.replyIndex;
    [nameButton addTarget:self action:@selector(replyComment:) forControlEvents:UIControlEventTouchUpInside];
    [commentReplyView addSubview:nameButton];
    [commentReplyView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[nameButton]-(0)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(nameButton)]];
    
    [commentReplyView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[nameButton]-(0)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(nameButton)]];
    
    [commentReplyView layoutIfNeeded];
    
    commentLabel.preferredMaxLayoutWidth = CGRectGetWidth(commentLabel.bounds);
    CGFloat systemLayoutSizeHeight = [commentLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    self.tempV += systemLayoutSizeHeight + 12;
}
@end
