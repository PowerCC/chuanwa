//
//  PhotoCommendCell.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/11.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCommendCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;

@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *slogenLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceAndTimeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessViewDistanceAndTimeAgoLabel;

@property (weak, nonatomic) IBOutlet UIButton *nickNameButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

// 图片的高度 的 constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
// 描述文字 的 top constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *describLabelTopConstraint;
// 姓名 性别 描述文字 的 view 的 top 的 constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewTopConstraint;

// 商家 的 view 的 top 的 constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *businessViewTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UIView *businessView;

@property (copy, nonatomic) void (^showCenterBlock)();
@property (copy, nonatomic) void (^photoSelectedBlock)();

@end
