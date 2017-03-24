//
//  IBView.m
//  JiaCheng
//
//  Created by 许坤志 on 16/7/12.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "IBView.h"

@implementation IBView

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.masksToBounds = YES;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

@end
