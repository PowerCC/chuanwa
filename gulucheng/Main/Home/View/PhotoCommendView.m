//
//  PhotoCommendView.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/11.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "PhotoCommendView.h"
#import "PhotoCommendCell.h"

#import "PhotoModel.h"

#define imageBaseHeight (iPhone6_6sPlus ? 490 : ((iPhone4_4s || iPhone5_5s) ? 380 : 440))

static NSString * const photoCell = @"PhotoCell";
//static NSInteger const imageBaseHeight = ((iPhone4_4s || iPhone5_5s) ? 360 : 440);

@interface PhotoCommendView()

@property (nonatomic, strong) RecommendModel *photoCommendModel;
@property (nonatomic, assign) float height;

@end

@implementation PhotoCommendView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame));
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))
                                                  collectionViewLayout:flowLayout];
        
        _photoCollectionView.backgroundColor = BGGrayColor;
        
        [_photoCollectionView registerNib:[UINib nibWithNibName:@"PhotoCommendCell" bundle:nil]
               forCellWithReuseIdentifier:photoCell];
        _photoCollectionView.dataSource = self;
        _photoCollectionView.delegate = self;
        _photoCollectionView.bounces = NO;
        _photoCollectionView.pagingEnabled = YES;
        _photoCollectionView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:_photoCollectionView];
        
    }
    return self;
}

- (void)reloadCollectionViewWithPhotoCommendModel:(RecommendModel *)photoCommendModel {
    
//    PhotoModel *photoModel = [_photoCommendModel.eventPicVos objectAtIndex:0];
//    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:photoModel.picPath];
//    float height = cachedImage.size.height + 10 - 6;
    
//    PhotoModel *photoModel = [photoCommendModel.eventPicVos objectAtIndex:0];
//    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:photoModel.picPath];
//    float height = cachedImage.size.height * (SCREEN_WIDTH / cachedImage.size.width);
//    
//    
//    if (_photoViewHeightBlock) {
//        _photoViewHeightBlock(height);
//    }
    
    _photoCommendModel = photoCommendModel;
    [_photoCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _photoCommendModel.eventPicVos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCell
                                                                       forIndexPath:indexPath];
    
    PhotoModel *photoModel = [_photoCommendModel.eventPicVos objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = _photoCommendModel.nickName;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:_photoCommendModel.avaterUrl]];
    [cell.nickNameButton setTitle:_photoCommendModel.nickName forState:UIControlStateNormal];
    [cell.phoneButton setTitle:_photoCommendModel.mobile forState:UIControlStateNormal];
    cell.genderImageView.image = [UIImage imageNamed:_photoCommendModel.gender.integerValue == 1 ? @"home-boy" : @"home-girl"];

    
    if (!_photoCommendModel.remark) {
        cell.describLabelTopConstraint.constant = 0;
    }
    
    if (_photoCommendModel.bizUid.integerValue == 0) {
        cell.businessView.hidden = YES;
        cell.describeLabel.text = _photoCommendModel.remark;
    } else {
        cell.normalView.hidden = YES;
        cell.slogenLabel.text = _photoCommendModel.slogen;
        if (_photoCommendModel.mobile) {
            cell.phoneImageView.hidden = NO;
            [cell.phoneButton setTitle:_photoCommendModel.mobile forState:UIControlStateNormal];
        }
    }
    
    [self collectionview:collectionView cell:cell photoModel:photoModel indexPath:indexPath];
    
    cell.showCenterBlock = ^{
        if (_showCenterBlock) {
            _showCenterBlock();
        }
    };
    
    cell.photoSelectedBlock = ^{
        if (_selectedIndexPathBlock) {
            _selectedIndexPathBlock(indexPath);
        }
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedIndexPathBlock) {
        _selectedIndexPathBlock(indexPath);
    }
}

