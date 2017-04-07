//
//  JCGuidePageView.m
//  JiaCheng
//
//  Created by 许坤志 on 16/7/2.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "JCGuidePageView.h"
#import "STPageControl.h"
#import "GravityView.h"

@interface JCGuidePageView()

@property (nonatomic, strong) UIButton *passButton;
@property (nonatomic, strong) UIButton *goAppbutton;
@property (nonatomic, weak, nullable)STPageControl *pageCustom;

@property (nonatomic, strong) UIImageView *guidePage1ImageView;
@property (nonatomic, strong) UIImageView *guidePage2ImageView;
@property (nonatomic, strong) UIImageView *guidePage3ImageView;

@property (nonatomic, strong) NSMutableArray *gravityViewArray;

@end

@implementation JCGuidePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _gravityViewArray = [NSMutableArray array];
        
        //设置引导视图的scrollview
        self.guidePageView = [[UIScrollView alloc] initWithFrame:frame];
        self.guidePageView.backgroundColor = [UIColor redColor];
        self.guidePageView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
        self.guidePageView.bounces = NO;
        self.guidePageView.pagingEnabled = YES;
        self.guidePageView.showsHorizontalScrollIndicator = NO;
        self.guidePageView.delegate = self;
        [self addSubview:_guidePageView];
        
        //添加在引导视图上的多张引导图片
        for (int i = 0; i < 3; i++) {
            
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            aView.backgroundColor = [UIColor blueColor];
            aView.clipsToBounds = YES;
            [self.guidePageView addSubview:aView];
            
            GravityView *gravityView = [[GravityView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            NSString *path;
            if (iPhone4_4s) {
                path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"iPhone4-%d", i + 1] ofType:@"png"];
            }
            else if (iPhone5_5s) {
                path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"iPhone5-%d", i + 1] ofType:@"png"];
            }
            else if (iPhone6_6s) {
                path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"iPhone6-%d", i + 1] ofType:@"png"];
            }
            else if (iPhone6_6sPlus) {
                path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"iPhone6plus-%d", i + 1] ofType:@"png"];
            }
            
            gravityView.gravityImage = [UIImage imageWithContentsOfFile:path];
            [aView addSubview:gravityView.gravityImageView];
            [_gravityViewArray addObject:gravityView];
            
            if (i == 0) {
                [gravityView startGravity];
            }
            
//            UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i + 24,
//                                                                                    SCREEN_HEIGHT - 73 - 57,
//                                                                                    SCREEN_WIDTH - 24,
//                                                                                    57)];
//            aImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"LogIn-guideText-%d", i + 1]];
//            aImageView.contentMode = UIViewContentModeLeft;
//            [self.guidePageView addSubview:aImageView];
            
            //设置在最后一张图片上显示进入体验按钮
            if (i == 2) {
                aView.userInteractionEnabled = YES;
                
//                _goAppbutton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 76, SCREEN_HEIGHT - 64, 76, 64)];
//                [_goAppbutton setImage:[UIImage imageNamed:@"LogIn-goApp"] forState:UIControlStateNormal];
//                [_goAppbutton addTarget:self action:@selector(btn_Click:) forControlEvents:UIControlEventTouchUpInside];
//                [aView addSubview:_goAppbutton];
                
                _goAppbutton = [UIButton buttonWithType:UIButtonTypeCustom];
                _goAppbutton.frame = self.bounds;
                [_goAppbutton addTarget:self action:@selector(btn_Click:) forControlEvents:UIControlEventTouchUpInside];
                [aView addSubview:_goAppbutton];
            }
            
        }
        
        UIView *guidePageView = [[UIView alloc] init];
        
        if (iPhone4_4s) {
            guidePageView.frame = CGRectMake((SCREEN_WIDTH - 41) / 2, SCREEN_HEIGHT - 19, 41, 3);
        }
        else if (iPhone5_5s) {
            guidePageView.frame = CGRectMake((SCREEN_WIDTH - 41) / 2, SCREEN_HEIGHT - 27, 41, 3);
        }
        else if (iPhone6_6s) {
            guidePageView.frame = CGRectMake((SCREEN_WIDTH - 41) / 2, SCREEN_HEIGHT - 30, 41, 3);
        }
        else if (iPhone6_6sPlus) {
            guidePageView.frame = CGRectMake((SCREEN_WIDTH - 41) / 2, SCREEN_HEIGHT - 50, 41, 3);
        }

        
        self.guidePage1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-guide-page-current"]];
        self.guidePage2ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-guide-page-normal"]];
        self.guidePage3ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-guide-page-normal"]];
        
        _guidePage1ImageView.frame = CGRectMake(0, 0, 11, 3);
        _guidePage2ImageView.frame = CGRectMake(15, 0, 11, 3);
        _guidePage3ImageView.frame = CGRectMake(30, 0, 11, 3);
        [guidePageView addSubview:_guidePage1ImageView];
        [guidePageView addSubview:_guidePage2ImageView];
        [guidePageView addSubview:_guidePage3ImageView];
        
        [self addSubview:guidePageView];
        
        // 设置图标
