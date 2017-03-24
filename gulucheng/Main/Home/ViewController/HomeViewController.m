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
#import "CWGuideView.h"
#import "NoDataView.h"

#import "CheckNewNoticeApi.h"

#import "RecommendApi.h"
#import "RecommendOperateApi.h"

#import "MagicMoveTransition.h"
#import "UIImage+ColorImage.h"

@interface HomeViewController () <UINavigationControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *firstScrollView;
@property (strong, nonatomic) UIScrollView *secondScrollView;

@property (strong, nonatomic) UILabel *actionLabel;
@property (strong, nonatomic) UILabel *actionRoundLabel;

@property (strong, nonatomic) NSArray *commendArray;

@property (strong, nonatomic) RecommendModel *tempRecommendModel;

@property (copy, nonatomic) NSString *tempID;
@property (copy, nonatomic) NSString *userID;

@property (assign, nonatomic) BOOL isViewUnLoad;
@property (assign, nonatomic) BOOL isRequestData;
@property (assign, nonatomic) BOOL isEndDraging;

@property (assign, nonatomic) NSInteger page;

@end

@implementation HomeViewController

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 去掉导航分割线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
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
    
    _page = 0;
    _isViewUnLoad = YES;
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    _actionLabel = [[UILabel alloc] init];
    _actionLabel.font = [UIFont systemFontOfSize:14];
    _actionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_actionLabel];
    
    _actionRoundLabel = [[UILabel alloc] init];
    _actionRoundLabel.font = [UIFont systemFontOfSize:12];
    _actionRoundLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_actionRoundLabel];
    
    [self checkNewNotice];
    [self recommendDataSourceRequest];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
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
    _firstScrollView.backgroundColor = [UIColor whiteColor];
    _firstScrollView.showsVerticalScrollIndicator = NO;
    _firstScrollView.pagingEnabled = YES;
    _firstScrollView.scrollsToTop = NO;
    _firstScrollView.delegate = self;
    
    [self.view addSubview:_firstScrollView];
    [self.view bringSubviewToFront:_publishButton];
    
    [self showGuideView];
}

- (void)addSecondScrollView {
    _secondScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _secondScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 3);
    _secondScrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
    _secondScrollView.backgroundColor = [UIColor whiteColor];
    _secondScrollView.showsVerticalScrollIndicator = NO;
    _secondScrollView.pagingEnabled = YES;
    _secondScrollView.scrollsToTop = NO;
    _secondScrollView.delegate = self;
    [self.view addSubview:_secondScrollView];
    
    [self.view sendSubviewToBack:_secondScrollView];
    [self.view bringSubviewToFront:_publishButton];
}

- (void)addPublishViewWithContentView:(UIView *)publishView recommendModel:(RecommendModel *)recommendModel {
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  SCREEN_HEIGHT ,
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
            if (self.textCommendView.textLabel.text.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
                self.textCommendView.textLabel.numberOfLines = 9;
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
                self.textCommendView.textLabel.numberOfLines = 8;
            }
        }
        else if (iPhone5_5s) {
            if (self.textCommendView.textLabel.text.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
                self.textCommendView.textLabel.numberOfLines = 13;
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
                self.textCommendView.textLabel.numberOfLines = 10;
            }
        }
        else if (iPhone6_6s) {
            if (self.textCommendView.textLabel.text.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
                self.textCommendView.textLabel.numberOfLines = 13;
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
                self.textCommendView.textLabel.numberOfLines = 11;
            }
        }
        else if (iPhone6_6sPlus) {
            if (self.textCommendView.textLabel.text.length > 120) {
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
            
//            CGRect rect = weakSelf.textCommendView.frame;
//            rect.origin.y = -500;
//            weakSelf.textCommendView.frame = rect;
        };
        
        [self.textCommendView loadTextCommendModel:recommendModel];
        [publishView addSubview:self.textCommendView];
        
        self.textCommendView.backgroundColor = [UIColor redColor];
        
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (_isViewUnLoad) {
        
        if ((_page + 1) != _commendArray.count) {
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView.contentOffset.y - SCREEN_HEIGHT > 8) {
        [scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT * 2) animated:YES];
    }
    
    if (scrollView.contentOffset.y - SCREEN_HEIGHT < -8) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if (fabs(scrollView.contentOffset.y - SCREEN_HEIGHT) > 8) {
        
        _isViewUnLoad = YES;
        
        [UIView animateWithDuration:0.30
                         animations:^{
                             scrollView.alpha = 0.0;
                         }];
        
        [UIView animateWithDuration:0.15
                         animations:^{
                             _actionLabel.alpha = 0.0;
                             _actionRoundLabel.alpha = 0.0;
                         }];
        
        self.currentRecommendModel = _tempRecommendModel;
    }
    
    _isEndDraging = YES;
}

