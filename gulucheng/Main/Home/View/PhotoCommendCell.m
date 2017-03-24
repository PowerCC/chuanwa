//
//  PhotoCommendCell.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/11.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "PhotoCommendCell.h"

@implementation PhotoCommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [_nameLabel addGestureRecognizer:labelTapGestureRecognizer];
    
    UITapGestureRecognizer *photoTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTouchUpInside:)];
    [_photoImageView addGestureRecognizer:photoTapGestureRecognizer];
}

- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer {
    
    UILabel *label= (UILabel *)recognizer.view;
    
    if (_showCenterBlock) {
        _showCenterBlock();
    }
    
    NSLog(@"%@被点击了",label.text);
}

- (void)photoTouchUpInside:(UITapGestureRecognizer *)recognizer {
    if (_photoSelectedBlock) {
        _photoSelectedBlock();
    }
}

@end
