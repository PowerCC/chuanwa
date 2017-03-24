//
//  IBNavigationBar.m
//  gulucheng
//
//  Created by 许坤志 on 16/7/22.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "IBNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation IBNavigationBar

static CGFloat kEndPoint = 1.5;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (self.color) {
        [self setNavigationBarWithColor:self.color];
    } else {
        [self setNavigationBarWithColor:kCOLOR(255, 255, 255, 1.0)];
    }
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(rect.size.width/2, 0);
    CGPoint endPoint = CGPointMake(rect.size.width/2, rect.size.height/kEndPoint);
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithGradients:(NSArray *)colours {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * beginColor = [colours objectAtIndex:0];
    UIColor * endColor = [colours objectAtIndex:1];
    drawLinearGradient(context, rect, beginColor.CGColor, endColor.CGColor);
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setNavigationBarWithColor:(UIColor *)color {
    UIImage *image = [self imageWithColor:color];
    
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self setBarStyle:UIBarStyleDefault];
    
    //[self setShadowImage:[UIImage new]];
    //[self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    //[self setTintColor:[UIColor whiteColor]];
    //[self setTranslucent:NO];
    
}

- (void)setNavigationBarWithColors:(NSArray *)colours {
    UIImage *image = [self imageWithGradients:colours];
    
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self setBarStyle:UIBarStyleDefault];
    
    //[self setShadowImage:[UIImage new]];
    //    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    //    [self setTintColor:[UIColor whiteColor]];
    //    [self setTranslucent:YES];
}

@end
