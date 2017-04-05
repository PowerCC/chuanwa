//
//  ShareAppsView.m
//  gulucheng
//
//  Created by xukz on 16/9/21.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "ShareAppsView.h"
#import "AppsView.h"

#define ShareAppsViewHeight 237

@interface ShareAppsView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) AppsView *appsView;

@end

@implementation ShareAppsView

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        [self internalConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalConfig];
    }
    return self;
}

- (void)internalConfig {
    _backView = [[UIView alloc] initWithFrame:self.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.0;
    [self addSubview:_backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_backView addGestureRecognizer:tap];
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.appsView];
}

- (void)ssss {
    [self show];
    [TextConversionPictureService createTextSharePicture];
}

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 0.6;
        self.appsView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - ShareAppsViewHeight, self.frame.size.width, ShareAppsViewHeight);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 0;
        self.appsView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 44, self.frame.size.width, ShareAppsViewHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - 懒加载

- (AppsView *)appsView {
    if (!_appsView) {
        _appsView = [AppsView awakeWithNib];
        _appsView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 44, self.frame.size.width, ShareAppsViewHeight);
        
        WEAKSELF
        _appsView.ShareChannelButtonCompleteBlock = ^(NSInteger index) {
            if (weakSelf.ShareChannelButtonCompleteBlock) {
                weakSelf.ShareChannelButtonCompleteBlock(index);
            }
            [weakSelf hide];
        };
    }
    return _appsView;
}

@end
