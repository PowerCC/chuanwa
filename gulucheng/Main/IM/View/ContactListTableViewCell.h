//
//  ContactListTableViewCell.h
//  GuluCheng
//
//  Created by PWC on 2017/2/8.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "EaseUI.h"

@interface ContactListTableViewCell : UITableViewCell

typedef void(^GotoOtherCenter)(NSString *userID);
typedef void(^RemoveBlacklist)(NSString *nickName, NSString *imUname);

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *removeBlacklistButton;

/** @brief 用户model */
@property (weak, nonatomic) id<IUserModel> model;

@property (weak, nonatomic) UserModel *userModel;

@property (copy, nonatomic) GotoOtherCenter gotoOtherCenter;
@property (copy, nonatomic) RemoveBlacklist removeBlacklist;

+ (ContactListTableViewCell *)cellFromNib;

@end
