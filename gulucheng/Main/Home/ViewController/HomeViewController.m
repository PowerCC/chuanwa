//
//  HomeViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/31.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "HomeViewController.h"
#import "NotificationViewController.h"
#import "MyCenterViewController.h"
#import "OtherCenterViewController.h"
#import "CardDetailViewController.h"
#import "ChatViewController.h"
#import "EaseUI.h"
#import "CWGuideView.h"
#import "NoDataView.h"

#import "CheckNewNoticeApi.h"

#import "EventApi.h"
#import "RecommendApi.h"
#import "RecommendOperateApi.h"
#import "ListByImNamesApi.h"

#import "MagicMoveTransition.h"
#import "VBFPopFlatButton.h"

#import "GroupLoadingView.h"
#import "SingleLoadingView.h"


@interface HomeViewController () <UINavigationControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *firstScrollView;
@property (strong, nonatomic) UIScrollView *secondScrollView;

@property (strong, nonatomic) UILabel *actionLabel;
@property (strong, nonatomic) UILabel *actionRoundLabel;

@property (strong, nonatomic) UIImageView *actionImageView;

@property (strong, nonatomic) GroupLoadingView *groupLoadingView;
@property (strong, nonatomic) SingleLoadingView *singleLoadingView;

@property (strong, nonatomic) VBFPopFlatButton *flatRoundedButton;

@property (strong, nonatomic) NSArray *commendArray;

@property (strong, nonatomic) RecommendModel *tempRecommendModel;

@property (copy, nonatomic) NSString *tempID;
@property (copy, nonatomic) NSString *userID;

@property (assign, nonatomic) BOOL isViewUnLoad;
@property (assign, nonatomic) BOOL isRequestData;
@property (assign, nonatomic) BOOL isEndDraging;
@property (assign, nonatomic) BOOL isNext;

@property (assign, nonatomic) NSInteger page;

@property (assign, nonatomic) CGFloat beginOffset;
@property (assign, nonatomic) CGFloat endOffset;

@end

@implementation HomeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 去掉导航分割线
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navView.alpha = 0.0;
    
    if (_eventId == nil || _eventId.length == 0) {
        [self checkNewNotice];
        [self checkUnreadMessages];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkLocation];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    self.navView.alpha = 1.0;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveNotifications:) name:N_HOME_HAVE_NOTIFICATIONS object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNotifications:) name:N_HOME_NO_NOTIFICATIONS object:nil];
    
    if (_eventId && _eventId.length > 0) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:N_DID_BECOME_ACTIVE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:N_DID_RECEIVE_NOTIFICATION object:nil];
    
    
    NSString *imUname = GlobalData.userModel.imUname;
    NSString *imUpwd = GlobalData.userModel.imUpwd;
    // 登录环信
    EMError *error = [[EMClient sharedClient] loginWithUsername:imUname password:imUpwd];
    if (!error) {
        [[EMClient sharedClient].options setIsAutoLogin:YES];
    }
    
    _page = 0;
    _isViewUnLoad = YES;
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    _actionLabel = [[UILabel alloc] init];
//    _actionLabel.font = [UIFont systemFontOfSize:14];
    _actionLabel.font = [UIFont systemFontOfSize:17];
    _actionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_actionLabel];
    
//    _actionRoundLabel = [[UILabel alloc] init];
//    _actionRoundLabel.font = [UIFont systemFontOfSize:12];
//    _actionRoundLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:_actionRoundLabel];
    
    _actionImageView = [[UIImageView alloc] init];
    [self.view addSubview:_actionImageView];
    
    _flatRoundedButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(21, 19, 20, 20)
                                                         buttonType:buttonAddType
                                                        buttonStyle:buttonPlainStyle
                                              animateToInitialState:NO];
    _flatRoundedButton.lineThickness = 2.5;
    _flatRoundedButton.tintColor = [UIColor whiteColor];

    [_publishImageContentView insertSubview:_flatRoundedButton atIndex:1];
    
    
    self.groupLoadingView = [[GroupLoadingView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 375) / 2, (SCREEN_HEIGHT - 360) / 2, 375, 360) superView:self.view];
    _groupLoadingView.alpha = 0.0;
    
    self.singleLoadingView = [[SingleLoadingView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20) / 2, (SCREEN_HEIGHT - 20) / 2, 20, 20) superView:self.view];
    _singleLoadingView.alpha = 0.0;
    
    [self recommendDataSourceRequest];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    if (AppDelegateInstance.launchOptionsDic) {
        [self didReceiveNotification:[NSNotification notificationWithName:N_DID_RECEIVE_NOTIFICATION object:AppDelegateInstance.launchOptionsDic]];
        AppDelegateInstance.launchOptionsDic = nil;
    }
}

