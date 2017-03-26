//
//  MessageListTableViewCell.m
//  gulucheng
//
//  Created by PWC on 2017/2/3.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "MessageListTableViewCell.h"

@implementation MessageListTableViewCell

+ (MessageListTableViewCell *)cellFromNib {
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MessageListTableViewCell" owner:nil options:nil];
    MessageListTableViewCell *cell = [nibs lastObject];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_avatarImageView circular];
    
    _unreadMessagesCountView.layer.cornerRadius = 7.75;
    _unreadMessagesCountView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(id<IConversationModel>)model {
    _model = model;
    
    _avatarImageView.image = nil;
    _genderImageView.image = nil;
    _nameLabel.text = nil;
    _contentLabel.text = nil;
    _contentLabel.attributedText = nil;
    _timeLabel.text = nil;
    _unreadMessagesCountLabel.text = nil;
    _unreadMessagesCountView.hidden = YES;
    
    if (_model) {
        
//        NSDictionary *ext = _model.conversation.latestMessage.ext;
//        
//        if (ext) {
//            _nameLabel.text = ext[@"nickname"];
//            
//            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:ext[@"photo"]] placeholderImage:[UIImage imageNamed:@"logo"]];
//            
//            NSString *gender = ext[@"gender"];
//            if ([gender isEqualToString:@"1"]) {
//                _genderImageView.image = [UIImage imageNamed:@"im-boy"];
//            }
//            else if ([gender isEqualToString:@"0"]) {
//                _genderImageView.image = [UIImage imageNamed:@"im-girl"];
//            }
//        }
        
        if (_userModel) {
            _nameLabel.text = _userModel.nickName;
            
            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.avatar] placeholderImage:[UIImage imageNamed:@"logo"]];
            
            NSString *gender = _userModel.gender;
            if ([gender isEqualToString:@"1"]) {
                _genderImageView.image = [UIImage imageNamed:@"im-boy"];
            }
            else if ([gender isEqualToString:@"2"]) {
                _genderImageView.image = [UIImage imageNamed:@"im-girl"];
            }
        }
        
        if (_model.conversation.unreadMessagesCount > 0) {
            _unreadMessagesCountLabel.text = [NSString stringWithFormat:@"%d", _model.conversation.unreadMessagesCount];
            _unreadMessagesCountView.hidden = NO;
        }
    }
}

@end
