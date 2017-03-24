//
//  ReplyCommentTableViewCell.m
//  gulucheng
//
//  Created by PWC on 2017/1/3.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "ReplyCommentTableViewCell.h"

@interface ReplyCommentTableViewCell ()

@end

@implementation ReplyCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.commentLabel = [[UILabel alloc] init];
        _commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _commentLabel.font = [UIFont systemFontOfSize:14.0];
        _commentLabel.numberOfLines = 0;
        _commentLabel.text = @"雷克萨地方记录卡等级分类卡就是地方卡了对方空间按多少分路口阿里山的开发及案例都是空房间爱上对方，打扫房间卡死的风景";
        [self.contentView addSubview:_commentLabel];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_commentLabel]-14-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_commentLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_commentLabel]-12-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_commentLabel)]];
    }
    
    return self;
}

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
        _commentLabel.text = commentModel.comment;
        _commentModel = commentModel;
    }
}

@end
