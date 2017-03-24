//
//  PhotoCommendView.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/11.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface PhotoCommendView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *photoCollectionView;

@property (copy, nonatomic) void (^showCenterBlock)();
@property (copy, nonatomic) void (^photoViewHeightBlock)(float height);
@property (copy, nonatomic) void (^selectedIndexPathBlock)(NSIndexPath *indexPath);
@property (copy, nonatomic) void (^currentPageBlock)(NSInteger currentPage);

- (void)reloadCollectionViewWithPhotoCommendModel:(RecommendModel *)photoCommendModel;

@end