//        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 78, 124, 59)];
//        logoImageView.image = [UIImage imageNamed:@"LogIn-guideLogo"];
//        [self addSubview:logoImageView];
        
        // 设置引导页上的页面控制器
//        STPageControl *pageCustom = [STPageControl pageControlWithFrame:CGRectMake(0, SCREEN_HEIGHT - 35, 104, 10)
//                                                          numberOfPages:3
//                                                               gapWidth:18
//                                                               diameter:5
//                                                              lineWidth:0
//                                                        coreNormalColor:[UIColor colorWithWhite:1.0 alpha:0.3]
//                                                      coreSelectedColor:[UIColor redColor]
//                                                        lineNormalColor:[UIColor clearColor]
//                                                      lineSelectedColor:[UIColor clearColor]
//                                                        textNormalColor:[UIColor clearColor]
//                                                      textSelectedColor:[UIColor clearColor]
//                                                     hidesForSinglePage:YES
//                                                             ShowNumber:YES];
//        [self addSubview:pageCustom];
//        self.pageCustom = pageCustom;
    }
    return self;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    int page = scrollview.contentOffset.x / scrollview.frame.size.width;
    [self.imagePageControl setCurrentPage:page];
    self.pageCustom.currentPage = page;
    
    GravityView *gravityView = [_gravityViewArray objectAtIndex:page];
    [gravityView startGravity];
    
    switch (page) {
        case 1:
            _guidePage1ImageView.image = [UIImage imageNamed:@"login-guide-page-normal"];
            _guidePage2ImageView.image = [UIImage imageNamed:@"login-guide-page-current"];
            _guidePage3ImageView.image = [UIImage imageNamed:@"login-guide-page-normal"];
            break;
            
        case 2:
            _guidePage1ImageView.image = [UIImage imageNamed:@"login-guide-page-normal"];
            _guidePage2ImageView.image = [UIImage imageNamed:@"login-guide-page-normal"];
            _guidePage3ImageView.image = [UIImage imageNamed:@"login-guide-page-current"];
            break;
            
        default:
            _guidePage1ImageView.image = [UIImage imageNamed:@"login-guide-page-current"];
            _guidePage2ImageView.image = [UIImage imageNamed:@"login-guide-page-normal"];
            _guidePage3ImageView.image = [UIImage imageNamed:@"login-guide-page-normal"];
            break;
    }
    
    if (page == 2) {
        [UIView animateWithDuration:0.5 animations:^{
            _passButton.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            _passButton.alpha = 1.0;
        }];
    }
}

- (void)btn_Click:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    }];
    [self performSelector:@selector(removeGuidePage) withObject:nil afterDelay:1];
}

- (void)removeGuidePage {
    [self removeFromSuperview];
    
}

@end
