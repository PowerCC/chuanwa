//
//  PublishCollectionViewCell.h
//  GuluCheng
//
//  Created by 许坤志 on 16/8/18.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *voteImageView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *spreadCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDaysLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelCenterConstraint;

@end
