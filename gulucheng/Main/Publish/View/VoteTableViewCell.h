//
//  VoteTableViewCell.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/4.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *voteCircleImageView;
@property (weak, nonatomic) IBOutlet UITextField *voteContentTextField;

@property (copy, nonatomic) void (^deleteCellBlock)(NSInteger index);
@property (copy, nonatomic) void (^textFieldBlock)();

@end
