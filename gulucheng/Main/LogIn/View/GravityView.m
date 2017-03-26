//
//  GravityView.m
//  GuluCheng
//
//  Created by 许坤志 on 16/9/7.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "GravityView.h"
#import "ZXCoreMotion.h"

#define SPEED 5

@implementation GravityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self updateUI];
    }
    return self;
}

- (void)updateUI {
    
    _gravityImageView  = [[UIImageView alloc] init];
    [self addSubview:_gravityImageView];
}


- (void)setGravityImage:(UIImage *)gravityImage {
    
    _gravityImage = gravityImage;
    _gravityImageView.image = gravityImage;
    [_gravityImageView sizeToFit];
    
    _gravityImageView.frame = CGRectMake(0,
                                         0,
                                         gravityImage.size.width * (1.0 / (iPhone6_6sPlus ? 3 : 2)),
                                         gravityImage.size.height * (1.0 / (iPhone6_6sPlus ? 3 : 2)));
    
    _gravityImageView.center = CGPointMake(self.frame.size.width / 2,
                                           self.frame.size.height / 2);
}

- (void)startGravity {
    
    float scrollSpeedX = (_gravityImageView.frame.size.width - self.frame.size.width) / 2 / SPEED;
    float scrollSpeedY = (_gravityImageView.frame.size.height - self.frame.size.height) / 2 / SPEED;
    
    [ZXCoreMotion shareInstance].timeInterval = 0.01;
    [[ZXCoreMotion shareInstance]openDeviceMotion:^(float x, float y, float z) {
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeDiscrete animations:^{
            
            if ((_gravityImageView.frame.origin.x <= 0 && _gravityImageView.frame.origin.x >= self.frame.size.width - _gravityImageView.frame.size.width) ||
                (_gravityImageView.frame.origin.y <= 0 && _gravityImageView.frame.origin.y >= self.frame.size.height - _gravityImageView.frame.size.height)) {
                
                float invertedYRotationRate = y * 0.1;
                float interpretedXoffset = _gravityImageView.frame.origin.x + invertedYRotationRate *(_gravityImageView.frame.size.width/[UIScreen mainScreen].bounds.size.width) * scrollSpeedX + _gravityImageView.frame.size.width/2;
                
                float invertedXRotationRate = x * 0.1;
                float interpretedYoffset = _gravityImageView.frame.origin.y + invertedXRotationRate *(_gravityImageView.frame.size.height/[UIScreen mainScreen].bounds.size.height) * scrollSpeedY + _gravityImageView.frame.size.height/2;
                
                
                _gravityImageView.center = CGPointMake(interpretedXoffset,
                                                       interpretedYoffset);
            }
            if (_gravityImageView.frame.origin.x > 0) {
                
                _gravityImageView.frame = CGRectMake(0,
                                                     _gravityImageView.frame.origin.y,
                                                     _gravityImageView.frame.size.width,
                                                     _gravityImageView.frame.size.height);
            }
            
            if (_gravityImageView.frame.origin.x < self.frame.size.width - _gravityImageView.frame.size.width) {
                
                _gravityImageView.frame = CGRectMake(self.frame.size.width - _gravityImageView.frame.size.width,
                                                     _gravityImageView.frame.origin.y,
                                                     _gravityImageView.frame.size.width,
                                                     _gravityImageView.frame.size.height);
            }
            
            if (_gravityImageView.frame.origin.y > 0) {
                
                _gravityImageView.frame = CGRectMake(_gravityImageView.frame.origin.x,
                                                     0,
                                                     _gravityImageView.frame.size.width,
                                                     _gravityImageView.frame.size.height);
            }
            
            if (_gravityImageView.frame.origin.y < self.frame.size.height - _gravityImageView.frame.size.height) {
                
                _gravityImageView.frame = CGRectMake(_gravityImageView.frame.origin.x,
                                                     self.frame.size.height - _gravityImageView.frame.size.height,
                                                     _gravityImageView.frame.size.width,
                                                     _gravityImageView.frame.size.height);
            }
            
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)stopGravity {
    [[ZXCoreMotion shareInstance]stop];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
