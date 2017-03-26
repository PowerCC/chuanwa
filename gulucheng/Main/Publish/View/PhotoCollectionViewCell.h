//
//  PhotoCollectionViewCell.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/6.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteButton;

@property (copy, nonatomic) void (^deletePhotoBlock)();

@end
