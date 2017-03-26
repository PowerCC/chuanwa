//
//  UIView+Tools.m
//  gulucheng
//
//  Created by PWC on 2017/2/7.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "UIView+Tools.h"

@implementation UIView (Tools)

- (void)circular {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.bounds.size];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    // 设置大小
    maskLayer.frame = self.bounds;
    
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)circularWithSize:(CGSize)size {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    // 设置大小
    maskLayer.frame = self.bounds;
    
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
