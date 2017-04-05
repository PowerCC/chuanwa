//
//  HomePhotoCommendView.h
//  gulucheng
//
//  Created by 许坤志 on 16/9/10.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface DetailPhotoCommendView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *photoCollectionView;

@property (nonatomic, assign) NSInteger currentPhotoPage;

// 展示他人中心功能
@property (copy, nonatomic) void (^showCenterBlock)();
// 评论 传递 页面的位置
@property (copy, nonatomic) void (^photoViewHeightBlock)(float height);
// 展示pagecontrol功能
@property (copy, nonatomic) void (^currentPageBlock)(NSInteger currentPage);

@property (copy, nonatomic) void (^photoSelectedBlock)(NSInteger currentIndex);

- (void)reloadCollectionViewWithPhotoCommendModel:(RecommendModel *)photoCommendModel;

@end