- (void)showGuideView {
    // 创建引导页视图
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstBeenShow"]) {
        // 首次使用app进入教程
        CWGuideView *pageView = [[CWGuideView alloc] initWithFrame:self.view.frame];
        [self.navigationController.view addSubview:pageView];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstBeenShow"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)addFirstScrollView {
    _firstScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _firstScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 3);
    _firstScrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
    _firstScrollView.backgroundColor = kCOLOR(242, 244, 247, 1);
    _firstScrollView.showsVerticalScrollIndicator = NO;
    _firstScrollView.pagingEnabled = YES;
    _firstScrollView.scrollsToTop = NO;
    _firstScrollView.delegate = self;
    
    [self.view addSubview:_firstScrollView];
    [self.view bringSubviewToFront:_actionLabel];
    [self.view bringSubviewToFront:_actionImageView];
    [self.view bringSubviewToFront:_publishImageContentView];
    
    [self showGuideView];
}

- (void)addSecondScrollView {
    _secondScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _secondScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 3);
    _secondScrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
    _secondScrollView.backgroundColor = kCOLOR(242, 244, 247, 1);
    _secondScrollView.showsVerticalScrollIndicator = NO;
    _secondScrollView.pagingEnabled = YES;
    _secondScrollView.scrollsToTop = NO;
    _secondScrollView.delegate = self;
    [self.view addSubview:_secondScrollView];
    
    [self.view sendSubviewToBack:_secondScrollView];
    [self.view bringSubviewToFront:_actionLabel];
    [self.view bringSubviewToFront:_actionImageView];
    [self.view bringSubviewToFront:_publishImageContentView];
}

