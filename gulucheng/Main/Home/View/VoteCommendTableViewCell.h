//
//  VoteCommendTableViewCell.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/13.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteCommendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIView *ratioLeftView;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;
@property (weak, nonatomic) IBOutlet UIView *ratioRightView;
@property (weak, nonatomic) IBOutlet UILabel *voteContentLabel;

@end
