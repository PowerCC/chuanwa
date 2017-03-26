//
//  CWGuideView.m
//  gulucheng
//
//  Created by xukz on 2016/10/19.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CWGuideView.h"

@interface CWGuideView()

@property (nonatomic, strong) NSMutableArray *guideViewArray;

@end

@implementation CWGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchUpInside)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        _guideViewArray = [NSMutableArray array];
        
        //设置引导视图的scrollview
        self.guidePageView = [[UIScrollView alloc] initWithFrame:frame];
        self.guidePageView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
        self.guidePageView.bounces = NO;
        self.guidePageView.pagingEnabled = YES;
        self.guidePageView.showsHorizontalScrollIndicator = NO;
        self.guidePageView.delegate = self;
        [self addSubview:_guidePageView];
        
        //添加在引导视图上的多张引导图片
        for (int i = 0; i < 2; i++) {
            
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            aView.clipsToBounds = YES;
            aView.userInteractionEnabled = YES;
            [self.guidePageView addSubview:aView];
            
            UIImageView *guideView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            NSString *path;
            if (iPhone4_4s) {
                path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"iPhone4-0%d", i + 1] ofType:@"png"];
            }
            if (iPhone5_5s) {
                path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"iPhone5-0%d", i + 1] ofType:@"png"];
            }
            if (iPhone6_6s) {
                path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"iPhone6-0%d", i + 1] ofType:@"png"];
            }
            if (iPhone6_6sPlus) {
                path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"iPhone6plus-0%d", i + 1] ofType:@"png"];
            }
            
            guideView.image = [UIImage imageWithContentsOfFile:path];
            [aView addSubview:guideView];
            [_guideViewArray addObject:guideView];
            
            //设置在最后一张图片上显示进入体验按钮
            /*
            if (i == 2) {
                aView.userInteractionEnabled = YES;
                
                _goAppbutton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 76, SCREEN_HEIGHT - 64, 76, 64)];
                [_goAppbutton setImage:[UIImage imageNamed:@"LogIn-goApp"] forState:UIControlStateNormal];
                [_goAppbutton addTarget:self action:@selector(btn_Click:) forControlEvents:UIControlEventTouchUpInside];
                [aView addSubview:_goAppbutton];
            }
             */
        }
    }
    return self;
}

- (void)touchUpInside {
    if (self.guidePageView.contentOffset.x == SCREEN_WIDTH) {
        [self removeGuidePage];
    } else {
        [self.guidePageView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    }
}

//- (void)btn_Click:(UIButton *)sender {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.alpha = 0;
//    }];
//    [self performSelector:@selector(removeGuidePage) withObject:nil afterDelay:1];
//}

- (void)removeGuidePage {
    [self removeFromSuperview];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
