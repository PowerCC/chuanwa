//
//  UIButton+Able.m
//  gulucheng
//
//  Created by 许坤志 on 16/7/23.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "UIButton+Able.h"

@implementation UIButton (Able)

- (void)textNormalWithColor:(UIColor *)color {
    self.enabled = YES;
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)textDisableWithColor:(UIColor *)color {
    self.enabled = NO;
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)normalWithColor:(UIColor *)color {
    self.enabled = YES;
    self.backgroundColor = color;
}

- (void)disableWithColor:(UIColor *)color {
    self.enabled = NO;
    self.backgroundColor = color;
}

@end