/**
 *  滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y == 0 || scrollView.contentOffset.y == SCREEN_HEIGHT * 2) {
        
        if (_page < _commendArray.count) {
            RecommendModel *recommendModel = [_commendArray objectAtIndex:_page];
            [self recommendOperateRequestWithCommendModel:recommendModel
                                                   isSkip:scrollView.contentOffset.y == 0];
            
            [scrollView removeFromSuperview];
            scrollView = nil;
            
            _page++;
            _isViewUnLoad = YES;
            
            _actionLabel.alpha = 0.0;
            _actionLabel.font = [UIFont systemFontOfSize:14];
            
            NSLog(@"------\n--------%f    %@", scrollView.contentOffset.y, recommendModel.eid);
        }
    }
}

/**
 *  滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y == 0 || scrollView.contentOffset.y == SCREEN_HEIGHT * 2) {
        
        if (_page < _commendArray.count) {
            RecommendModel *recommendModel = [_commendArray objectAtIndex:_page];
            [self recommendOperateRequestWithCommendModel:recommendModel
                                                   isSkip:scrollView.contentOffset.y == 0];
            
            [scrollView removeFromSuperview];
            scrollView = nil;
            
            _page++;
            _isViewUnLoad = YES;
            
            _actionLabel.alpha = 0.0;
            _actionLabel.font = [UIFont systemFontOfSize:14];
            
            NSLog(@"+++++++++\n+++++++++%f    %@", scrollView.contentOffset.y, recommendModel.eid);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 显示放弃还是传播操作
    [self.view bringSubviewToFront:_actionLabel];
    [self.view bringSubviewToFront:_actionRoundLabel];
    // 显示传播操作
    if (scrollView.contentOffset.y > SCREEN_HEIGHT) {
        
        _actionLabel.frame = CGRectMake(SCREEN_WIDTH/2 - 75,
                                        SCREEN_HEIGHT - ((scrollView.contentOffset.y - SCREEN_HEIGHT)/2 + 8),
                                        150,
                                        25);
        _actionLabel.text = @"传递";
        _actionLabel.textColor = kCOLOR(255, 129, 105, 1.0);
        
        _actionRoundLabel.frame = CGRectMake(SCREEN_WIDTH/2 - 50,
                                             SCREEN_HEIGHT - ((scrollView.contentOffset.y - SCREEN_HEIGHT)/2 - 20 * (scrollView.contentOffset.y / SCREEN_HEIGHT)),
                                             100,
                                             15);
        _actionRoundLabel.text = @"给周围的人";
        _actionRoundLabel.textColor = kCOLOR(204, 204, 204, 1.0);
        
        if (scrollView.contentOffset.y - SCREEN_HEIGHT <= 30) {
            _actionLabel.alpha = 0.0;
            _actionRoundLabel.alpha = 0.0;
        } else if (scrollView.contentOffset.y - SCREEN_HEIGHT <= 50) {
            if (!_isEndDraging) {
                _actionLabel.alpha = (scrollView.contentOffset.y - SCREEN_HEIGHT - 30) / (50 - 30);
                _actionRoundLabel.alpha = (scrollView.contentOffset.y - SCREEN_HEIGHT - 30) / (50 - 30);
            }
        } else {
            if (!_isEndDraging) {
                _actionLabel.alpha = 1.0;
                _actionRoundLabel.alpha = 1.0;
            }
            _actionLabel.font = [UIFont systemFontOfSize:14 + (scrollView.contentOffset.y - SCREEN_HEIGHT) / (SCREEN_HEIGHT/40)];
            
        }
    }
    // 显示放弃操作
    if (scrollView.contentOffset.y < SCREEN_HEIGHT) {
        _actionLabel.frame = CGRectMake(SCREEN_WIDTH/2 - 75,
                                        (SCREEN_HEIGHT - scrollView.contentOffset.y)/2 - 8,
                                        150,
                                        25);
        _actionLabel.text = @"放弃";
        _actionLabel.textColor = kCOLOR(153, 153, 153, 1.0);
        
        if (SCREEN_HEIGHT - scrollView.contentOffset.y <= 30) {
            _actionLabel.alpha = 0.0;
        } else if (SCREEN_HEIGHT - scrollView.contentOffset.y <= 50) {
            if (!_isEndDraging) {
                _actionLabel.alpha = (SCREEN_HEIGHT - scrollView.contentOffset.y - 30) / (50 - 30);
            }
        } else {
            if (!_isEndDraging) {
                _actionLabel.alpha = 1.0;
            }
            _actionLabel.font = [UIFont systemFontOfSize:14 + (SCREEN_HEIGHT - scrollView.contentOffset.y) / (SCREEN_HEIGHT/40)];
        }
    }
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

- (IBAction)showMenuButtonAction:(id)sender {
    
}

- (IBAction)shareButtonAction:(id)sender {
    
    self.pageControlIndex = _commendButtomView.pageControl.currentPage;
    
    [self shareButtonAction];
}

- (void)textPublishAction {
    
}

- (void)votePublishAction {
    
}

- (void)photoPublishAction {
    
}

- (void)takePhotoAction {
    
}

// 检查是否有新的通知
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

// 重新请求下一波数据
- (void)recommendDataSourceRequest {
    
    _page = 0;
    RecommendApi *recommentApi = [[RecommendApi alloc] initWithLatitude:self.latitude
                                                              longitude:self.longitude];
    
    [MBProgressHUD showMessage:Loading toView:self.view];
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
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
    } failure:^(YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
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

#pragma mark - NSNotification Methods
- (void)haveNotifications:(NSNotification *)notification {
    [self.notificationButton setImage:[UIImage imageNamed:@"home-haveNotice"] forState:UIControlStateNormal];
}

- (void)noNotifications:(NSNotification *)notification {
    [self.notificationButton setImage:[UIImage imageNamed:@"home-notice"] forState:UIControlStateNormal];
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
    }
}

#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if ([fromVC isKindOfClass:[HomeViewController class]]) {
        if ([self.currentRecommendModel.eventType isEqualToString:TextEvent] || [self.currentRecommendModel.eventType isEqualToString:VoteEvent]) {
            
            if ([toVC isKindOfClass:[CardDetailViewController class]]) {
                MagicMoveTransition *transition = [[MagicMoveTransition alloc]init];
                return transition;
            } else {
                return nil;
            }
        }
    }

    return nil;
}

@end
