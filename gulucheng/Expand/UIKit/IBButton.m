//
//  IBButton.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/9.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "IBButton.h"

@implementation IBButton

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
