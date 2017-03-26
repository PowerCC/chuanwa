//
//  WaterView.m
//  gulucheng
//
//  Created by 许坤志 on 16/9/1.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "WaterView.h"

@implementation WaterView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // 半径
    CGFloat rabius = 6;
    
    // 开始角
    CGFloat startAngle = 0;
    
    // 中心点
    CGPoint point = CGPointMake(6, 6);  // 中心点我手动写的,你看看怎么弄合适 自己在搞一下
    
    NSLog(@"%f     %f", self.center.x, self.center.y);
    
    // 结束角
    CGFloat endAngle = 2*M_PI;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:rabius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    // 添加路径
    layer.path = path.CGPath;
    layer.fillColor = Them_orangeColor.CGColor;
    
    
    [self.layer addSublayer:layer];
}

@end
