//
//  VoteTableViewCell.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/4.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "VoteTableViewCell.h"

@implementation VoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButtonAction:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    if (_deleteCellBlock) {
        _voteContentTextField.text = nil;
        _voteCircleImageView.image = [UIImage imageNamed:@"publish-voteCircleDisable"];
        _deleteCellBlock(senderButton.tag);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_textFieldBlock) {
        _textFieldBlock();
    }
    
    if (_voteContentTextField.text.length + string.length - range.length >= 1) {
        _voteCircleImageView.image = [UIImage imageNamed:@"publish-voteCircleAble"];
    } else {
        _voteCircleImageView.image = [UIImage imageNamed:@"publish-voteCircleDisable"];
    }
    
    if (textField == _voteContentTextField) {
        //限制输入字符个数
        if ((_voteContentTextField.text.length + string.length - range.length > 16) ) {
            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    _voteCircleImageView.image = [UIImage imageNamed:@"publish-voteCircleDisable"];
    
    return YES;
}

@end
