//
//  PhotoCollectionViewCell.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/6.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell


- (IBAction)photoDeleteButtonAction:(id)sender {
    if (_deletePhotoBlock) {
        _deletePhotoBlock();
    }
}

@end
