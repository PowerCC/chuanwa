//
//  NotificationCollectionViewCell.h
//  GuluCheng
//
//  Created by 许坤志 on 16/8/22.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *notificationCloseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *voteImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commendTimeLabel;

@end
