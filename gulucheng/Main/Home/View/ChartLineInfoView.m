//
//  CommentTableViewCell.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "ChartLineInfoView.h"
#import "Masonry.h"


@interface ChartLineInfoView () {

    CGFloat Xmargin;//X轴方向的偏移
    CGFloat Ymargin;//Y轴方向的偏移
    CGPoint lastPoint;//最后一个坐标点
    UIButton *firstBtn;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *chartView;
@property (nonatomic, strong) UIView *chartBackgroundView;

@property (nonatomic, strong) NSMutableArray *pointArr;// 右边的数据源
@property (nonatomic, strong) NSMutableArray *labelArr;// 数字数据源
@property (nonatomic, strong) NSMutableArray *btnArr;// 左边按钮

@end

@implementation ChartLineInfoView

- (UIView *)chartBackgroundView {
    if (!_chartBackgroundView) {
        _chartBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.chartView.bounds.size.width - 5, self.chartView.bounds.size.height)];
        
    }
    return _chartBackgroundView;
}

- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(5,
                                                          0,
                                                          self.chartView.bounds.size.width - 20,
                                                          self.chartView.bounds.size.height - 60)];
    }
    
    return _bgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.pointArr = [NSMutableArray array];
        self.btnArr = [NSMutableArray array];
        self.labelArr = [NSMutableArray array];
    }
    
    return self;
}

// *******************数据源************************

- (void)setDataArray:(NSArray *)rightDataArr {
    
    // 添加表格左和下侧的内容
    [self addDetailViews];
    
    // 添加点
    [self addDataPointWith:self.bgView andArr:rightDataArr];
    
    // 添加连线
    [self addRightBezierPoint];
}

// *******************华丽的分割线************************

- (void)addDetailViews {

    self.chartView = [[UIScrollView alloc] initWithFrame:CGRectMake(20,
                                                                    0,
                                                                    self.bounds.size.width - 30,
                                                                    self.bounds.size.height)];
    
    // self.chartView.backgroundColor = [UIColor purpleColor];
    self.chartView.clipsToBounds = NO;
    [self addSubview:self.chartView];
    
    
    self.chartBackgroundView.clipsToBounds = NO;
    // self.chartBackgroundView.backgroundColor = [UIColor yellowColor];
    [self.chartView addSubview:self.chartBackgroundView];
    
    // self.bgView.backgroundColor = [UIColor whiteColor];
    [self.chartBackgroundView addSubview:self.bgView];
    
    // self.backgroundColor = [UIColor orangeColor];
    [self addLinesWith:self.bgView];
    
    // 添加左边数值
    [self addLeftViews];

    // 添加底部月份
    [self addBottomViewsWith:self.chartBackgroundView];
}


- (void)addDataPointWith:(UIView *)view andArr:(NSArray *)rightArr {
    CGFloat height = self.bgView.bounds.size.height;
    
    // 插入左边最后一个点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:rightArr];
    
    for (int i = 0; i < arr.count; i++) {
        
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(i == 0 ? 0 : Xmargin * i - 40/2,
                                                                        (1 - [arr[i] floatValue]) * height - 22,
                                                                        40,
                                                                        20)];
        numberLabel.textColor = kCOLOR(78, 158, 251, 1.0);
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.font = [UIFont systemFontOfSize:12];
        if (i == 0) {
            numberLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            numberLabel.textAlignment = NSTextAlignmentCenter;
        }
        
//        NSString *numberString = [NSString stringWithFormat:@"%.1f",round(([arr[i] floatValue] * _maxValue)*100)/100];
//        numberLabel.text = [NSString stringWithFormat:@"%td", numberString.integerValue];
        
        numberLabel.text = [NSString stringWithFormat:@"%td", (NSInteger)([arr[i] floatValue] * _maxValue + 0.10)];
        [_labelArr addObject:numberLabel];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(Xmargin * i - 5 / 2,
                                                                  (1 - [arr[i] floatValue]) * height - 2,
                                                                  5,
                                                                  5)];
        btn.backgroundColor = kCOLOR(78, 158, 251, 1.0);
        btn.layer.cornerRadius = 2.5;
        btn.layer.masksToBounds = YES;
        btn.tag = 100 + i;
        [self.btnArr addObject:btn];
        
        CGRect rect = CGRectMake((Xmargin) * i, (1 - [arr[i] floatValue]) * height, 5, 5);
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(rect.origin.x + 0.5, rect.origin.y)];
        
        [self.pointArr addObject:point];
    }
}