/*
- (void)collectionview:(UICollectionView *)collectionView cell:(PhotoCommendCell *)cell photoModel:(PhotoModel *)photoModel indexPath:(NSIndexPath *)indexPath {
    
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.picPath]
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      
                                      if (SCREEN_WIDTH / image.size.width * image.size.height <= 248) {
                                          cell.imageHeightConstraint.constant = 248;
                                          
                                          cell.detailViewTopConstraint.constant = - (248 - SCREEN_WIDTH/image.size.width * image.size.height) / 2;
                                      } else {
                                          cell.imageHeightConstraint.constant = SCREEN_WIDTH / image.size.width * image.size.height;
                                      }
                                      
                                      if (indexPath.row == 0 && _isFirstIn) {
                                          WEAKSELF
                                          GCD_AFTER(0.0, ^{
                                              if (weakSelf.photoViewHeightBlock) {
                                                  // 非商家 商家
                                                  weakSelf.photoViewHeightBlock(cell.imageHeightConstraint.constant + (_photoCommendModel.bizUid.integerValue == 0 ? cell.normalView.frame.size.height : 108));
                                              }
                                              weakSelf.isFirstIn = NO;
                                          });
                                      }
                                  }];
}
 */

- (void)collectionview:(UICollectionView *)collectionView cell:(PhotoCommendCell *)cell photoModel:(PhotoModel *)photoModel indexPath:(NSIndexPath *)indexPath {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.color = [UIColor grayColor];
    //设置显示位置
    indicator.center = CGPointMake(self.centerX, SCREEN_HEIGHT/2 - 100);
    //将这个控件加到父容器中。
    [cell.photoImageView addSubview:indicator];
    
    [indicator startAnimating];
    
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.picPath]
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      
                                      [indicator stopAnimating];
                                      
                                      if (_photoCommendModel.bizUid.integerValue == 0) {
                                          // 如果图片高度小于最基本高度的情况
                                          if (SCREEN_WIDTH/image.size.width * image.size.height <= imageBaseHeight) {
                                              cell.imageHeightConstraint.constant = imageBaseHeight;
                                              // 设置normalView的位置
                                              cell.detailViewTopConstraint.constant = - (imageBaseHeight - SCREEN_WIDTH/image.size.width * image.size.height) / 2;
                                          } else {
                                              if (image.size.width > 0) {
                                                  cell.imageHeightConstraint.constant = SCREEN_WIDTH/image.size.width * image.size.height;
                                              }
                                              
                                              float buttomViewHeight = _photoCommendModel.eventPicVos.count > 1 ? commendButtomViewPageHeight : commendButtomViewHeight;
                                              float leftBlackSpace = SCREEN_HEIGHT - NavigationBarHeight - buttomViewHeight - cell.imageHeightConstraint.constant;
                                              
                                              GCD_AFTER(0.0, ^{
                                                  
                                                  float normalViewHeight = cell.normalView.frame.size.height;
                                                  
                                                  if (normalViewHeight <= leftBlackSpace) {
                                                      cell.detailViewTopConstraint.constant = 0;
                                                  }
                                                  else {
                                                      // 移动的距离就是空白间隙与normalView高度之间的差
                                                      cell.detailViewTopConstraint.constant = leftBlackSpace - normalViewHeight;
                                                  }
                                              });
                                          }
                                      }
                                      else {
                                          // 如果图片高度小于最基本高度的情况
                                          if (SCREEN_WIDTH/image.size.width * image.size.height <= imageBaseHeight) {
                                              cell.imageHeightConstraint.constant = imageBaseHeight;
                                              // 设置normalView的位置
                                              cell.businessViewTopConstraint.constant = - (imageBaseHeight - SCREEN_WIDTH/image.size.width * image.size.height) / 2;
                                          } else {
                                              if (image.size.width > 0) {
                                                  cell.imageHeightConstraint.constant = SCREEN_WIDTH/image.size.width * image.size.height;
                                              }
                                              
                                              float buttomViewHeight = _photoCommendModel.eventPicVos.count > 1 ? commendButtomViewPageHeight : commendButtomViewHeight;
                                              float leftBlackSpace = SCREEN_HEIGHT - NavigationBarHeight - buttomViewHeight - cell.imageHeightConstraint.constant;
                                              
                                              GCD_AFTER(0.0, ^{
                                                  
                                                  float businessViewHeight = cell.businessView.frame.size.height;
                                                  
                                                  if (businessViewHeight <= leftBlackSpace) {
                                                      cell.businessViewTopConstraint.constant = 0;
                                                  }
                                                  else {
                                                      // 移动的距离就是空白间隙与normalView高度之间的差
                                                      cell.businessViewTopConstraint.constant = leftBlackSpace - businessViewHeight;
                                                  }
                                              });
                                          }
                                      }
                                  }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _photoCollectionView) {
        
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        
        if (_currentPageBlock) {
            _currentPageBlock(index);
        }
    }
}

@end