- (void)addPublishViewWithContentView:(UIView *)publishView recommendModel:(RecommendModel *)recommendModel {
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  SCREEN_HEIGHT,
                                                                  SCREEN_WIDTH,
                                                                  SCREEN_HEIGHT)];
    shadowView.userInteractionEnabled = YES;
    shadowView.backgroundColor = [UIColor whiteColor];
    [publishView addSubview:shadowView];
    
    //加上这句可以解决卡顿问题
    CALayer *layer = [shadowView layer];
    layer.shadowPath =[UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
    
    layer.masksToBounds = NO;
    [layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [layer setShadowRadius:3.0];
    [layer setShadowOpacity:0.4];
    [layer setShadowColor:[UIColor blackColor].CGColor];
    
    CGRect publishViewFrame = CGRectMake(0,
                                         SCREEN_HEIGHT + 64,
                                         SCREEN_WIDTH,
                                         SCREEN_HEIGHT - 64);
    
    if ([recommendModel.eventType isEqualToString:TextEvent]) {
        self.textCommendView = [[TextCommendView alloc] initWithFrame:publishViewFrame];
        
        if (iPhone4_4s) {
            if (recommendModel.textModel.content.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
                self.textCommendView.textLabel.numberOfLines = 9;
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
                self.textCommendView.textLabel.numberOfLines = 8;
            }
        }
        else if (iPhone5_5s) {
            if (recommendModel.textModel.content.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
                self.textCommendView.textLabel.numberOfLines = 13;
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
                self.textCommendView.textLabel.numberOfLines = 10;
            }
        }
        else if (iPhone6_6s) {
            if (recommendModel.textModel.content.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
                self.textCommendView.textLabel.numberOfLines = 13;
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
                self.textCommendView.textLabel.numberOfLines = 11;
            }
        }
        else if (iPhone6_6sPlus) {
            if (recommendModel.textModel.content.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
                self.textCommendView.textLabel.numberOfLines = 13;
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
                self.textCommendView.textLabel.numberOfLines = 11;
            }
        }
        
        WEAKSELF
        self.textCommendView.textLabelHeightBlock = ^(float height) {
//            weakSelf.textCommendView.textTopConstraint.constant = (SCREEN_HEIGHT - 64 - 59 - height)/2;
            
            CGRect rect = weakSelf.textCommendView.frame;
            rect.origin.y = (SCREEN_HEIGHT - rect.size.height) / 2;
            rect.size.width = SCREEN_WIDTH;
            weakSelf.textCommendView.frame = rect;
        };
        
        [self.textCommendView loadTextCommendModel:recommendModel];
        [shadowView addSubview:self.textCommendView];
        
        self.textCommendView.textViewTapBlock = ^{
            [weakSelf performSegueWithIdentifier:@"cardDetailSegue" sender:nil];
        };
        self.textCommendView.showCenterBlock = ^{
            [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
        };
    }
    
    if ([recommendModel.eventType isEqualToString:VoteEvent]) {
        _voteCommendView = [[VoteCommendView alloc] initWithFrame:publishViewFrame];
        [_voteCommendView loadVoteCommendModel:recommendModel isHomeIn:YES];
        [publishView addSubview:_voteCommendView];
        
        WEAKSELF
        _voteCommendView.recommendModelResultBlock = ^(RecommendModel *recommendModel) {
            weakSelf.currentRecommendModel = recommendModel;
        };
        
        _voteCommendView.voteViewTapBlock = ^{
            [weakSelf performSegueWithIdentifier:@"cardDetailSegue" sender:nil];
        };
        
        _voteCommendView.showCenterBlock = ^{
            [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
        };
    }
    
    if ([recommendModel.eventType isEqualToString:PictureEvent]) {
        _photoCommendView = [[PhotoCommendView alloc] initWithFrame:publishViewFrame];
        [_photoCommendView reloadCollectionViewWithPhotoCommendModel:recommendModel];
        [publishView addSubview:_photoCommendView];
        
        WEAKSELF
        _photoCommendView.showCenterBlock = ^{
            [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
        };
        _photoCommendView.selectedIndexPathBlock = ^(NSIndexPath *indexPath) {
            weakSelf.indexPath = indexPath;
            [weakSelf performSegueWithIdentifier:@"cardDetailSegue" sender:nil];
        };
        _photoCommendView.currentPageBlock = ^(NSInteger currentPage) {
            weakSelf.commendButtomView.pageControl.currentPage = currentPage;
        };
    }
    
    // 最底部内容
    _commendButtomView = [CommendButtomView awakeWithNib];
    [_commendButtomView setFrame:CGRectMake(0,
                                           SCREEN_HEIGHT * 2 - (recommendModel.eventPicVos.count > 1 ? commendButtomViewPageHeight : commendButtomViewHeight),
                                           SCREEN_WIDTH,
                                           recommendModel.eventPicVos.count > 1 ? commendButtomViewPageHeight : commendButtomViewHeight)
                   commendModel:recommendModel];
    _commendButtomView.talkCountLabel.text = recommendModel.commentTimes;
    _commendButtomView.peopleCountLabel.text = recommendModel.spreadTimes;
    [publishView addSubview:_commendButtomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewUnloadFunc {
    if (_isViewUnLoad) {
        
        NSLog(@"\n scrollViewWillBeginDragging \n");
        
        if ((_page + 1) < _commendArray.count) {
            [self addSecondScrollView];
            
            RecommendModel *recommendModel = [_commendArray objectAtIndex:(_page + 1)];
            [self addPublishViewWithContentView:_secondScrollView recommendModel:recommendModel];
            
            _tempRecommendModel = recommendModel;
        } else {
            _isRequestData = YES;
        }
        
        _isViewUnLoad = NO;
    }
    
    _isEndDraging = NO;
}

- (void)ccc:(UIScrollView *)scrollView {
    if (_page < _commendArray.count) {
        RecommendModel *recommendModel = [_commendArray objectAtIndex:_page];
        [self recommendOperateRequestWithCommendModel:recommendModel
                                               isSkip:scrollView.contentOffset.y == 0];
        
        [scrollView removeFromSuperview];
        scrollView = nil;
        
        _page++;
        _isViewUnLoad = YES;
        
        _singleLoadingView.alpha = 0.0;
        [_singleLoadingView stopAnimating];
        
        _actionLabel.alpha = 0.0;
        _actionLabel.font = [UIFont systemFontOfSize:17];
        _actionImageView.alpha = 0.0;
        
        self.navigationController.navigationBar.alpha = 1.0;
        [_flatRoundedButton animateToType:buttonAddType];
        
        NSLog(@"------\n--------%f    %@", scrollView.contentOffset.y, recommendModel.eid);
    }

}

- (void)setContentOffset:(UIScrollView *)scrollView {
    CGFloat value = SCREEN_HEIGHT * 0.2;
    if (_endOffset - _beginOffset > value) {
        NSLog(@"\n scrollViewDidEndDragging _isViewUnLoad = YES \n");
        [scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT * 2) animated:YES];
        
        _isViewUnLoad = YES;
        
        _actionImageView.alpha = 0.0;
        _actionLabel.alpha = 0.0;
        
        [UIView animateWithDuration:0.30
                         animations:^{
                             scrollView.alpha = 0.0;
                         }];
        
        self.currentRecommendModel = _tempRecommendModel;
        _isNext = YES;
    }
    else if (_endOffset - _beginOffset < -value) {
        _isViewUnLoad = YES;
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.currentRecommendModel = _tempRecommendModel;
        _isNext = YES;
    }
    
    _isEndDraging = YES;
    
    [UIView animateWithDuration:0.15
                     animations:^{
                         _singleLoadingView.alpha = 0.0;
                     }];
    [_singleLoadingView stopAnimating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self viewUnloadFunc];
    
    _beginOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isNext = NO;
    
    CGFloat value = SCREEN_HEIGHT * 0.3;
    if (scrollView.contentOffset.y - SCREEN_HEIGHT > value) {
        NSLog(@"\n scrollViewDidEndDragging _isViewUnLoad = YES \n");
        [scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT * 2) animated:YES];
        
        _isViewUnLoad = YES;
        
        _actionImageView.alpha = 0.0;
        _actionLabel.alpha = 0.0;
        
        [UIView animateWithDuration:0.30
                         animations:^{
                             scrollView.alpha = 0.0;
                         }];
        
        self.currentRecommendModel = _tempRecommendModel;
        _isNext = YES;
    }
    else if (scrollView.contentOffset.y - SCREEN_HEIGHT < -value) {
        _isViewUnLoad = YES;
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.currentRecommendModel = _tempRecommendModel;
        _isNext = YES;
    }
    
    _isEndDraging = YES;
    
    [UIView animateWithDuration:0.15
                     animations:^{
                         _singleLoadingView.alpha = 0.0;
                     }];
    [_singleLoadingView stopAnimating];
}

/**
 *  滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    _endOffset = scrollView.contentOffset.y;
    
    if (!_isNext) {
        [self setContentOffset:scrollView];
    }
    
    if (scrollView.contentOffset.y == 0 || scrollView.contentOffset.y >= SCREEN_HEIGHT * 2) {
        
        if (_isNext) {
            [self ccc:scrollView];
        }
    }
}

/**
 *  滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _endOffset = scrollView.contentOffset.y;
    
    if (!_isNext) {
        [self setContentOffset:scrollView];
    }
    
    if (scrollView.contentOffset.y == 0 || scrollView.contentOffset.y >= SCREEN_HEIGHT * 2) {
        
        if (_isNext) {
            [self ccc:scrollView];
        }
    }
    else {
        [UIView animateWithDuration:0.15
                         animations:^{
                             _singleLoadingView.alpha = 0.0;
                         }];
        [_singleLoadingView stopAnimating];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 显示放弃还是传播操作
//    [self.view bringSubviewToFront:_actionImageView];
//    [self.view bringSubviewToFront:_actionLabel];
    
//    [self.view bringSubviewToFront:_actionRoundLabel];
    // 显示传播操作
    if (scrollView.contentOffset.y > SCREEN_HEIGHT) {
        
        _actionImageView.image = [UIImage imageNamed:@"home-spread"];
        _actionImageView.frame = CGRectMake((SCREEN_WIDTH - 30) / 2,
                                            SCREEN_HEIGHT - ((scrollView.contentOffset.y - SCREEN_HEIGHT) / 2 + 25),
                                            30,
                                            30);
        
        _actionLabel.frame = CGRectMake((SCREEN_WIDTH - 150) / 2,
                                        SCREEN_HEIGHT - ((scrollView.contentOffset.y - SCREEN_HEIGHT) / 2 - 15),
                                        150,
                                        20);
        _actionLabel.text = @"传 递 给 周 围 的 人";
        _actionLabel.textColor = kCOLOR(255, 129, 105, 1.0);
        
        if (scrollView.contentOffset.y - SCREEN_HEIGHT <= 50) {
            [UIView animateWithDuration:0.15
                             animations:^{
                                 _actionLabel.alpha = 0.0;
                                 _actionImageView.alpha = 0.0;
                                 _singleLoadingView.alpha = 0.0;
                             } completion:^(BOOL finished) {
                                 [_singleLoadingView stopAnimating];
                             }];

            [_flatRoundedButton animateToType:buttonAddType];
        } else if (scrollView.contentOffset.y - SCREEN_HEIGHT <= 170) {
            if (!_isEndDraging) {
                _actionLabel.alpha = (scrollView.contentOffset.y - SCREEN_HEIGHT - 30) / (170 - 30);
                _actionImageView.alpha = (scrollView.contentOffset.y - SCREEN_HEIGHT - 30) / (170 - 30);
                
                [_flatRoundedButton animateToType:buttonUpBasicType];
            }
        } else if (!_isEndDraging && scrollView.contentOffset.y - SCREEN_HEIGHT > SCREEN_HEIGHT * 0.5) {
            [UIView animateWithDuration:0.15
                             animations:^{
                                 _actionLabel.alpha = 0.0;
                                 _actionImageView.alpha = 0.0;
                             }];
            
            [self.view bringSubviewToFront:_singleLoadingView];
            
            [UIView animateWithDuration:0.15
                             animations:^{
                                 _singleLoadingView.alpha = 1.0;
                             }];
            [_singleLoadingView startAnimating];
        }
    }
    // 显示放弃操作
    if (scrollView.contentOffset.y < SCREEN_HEIGHT) {
        _actionImageView.image = [UIImage imageNamed:@"home-skip"];
        _actionImageView.frame = CGRectMake((SCREEN_WIDTH - 30) / 2,
                                            (SCREEN_HEIGHT - scrollView.contentOffset.y) / 2 - 15,
                                            30,
                                            30);
        
        _actionLabel.frame = CGRectMake((SCREEN_WIDTH - 150) / 2,
                                        (SCREEN_HEIGHT - scrollView.contentOffset.y) / 2 + 25,
                                        150,
                                        25);
        _actionLabel.text = @"拒 绝 传 递";
        _actionLabel.textColor = kCOLOR(136, 136, 136, 1.0);
        
        if (SCREEN_HEIGHT - scrollView.contentOffset.y <= 50) {
            [UIView animateWithDuration:0.15
                             animations:^{
                                 _actionLabel.alpha = 0.0;
                                 _actionImageView.alpha = 0.0;
                                 _singleLoadingView.alpha = 0.0;
                                 self.navigationController.navigationBar.alpha = 1.0;
                             } completion:^(BOOL finished) {
                                 [_singleLoadingView stopAnimating];
                             }];

            [_flatRoundedButton animateToType:buttonAddType];
        } else if (SCREEN_HEIGHT - scrollView.contentOffset.y <= 170) {
            if (!_isEndDraging) {
                _actionLabel.alpha = (SCREEN_HEIGHT - scrollView.contentOffset.y - 30) / (170 - 30);
                _actionImageView.alpha = (SCREEN_HEIGHT - scrollView.contentOffset.y - 30) / (170 - 30);
                [_flatRoundedButton animateToType:buttonCloseType];
            }
        } else if (!_isEndDraging && scrollView.contentOffset.y - SCREEN_HEIGHT < -SCREEN_HEIGHT * 0.5) {
            
            [UIView animateWithDuration:0.15
                             animations:^{
                                 _actionLabel.alpha = 0.0;
                                 _actionImageView.alpha = 0.0;
                             }];
            
            [self.view bringSubviewToFront:_singleLoadingView];
            
            [UIView animateWithDuration:0.15
                             animations:^{
                                 _singleLoadingView.alpha = 1.0;
                             }];
            [_singleLoadingView startAnimating];
            
            [UIView animateWithDuration:0.15
                             animations:^{
                                 self.navigationController.navigationBar.alpha = 0.0;
                             }];
        }
    }
    
//    if (abs(scrollView.contentOffset.y > SCREEN_HEIGHT * 0.45)) {
//        [UIView animateWithDuration:0.15
//                         animations:^{
//                             _actionLabel.alpha = 0.0;
//                             _actionImageView.alpha = 0.0;
////                             _singleLoadingView.alpha = 1.0;
//                         }];
////        [_singleLoadingView startAnimating];
//    }
}

- (void)popMenuView:(HyPopMenuView *)popMenuView didSelectItemAtIndex:(NSUInteger)index {
    
    self.menu.topView.hidden = YES;
    
    if (index == 0) {
        [self takePhotoAction];
    }
    
    if (index == 1) {
        [self photoPublishAction];
    }
    
    if (index == 2) {
        [self textPublishAction];
    }
    
    if (index == 3) {
        [self votePublishAction];
    }
}

#pragma mark - checkLocation 检查本地是否存储了位置信息
- (void)checkLocation {
    double tempLatitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"latitude"];
    double tempLongitude =  [[NSUserDefaults standardUserDefaults] doubleForKey:@"longitude"];
    
    if (tempLatitude > 0 && tempLongitude > 0) {
        self.latitude = tempLatitude;
        self.longitude = tempLongitude;
    }
}

#pragma mark - checkNewNotice 检查是否有新的通知
- (void)checkNewNotice {
    CheckNewNoticeApi *checkNewNoticeApi = [[CheckNewNoticeApi alloc] init];
    
    WEAKSELF
    [checkNewNoticeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            NSString *newAll = request.responseJSONObject[@"data"][@"newAll"];
            if (newAll.integerValue > 0) {
                [weakSelf haveNotifications:nil];
            }
            else {
                [weakSelf noNotifications:nil];
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - checkUnreadMessages 检查是否有未读IM
- (void)checkUnreadMessages {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    if (conversations && conversations.count > 0) {
        for (EMConversation *c in conversations) {
            if (c.unreadMessagesCount > 0) {
                [_messageButton setImage:[UIImage imageNamed:@"home-haveMessage"] forState:UIControlStateNormal];
                break;
            }
        }
    }
}

#pragma mark - eventRequest 单个事件详情请求
- (void)eventRequest:(NSString *)eid
             success:(void(^)())success
             failure:(void(^)())failure {
    WEAKSELF
    
    EventApi *eventApi = [[EventApi alloc] initWithEid:eid];
    [eventApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            RecommendModel *recommendModel = [RecommendModel JCParse:request.responseJSONObject[@"data"]];
            weakSelf.currentRecommendModel = recommendModel;
            [weakSelf addFirstScrollView];
            [weakSelf addPublishViewWithContentView:weakSelf.firstScrollView recommendModel:recommendModel];
            weakSelf.publishImageContentView.hidden = YES;
            NSLog(@"%@", recommendModel);
            
            if (success) {
                success();
            }
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (failure) {
            failure();
        }
    }];
}


// 重新请求下一波数据
- (void)recommendDataSourceRequest {
    
    _page = 0;
    RecommendApi *recommentApi = [[RecommendApi alloc] initWithLatitude:self.latitude
                                                              longitude:self.longitude];
    
//    [MBProgressHUD showMessage:Loading toView:self.view];
    _groupLoadingView.alpha = 1.0;
    [_groupLoadingView startAnimating];
    WEAKSELF
    [recommentApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            weakSelf.commendArray = [RecommendModel JCParse:request.responseJSONObject[@"data"]];
            
            if (weakSelf.commendArray.count) {
                
                [weakSelf addFirstScrollView];
                
                RecommendModel *recommendModel = weakSelf.commendArray.firstObject;
                weakSelf.currentRecommendModel = recommendModel;
                
                [weakSelf addPublishViewWithContentView:weakSelf.firstScrollView recommendModel:recommendModel];
            } else {
                GCD_AFTER(0.2, ^{
                    
                    [weakSelf loadNoDataViewWithNoWifi:NO];
                });
            }
        }
        
//        [MBProgressHUD hideHUDForView:weakSelf.view];
        _groupLoadingView.alpha = 0.0;
        [_groupLoadingView stopAnimating];
    } failure:^(YTKBaseRequest *request) {
//        [MBProgressHUD hideHUDForView:weakSelf.view];
        weakSelf.groupLoadingView.alpha = 0.0;
        [weakSelf.groupLoadingView stopAnimating];
        GCD_AFTER(0.2, ^{
            [weakSelf loadNoDataViewWithNoWifi:YES];
        });
    }];
}

// 传播 或者 忽略 请求操作
- (void)recommendOperateRequestWithCommendModel:(RecommendModel *)commendModel isSkip:(BOOL)isSkip {
    
    RecommendOperateApi *recommendSkipApi = [[RecommendOperateApi alloc] initWithFromEid:commendModel.eventId
                                                                                     eid:commendModel.eid
                                                                             operateType:isSkip ? skipEvent : spreadEvent
                                                                                latitude:self.latitude
                                                                               longitude:self.longitude];
    WEAKSELF
    [recommendSkipApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {}
        if (weakSelf.isRequestData) {
            [weakSelf recommendDataSourceRequest];
            weakSelf.isRequestData = NO;
        } else {
            
        }
        
    } failure:^(YTKBaseRequest *request) {
        if (weakSelf.isRequestData) {
            [weakSelf recommendDataSourceRequest];
            weakSelf.isRequestData = NO;
        }
    }];
}

- (void)loadNoDataViewWithNoWifi:(BOOL)isNoWifi {
    NoDataView *noDataView = [NoDataView awakeWithNib];
    noDataView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 50);
    noDataView.imageView.image = [UIImage imageNamed:(isNoWifi ? @"public-noWifi" : @"public-logo")];
    noDataView.firstLabel.text = isNoWifi ? @"网络不给力，点击屏幕重试~" : @"周围已经被你刷的山穷水尽了~";
    noDataView.secondLabel.text = isNoWifi ? @"" : @"这是你发内容的大好时机！";
    [self.view addSubview:noDataView];
    
    WEAKSELF
    noDataView.ReloadBlock = ^{
        [weakSelf recommendDataSourceRequest];
    };
}

#pragma mark - showPublishHintView 显示发布成功奖励提示
- (void)showPublishHintView:(NSString *)value {
    
    UIColor *moneyColor = kCOLOR(255, 97, 97, 1.0);
    NSMutableAttributedString *tempAttStr = [[NSMutableAttributedString alloc] initWithString:value];
    [tempAttStr addAttribute:NSForegroundColorAttributeName value:moneyColor range:NSMakeRange(0, tempAttStr.length)];
    
    UIColor *color = kCOLOR(34, 34, 34, 1.0);
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"恭喜您获得"];
    [attStr1 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attStr1.length)];
    
    NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:@"元现金奖励"];
    [attStr2 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attStr2.length)];
    
    NSMutableAttributedString *contentAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attStr1];
    [contentAttStr appendAttributedString:tempAttStr];
    [contentAttStr appendAttributedString:attStr2];
    [contentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, contentAttStr.length)];
    _publishHintLabel.attributedText = contentAttStr;
    
    [self.view bringSubviewToFront:_publishHintView];
    _publishHintView.hidden = NO;
    
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        _publishHintView.alpha = 1.0;
    } completion:^(BOOL finished) {
        GCD_AFTER(5.0, ^{
            [weakSelf hideHintView:nil];
        });
    }];
}

#pragma mark - showOtherHintView 显示发布其他提示
- (void)showOtherHintView:(NSString *)value {
    
    UIColor *moneyColor = kCOLOR(255, 97, 97, 1.0);
    NSMutableAttributedString *tempAttStr = [[NSMutableAttributedString alloc] initWithString:value];
    [tempAttStr addAttribute:NSForegroundColorAttributeName value:moneyColor range:NSMakeRange(0, tempAttStr.length)];
    
    UIColor *color = kCOLOR(34, 34, 34, 1.0);
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"每日前"];
    [attStr1 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attStr1.length)];
    
    NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:@"张卡片可获得返现"];
    [attStr2 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attStr2.length)];
    
    NSMutableAttributedString *contentAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attStr1];
    [contentAttStr appendAttributedString:tempAttStr];
    [contentAttStr appendAttributedString:attStr2];
    [contentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, contentAttStr.length)];
    _otherHintLabel.attributedText = contentAttStr;
    
    [self.view bringSubviewToFront:_otherHintView];
    _otherHintView.hidden = NO;
    
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        _otherHintView.alpha = 1.0;
    } completion:^(BOOL finished) {
        GCD_AFTER(5.0, ^{
            [weakSelf hideHintView:nil];
        });
    }];
}

#pragma mark - Actions
- (IBAction)showMenuButtonAction:(id)sender {
    
}

- (IBAction)shareButtonAction:(id)sender {
    
    self.pageControlIndex = _commendButtomView.pageControl.currentPage;
    
    [self shareButtonAction];
}

- (IBAction)messageButtonAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IM" bundle:nil];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textPublishAction {
    
}

- (void)votePublishAction {
    
}

- (void)photoPublishAction {
    
}

- (void)takePhotoAction {
    
}

- (IBAction)myCenterButtonAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyCenter" bundle:nil];
    UINavigationController *nav = [storyboard instantiateInitialViewController];
    MyCenterViewController *myCenterViewController = nav.childViewControllers.firstObject;
    myCenterViewController.userID = GlobalData.userModel.userID;
    
    WEAKSELF
    myCenterViewController.PublishContentBlock = ^{
        GCD_AFTER(0.6, ^{
            [weakSelf showMenuButtonAction:nil];
        });
    };
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)hideHintView:(id)sender {
    if (!_publishHintView.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            _publishHintView.alpha = 0.0;
        } completion:^(BOOL finished) {
            _publishHintView.hidden = YES;
        }];
    }
    
    if (!_otherHintView.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            _otherHintView.alpha = 0.0;
        } completion:^(BOOL finished) {
            _otherHintView.hidden = YES;
        }];
    }
}

#pragma mark - NSNotification Methods
- (void)haveNotifications:(NSNotification *)notification {
    [self.notificationButton setImage:[UIImage imageNamed:@"home-haveNotice"] forState:UIControlStateNormal];
}

- (void)noNotifications:(NSNotification *)notification {
    [self.notificationButton setImage:[UIImage imageNamed:@"home-notice"] forState:UIControlStateNormal];
}

- (void)didBecomeActive:(NSNotification *)notification {
    [self checkNewNotice];
    [self checkUnreadMessages];
}

- (void)didReceiveNotification:(NSNotification *)notification {
    if (notification.object) {
        
        NSDictionary *nameDic = (NSDictionary *)notification.object;
        if (nameDic) {
            NSString *name = nameDic[@"f"];
            if (name && name.length) {
                WEAKSELF
                ListByImNamesApi *listByImNamesApi = [[ListByImNamesApi alloc] initWithUserNames:name];
                [listByImNamesApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
                    if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
                        
                        NSArray *userModelArray = [UserModel JCParse:request.responseJSONObject[@"data"]];
                        
                        if (userModelArray.count) {
                            UserModel *userModel = userModelArray[0];
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IM" bundle:nil];
                            ChatViewController *chatVc = [storyboard instantiateViewControllerWithIdentifier:@"chat"];
                            chatVc.conversationUserModel = userModel;
                            chatVc.fromPush = YES;
                            
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chatVc];
                            [weakSelf presentViewController:nav animated:YES completion:nil];
                            
                        }
                    }
                } failure:^(YTKBaseRequest *request) {
                    
                }];
            }
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController *destinationViewController = [segue destinationViewController].childViewControllers.firstObject;
    
    if ([destinationViewController isKindOfClass:[MyCenterViewController class]]) {
        MyCenterViewController *myCenterViewController = [segue destinationViewController].childViewControllers.firstObject;
        myCenterViewController.userID = self.currentRecommendModel.uid;
    }
    
    if ([destinationViewController isKindOfClass:[OtherCenterViewController class]]) {
        OtherCenterViewController *otherCenterViewController = [segue destinationViewController].childViewControllers.firstObject;
        otherCenterViewController.userID = self.currentRecommendModel.uid;
    }
    
    if ([[segue destinationViewController] isKindOfClass:[CardDetailViewController class]]) {
        CardDetailViewController *cardDetailViewController = [segue destinationViewController];
        cardDetailViewController.recommendModel = self.currentRecommendModel;
        
        UIViewController *vc = segue.destinationViewController;
        if (_commendButtomView.pageControl) {
            if ([vc respondsToSelector:@selector(setCurrentPhotoPage:)]) {
                [vc setValue:[NSNumber numberWithInteger:_commendButtomView.pageControl.currentPage] forKey:@"currentPhotoPage"];
            }
        }
    }
}

#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
//    if ([fromVC isKindOfClass:[HomeViewController class]]) {
//        if ([self.currentRecommendModel.eventType isEqualToString:TextEvent] || [self.currentRecommendModel.eventType isEqualToString:VoteEvent]) {
//            
//            if ([toVC isKindOfClass:[CardDetailViewController class]]) {
//                MagicMoveTransition *transition = [[MagicMoveTransition alloc]init];
//                return transition;
//            } else {
//                return nil;
//            }
//        }
//    }

    return nil;
}

@end
