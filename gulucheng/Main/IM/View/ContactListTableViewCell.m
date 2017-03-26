//
//  ContactListTableViewCell.m
//  GuluCheng
//
//  Created by PWC on 2017/2/8.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "ContactListTableViewCell.h"

@implementation ContactListTableViewCell

+ (ContactListTableViewCell *)cellFromNib {
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ContactListTableViewCell" owner:nil options:nil];
    ContactListTableViewCell *cell = [nibs lastObject];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_avatarImageView circular];
    
    _removeBlacklistButton.layer.cornerRadius = 2.0;
    _removeBlacklistButton.layer.masksToBounds = YES;
    _removeBlacklistButton.layer.borderColor = kCOLOR(204, 204, 204, 1).CGColor;
    _removeBlacklistButton.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserModel:(UserModel *)model {
    _userModel = model;
    
    _avatarImageView.image = nil;
    _genderImageView.image = nil;
    _nameLabel.text = nil;
    _removeBlacklistButton.hidden = YES;

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
}

- (IBAction)gotoOtherCenterAction:(id)sender {
    if (_gotoOtherCenter) {
        _gotoOtherCenter(_userModel.userID);
    }
}

- (IBAction)removeBlacklistAction:(id)sender {
    if (_removeBlacklist) {
        _removeBlacklist(_userModel.nickName, _userModel.imUname);
    }
}

@end