- (void)addRightBezierPoint {
    
    CGPoint point = [[self.pointArr objectAtIndex:0] CGPointValue];
    
    CGFloat lastY = point.y;
    
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:CGPointMake(0, lastY)];
    
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:CGPointMake(0, lastY)];
    
    CGFloat bgViewHeight = self.bgView.bounds.size.height;
    
    for (int i = 0; i < self.pointArr.count; i++ ) {
        if (i != 0) {
            
            CGPoint point = [[self.pointArr objectAtIndex:i] CGPointValue];
            [beizer addLineToPoint:point];
            [bezier1 addLineToPoint:point];
            
            if (i == self.pointArr.count - 1) {
                [beizer moveToPoint:point];//添加连线
                lastPoint = point;
            }
        }
    }
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    
    //最后一个点对应的X轴的值
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(0, bgViewHeight)];
    [bezier1 addLineToPoint:CGPointMake(0, lastY)];
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0, self.chartBackgroundView.bounds.size.height - 60);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:166/255.0 green:206/255.0 blue:247/255.0 alpha:0.7].CGColor,
                             (__bridge id)[UIColor colorWithRed:237/255.0 green:246/255.0 blue:253/255.0 alpha:0.5].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    
    [self.bgView.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 1.2f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2 * lastPoint.x, self.chartBackgroundView.bounds.size.height - 60)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = kCOLOR(78, 158, 251, 1.0).CGColor;
    shapeLayer.lineWidth = 1.5;
    [self.bgView.layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration = 1.2f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke"];

    for (UIButton *btn in self.btnArr) {
        [self.bgView addSubview:btn];
    }
    for (UILabel *numberLabel in _labelArr) {
        [self.bgView addSubview:numberLabel];
    }
}

- (void)addLeftViews {
    
    for (int i = 0; i < 5; i++ ) {

        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, i * Ymargin - 10, 20, 20)];
        leftLabel.textColor = [UIColor grayColor];
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.font = [UIFont systemFontOfSize:12];
        leftLabel.text = _leftArray[i];
        [self addSubview:leftLabel];
    }
}

- (void)addLinesWith:(UIView *)view {
    
    CGFloat magrginHeight = view.bounds.size.height / 4;
    CGFloat labelWith = view.bounds.size.width;
    Ymargin = magrginHeight;
    
    for (int i = 0; i < 4 ; i++ ) {
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                   magrginHeight * i,
                                                                                   labelWith,
                                                                                   1)];
        lineImageView.image = [UIImage imageNamed:@"myCenter-dataLine"];
        lineImageView.contentMode = UIViewContentModeScaleAspectFill;
        lineImageView.clipsToBounds = YES;
        [view addSubview:lineImageView];
        
        UIView *partView = [[UIView alloc] initWithFrame:CGRectMake(-5/2, magrginHeight * i, 5, 0.5)];
        partView.backgroundColor = kCOLOR(68, 68, 68, 1.0);
        [view addSubview:partView];
    }
    
    CGFloat marginWidth = view.bounds.size.width / 6;
    Xmargin = marginWidth;
    CGFloat labelHeight = view.bounds.size.height;
    
    UIView *verticalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, labelHeight + 2.5)];
    verticalView.backgroundColor = kCOLOR(68, 68, 68, 1.0);
    [view addSubview:verticalView];
    
    UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectMake(- 2.5, labelHeight - 0.5, labelWith + 2.5, 0.5)];
    horizontalView.backgroundColor = kCOLOR(68, 68, 68, 1.0);
    [view addSubview:horizontalView];
    
    for (int i = 0; i < 7; i++ ) {
        
        UIView *partView = [[UIView alloc] initWithFrame:CGRectMake(marginWidth * i, labelHeight - 5/2, 0.5, 5)];
        partView.backgroundColor = kCOLOR(68, 68, 68, 1.0);
        if (i != 0) {
            [view addSubview:partView];
        }
    }
}

- (void)addBottomViewsWith:(UIView *)view {
    
    for (int i = 0;i < 7 ;i++ ) {
        
        UILabel *buttomLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * Xmargin - 18,
                                                                        4 * Ymargin,
                                                                        50,
                                                                        30)];
        buttomLabel.textColor = kCOLOR(68, 68, 68, 1.0);
        buttomLabel.font = [UIFont systemFontOfSize:12];
        buttomLabel.text = _bottomArray[i];
        buttomLabel.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:buttomLabel];
    }
}

@end
