//
//  HomePhotoCommendView.m
//  gulucheng
//
//  Created by 许坤志 on 16/9/10.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "DetailPhotoCommendView.h"
#import "PhotoCommendCell.h"
#import "PhotoModel.h"

static NSString * const photoCell = @"DetailPhotoCell";

@interface DetailPhotoCommendView()

@property (nonatomic, strong) RecommendModel *photoCommendModel;
@property (nonatomic, assign) BOOL isFirstIn;

@end

@implementation DetailPhotoCommendView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.isFirstIn = YES;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame));
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))
                                                  collectionViewLayout:flowLayout];
        
        [_photoCollectionView registerNib:[UINib nibWithNibName:@"DetailPhotoCommendCell" bundle:nil]
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
    
    if (_photoCommendModel.distMeter != nil && _photoCommendModel.distMeter.floatValue <= 100) {
        cell.distanceAndTimeAgoLabel.text = [NSString stringWithFormat:@"%.2f米 ∙ %@", _photoCommendModel.distMeter.floatValue, [NSString timeAgo:_photoCommendModel.createTime.integerValue]];
    }
    else {
        cell.distanceAndTimeAgoLabel.text = [NSString stringWithFormat:@"%.2fkm ∙ %@", _photoCommendModel.distKm.floatValue, [NSString timeAgo:_photoCommendModel.createTime.integerValue]];
    }
    
    cell.distanceAndTimeAgoLabel.text = [cell.distanceAndTimeAgoLabel.text stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    cell.businessViewDistanceAndTimeAgoLabel.text = cell.distanceAndTimeAgoLabel.text;
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:_photoCommendModel.avatar.length > 0 ? _photoCommendModel.avatar : _photoCommendModel.avaterUrl]];
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
        if (_photoSelectedBlock) {
            _photoSelectedBlock(indexPath.row);
        }
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_photoSelectedBlock) {
        _photoSelectedBlock(indexPath.row);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _photoCollectionView) {
        
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        
        PhotoCommendCell *cell = (PhotoCommendCell *)[_photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        PhotoModel *photoModel = [_photoCommendModel.eventPicVos objectAtIndex:index];
        
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.picPath]
                               placeholderImage:nil
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          
                                          float imageViewHeight;
                                          if (SCREEN_WIDTH/image.size.width * image.size.height <= 248) {
                                              imageViewHeight = 248;
                                          } else {
                                              imageViewHeight = SCREEN_WIDTH / image.size.width * image.size.height;
                                          }
                                          if (_photoViewHeightBlock) {
                                              _photoViewHeightBlock(imageViewHeight + (_photoCommendModel.bizUid.integerValue == 0 ?
                                                                                       cell.normalView.frame.size.height : cell.businessView.frame.size.height));
                                          }
                                      }];
        
        if (_currentPageBlock) {
            _currentPageBlock(index);
        }
    }
}

- (void)collectionview:(UICollectionView *)collectionView cell:(PhotoCommendCell *)cell photoModel:(PhotoModel *)photoModel indexPath:(NSIndexPath *)indexPath {
    
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.picPath]
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      
                                      if (_photoCommendModel.bizUid.integerValue == 0) {
                                          
                                          if (SCREEN_WIDTH / image.size.width * image.size.height <= 248) {
                                              cell.imageHeightConstraint.constant = 248;
//                                              cell.detailViewTopConstraint.constant = - (248 - SCREEN_WIDTH/image.size.width * image.size.height) / 2;
                                          } else {
                                              cell.imageHeightConstraint.constant = SCREEN_WIDTH / image.size.width * image.size.height;
//                                              cell.detailViewTopConstraint.constant = 0;
                                          }
                                          
                                          if (indexPath.row == 0 && _isFirstIn) {
                                              WEAKSELF
                                              GCD_AFTER(0.0, ^{
                                                  if (weakSelf.photoViewHeightBlock) {
                                                      // 非商家
                                                      weakSelf.photoViewHeightBlock(cell.imageHeightConstraint.constant + cell.normalView.frame.size.height);
                                                  }
                                                  weakSelf.isFirstIn = NO;
                                              });
                                          }
                                      } else {
                                          
                                          if (SCREEN_WIDTH / image.size.width * image.size.height <= 248) {
                                              cell.imageHeightConstraint.constant = 248;
//                                              cell.businessViewTopConstraint.constant = - (248 - SCREEN_WIDTH/image.size.width * image.size.height) / 2;
                                          } else {
                                              cell.imageHeightConstraint.constant = SCREEN_WIDTH / image.size.width * image.size.height;
//                                              cell.businessViewTopConstraint.constant = 0;
                                          }
                                          
                                          if (indexPath.row == 0 && _isFirstIn) {
                                              WEAKSELF
                                              GCD_AFTER(0.0, ^{
                                                  if (weakSelf.photoViewHeightBlock) {
                                                      // 商家
                                                      weakSelf.photoViewHeightBlock(cell.imageHeightConstraint.constant + cell.businessView.frame.size.height);
                                                  }
                                                  weakSelf.isFirstIn = NO;
                                              });
                                          }
                                      }
                                  }];
}

@end
