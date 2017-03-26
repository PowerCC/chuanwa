//
//  MessageListTableViewCell.h
//  gulucheng
//
//  Created by PWC on 2017/2/3.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "EaseUI.h"

@interface MessageListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadMessagesCountLabel;

@property (weak, nonatomic) IBOutlet UIView *unreadMessagesCountView;

/** @brief 会话对象 */
@property (weak, nonatomic) id<IConversationModel> model;

@property (weak, nonatomic) UserModel *userModel;

+ (MessageListTableViewCell *)cellFromNib;

@end
