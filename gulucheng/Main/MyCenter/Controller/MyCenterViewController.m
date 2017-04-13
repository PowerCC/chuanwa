//
//  MyCenterViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/31.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "MyCenterViewController.h"
#import "CardDetailViewController.h"
#import "PublishCollectionViewCell.h"
#import "SettingViewController.h"
#import "ScoreViewController.h"
#import "WaterView.h"
#import "NoPublishView.h"

#import "EventListApi.h"
#import "UserInfoApi.h"
#import "CommentEventListApi.h"
#import "FavoriteListApi.h"

#import "RecommendModel.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import <POP/POP.h>

static NSInteger const limit = 12;

#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3

@interface MyCenterViewController() <MAMapViewDelegate, AMapLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (nonatomic, strong) UIView *animateView;
@property (nonatomic, strong) UIImageView *pointImageView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UserModel *userModel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendAroundLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *scoreLabelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet UIButton *currentButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) IBOutlet UIButton *statisticsButton;
//@property (weak, nonatomic) IBOutlet UIButton *notificationButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (strong, nonatomic) UIImageView *guideView;
@property (weak, nonatomic) IBOutlet UIImageView *slideImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *centerScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *publishScrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *currentPublishCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *historyPublishCollectionView;
//@property (weak, nonatomic) IBOutlet UICollectionView *notificationCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *favoriteCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *currentCollectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *historyCollectionViewFlowLayout;
//@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *notificationCollectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *favoriteCollectionViewFlowLayout;

@property (weak, nonatomic) IBOutlet UIView *StatisticsView;
@property (weak, nonatomic) IBOutlet UILabel *totalCardCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoCardCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *textCardCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCardCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCenterViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voteConstraint;

@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger historyPage;
//@property (assign, nonatomic) NSInteger notificationPage;
@property (assign, nonatomic) NSInteger favoritePage;

@property (strong, nonatomic) NSMutableArray *currentPublishArray;
@property (strong, nonatomic) NSMutableArray *historyPublishArray;
//@property (strong, nonatomic) NSMutableArray *commentEventArray;
@property (strong, nonatomic) NSMutableArray *favoriteArray;

@end

@implementation MyCenterViewController

- (void)dealloc {
    [_timer invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    _myCenterViewHeightConstraint.constant = SCREEN_HEIGHT - 64 + 320;
    _viewWidthConstraint.constant = SCREEN_WIDTH * 4;
}

#pragma mark - Action Handle

- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)cleanUpAction {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)reGeocodeAction {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)locAction {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentPage = 0;
    _historyPage = 0;
//    _notificationPage = 0;
    _favoritePage = 0;
    
    //self.mapView.layer.cornerRadius = 4.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteRefresh:) name:N_MY_CENTER_FAVORITE_REFRESH object:nil];

    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = self.navView.bounds;
    [self.navView addSubview:effectView];
    
    _currentButton.selected = YES;
    
    _currentPublishArray = [[NSMutableArray alloc] initWithCapacity:20];
    _historyPublishArray = [[NSMutableArray alloc] initWithCapacity:20];
//    _commentEventArray = [[NSMutableArray alloc] initWithCapacity:20];
    _favoriteArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    CGSize publishCellSize;
//    CGSize notificationCellSize;
    CGSize favoriteCellSize;
    if (iPhone4_4s || iPhone5_5s) {
        publishCellSize = CGSizeMake(175 * (SCREEN_WIDTH / 375) - 2, 223 * (SCREEN_WIDTH / 375) - 1);
//        notificationCellSize = CGSizeMake(110 * (SCREEN_WIDTH / 375.0) - 1, 120 * (SCREEN_WIDTH / 375.0));
        favoriteCellSize = CGSizeMake(110 * (SCREEN_WIDTH / 375.0) - 1, 120 * (SCREEN_WIDTH / 375.0));
    } else if (iPhone6_6s) {
        publishCellSize = CGSizeMake(175, 223);
//        notificationCellSize = CGSizeMake(110, 120);
        favoriteCellSize = CGSizeMake(110, 120);
    } else if (iPhone6_6sPlus) {
        publishCellSize = CGSizeMake(175 * (414.0 / 375) + 1, 223 * (414.0 / 375));
//        notificationCellSize = CGSizeMake(110 * (414.0 / 375) + 2, 120 * (414.0 / 375));
        favoriteCellSize = CGSizeMake(110 * (414.0 / 375) + 2, 120 * (414.0 / 375));
    }
    
    _currentCollectionViewFlowLayout.itemSize = publishCellSize;
    _historyCollectionViewFlowLayout.itemSize = publishCellSize;
//    _notificationCollectionViewFlowLayout.itemSize = notificationCellSize;
    _favoriteCollectionViewFlowLayout.itemSize = favoriteCellSize;
    
    UserInfoApi *userInfoApi = [[UserInfoApi alloc] initWithOtherUserID:_userID];
    
    WEAKSELF
    [userInfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            weakSelf.userModel = [UserModel JCParse:request.responseJSONObject[@"data"]];
            
            weakSelf.nickNameLabel.text = weakSelf.userModel.nickName;
            weakSelf.locationLabel.text = [NSString stringWithFormat:@"常在地区：%@", GlobalData.userModel.cityCode];
            weakSelf.sendAroundLabel.text = weakSelf.userModel.sendAround;
            weakSelf.startScoreLabel.text = weakSelf.userModel.thisScore;
            weakSelf.nextScoreLabel.text = weakSelf.userModel.nextScore;
            weakSelf.scoreLabel.text = weakSelf.userModel.score;
            
            [weakSelf labelAnimatedWithPercent:(weakSelf.userModel.score.floatValue - weakSelf.userModel.thisScore.floatValue)/
                                           (weakSelf.userModel.nextScore.floatValue - weakSelf.userModel.thisScore.floatValue)];
            
            [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.userModel.avatar]];
            GlobalData.userModel.avatar = weakSelf.userModel.avatar;
            weakSelf.genderImageView.image = [UIImage imageNamed:weakSelf.userModel.gender.integerValue == 1 ? @"myCenter-boy" : @"myCenter-girl"];
            
            weakSelf.totalCardCountLabel.text = weakSelf.userModel.events;
            weakSelf.photoCardCountLabel.text = [NSString stringWithFormat:@"%@张", weakSelf.userModel.picEvents];
            weakSelf.textCardCountLabel.text = [NSString stringWithFormat:@"%@张", weakSelf.userModel.textEvents];
            weakSelf.voteCardCountLabel.text = [NSString stringWithFormat:@"%@张", weakSelf.userModel.voteEvents];
            
            NSArray *eventArray = @[weakSelf.userModel.picEvents, weakSelf.userModel.textEvents, weakSelf.userModel.voteEvents];
            NSInteger maxEvent = [[eventArray valueForKeyPath:@"@max.intValue"] integerValue];
            
            if (maxEvent != 0) {
                weakSelf.photoConstraint.constant = weakSelf.userModel.picEvents.floatValue/maxEvent * 145;
                weakSelf.textConstraint.constant = weakSelf.userModel.textEvents.floatValue/maxEvent * 145;
                weakSelf.voteConstraint.constant = weakSelf.userModel.voteEvents.floatValue/maxEvent * 145;
            }
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
    
    // 请求发布页面数据
    [self requestMorePublishWithType:1 offset:0];
    [self requestMorePublishWithType:2 offset:0];
//    [self requestMoreCommentEventWithOffset:0];
    [self requestMoreFavoriteWithOffset:0];
    
    [self addFooter];
    
    [self initMapView];
    [self initCompleteBlock];
    [self configLocationManager];
    [self locAction];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstMyCenterShow"]) {
        NSLog(@"第一次使用app客户端！");
        // 首次使用app进入教程
        self.guideView = [[UIImageView alloc] initWithFrame:self.view.frame];
        NSString *path;
        if (iPhone4_4s) {
            path = [[NSBundle mainBundle] pathForResource:@"iPhone4-001" ofType:@"png"];
        }
        if (iPhone5_5s) {
            path = [[NSBundle mainBundle] pathForResource:@"iPhone5-001" ofType:@"png"];
        }
        if (iPhone6_6s) {
            path = [[NSBundle mainBundle] pathForResource:@"iPhone6-001" ofType:@"png"];
        }
        if (iPhone6_6sPlus) {
            path = [[NSBundle mainBundle] pathForResource:@"iPhone6plus-001" ofType:@"png"];
        }
        
        self.guideView.image = [UIImage imageWithContentsOfFile:path];
        self.guideView.userInteractionEnabled = YES;
        [self.view addSubview:self.guideView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchUpInside)];
        [self.guideView addGestureRecognizer:tapGestureRecognizer];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstMyCenterShow"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)touchUpInside {
    [self.guideView removeFromSuperview];
}

- (void)addFooter {
    WEAKSELF
    _currentPublishCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMorePublishWithType:1 offset:limit * ++ weakSelf.currentPage];
    }];
    _currentPublishCollectionView.mj_footer.hidden = YES;
    
    _historyPublishCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMorePublishWithType:2 offset:limit * ++ weakSelf.historyPage];
    }];
    _historyPublishCollectionView.mj_footer.hidden = YES;
    
//    _notificationCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestMoreCommentEventWithOffset:24 * ++ weakSelf.notificationPage];
//    }];
//    _notificationCollectionView.mj_footer.hidden = YES;
    
    _favoriteCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMoreFavoriteWithOffset:limit * ++ weakSelf.favoritePage];
    }];
    _favoriteCollectionView.mj_footer.hidden = YES;
}

- (IBAction)publishButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self changeSelectedButtonColorWithIndex:button.tag];
    
    [_publishScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * button.tag, 0) animated:YES];
}


- (void)requestMorePublishWithType:(NSInteger)currentFlag offset:(NSInteger)offset {
    
    EventListApi *eventLishApi = [[EventListApi alloc] initWithOtherUserID:_userID
                                                                     limit:[NSString stringWithFormat:@"%td", limit]
                                                                    offset:[NSString stringWithFormat:@"%td", offset]
                                                               currentFlag:[NSString stringWithFormat:@"%td", currentFlag]];
    
    WEAKSELF
    [eventLishApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            NSString *totalCount = request.responseJSONObject[@"data"][@"count"];
            
            NSArray *publishArray = [RecommendModel JCParse:request.responseJSONObject[@"data"][@"list"]];
            
            if (currentFlag == 1) {
                [weakSelf.currentPublishArray addObjectsFromArray:publishArray];
                
                if (weakSelf.currentPublishArray.count) {
                    [weakSelf.currentPublishCollectionView reloadData];
                } else {
                    [weakSelf.currentPublishCollectionView reloadData];
                    [weakSelf loadNoContentViewWithContentView:weakSelf.currentPublishCollectionView
                                                firstTitle:@"你最近还没有发布过内容，来个随手拍~"
                                               secondTitle:@"影响你的世界！"];
                }
                
                [weakSelf.currentPublishCollectionView.mj_footer endRefreshing];
                
                if (totalCount.integerValue == weakSelf.currentPublishArray.count) {
                    [weakSelf.currentPublishCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            if (currentFlag == 2) {
                [weakSelf.historyPublishArray addObjectsFromArray:publishArray];
                
                if (weakSelf.historyPublishArray.count) {
                    [weakSelf.historyPublishCollectionView reloadData];
                } else {
                    [weakSelf.historyPublishCollectionView reloadData];
                    [weakSelf loadNoContentViewWithContentView:weakSelf.historyPublishCollectionView
                                                firstTitle:@"暂无内容，让世界知道你的声音~"
                                               secondTitle:@"让别人传递你的世界吧！"];
                }
                
                [weakSelf.historyPublishCollectionView.mj_footer endRefreshing];
                
                if (totalCount.integerValue == weakSelf.historyPublishArray.count) {
                    [weakSelf.historyPublishCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
        
    } failure:^(YTKBaseRequest *request) {
        [weakSelf.historyPublishCollectionView.mj_footer endRefreshing];
    }];
}

//- (void)requestMoreCommentEventWithOffset:(NSInteger)offset {
//    CommentEventListApi *commentEventListApi = [[CommentEventListApi alloc] initWithLimit:24
//                                                                                   offset:offset];
//    [commentEventListApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        if ([self isSuccessWithRequest:request.responseJSONObject]) {
//            
//            NSString *totalCount = request.responseJSONObject[@"data"][@"totalCount"];
//            
//            NSArray *commentArray = [RecommendModel JCParse:request.responseJSONObject[@"data"][@"list"]];
//            
//            [self.commentEventArray addObjectsFromArray:commentArray];
//            
//            if (self.commentEventArray.count) {
//                [self.notificationCollectionView reloadData];
//            } else {
//                [self loadNoContentViewWithContentView:self.notificationCollectionView
//                                            firstTitle:@"还没有任何留言~"
//                                           secondTitle:@""];
//            }
//            
//            [self.notificationCollectionView.mj_footer endRefreshing];
//            
//            if (totalCount.integerValue == self.commentEventArray.count) {
//                [self.notificationCollectionView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
//    } failure:^(YTKBaseRequest *request) {
//        
//    }];
//}

- (void)requestMoreFavoriteWithOffset:(NSInteger)offset {
    FavoriteListApi *favoriteListApi = [[FavoriteListApi alloc] initWithUid:GlobalData.userModel.userID limit:limit offset:offset];
    
    WEAKSELF
    [favoriteListApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            NSString *totalCount = request.responseJSONObject[@"data"][@"count"];
            
            NSArray *favoriteArray = [RecommendModel JCParse:request.responseJSONObject[@"data"][@"list"]];
            
            [weakSelf.favoriteArray addObjectsFromArray:favoriteArray];
            
            if (weakSelf.favoriteArray.count) {
                [weakSelf.favoriteCollectionView reloadData];
            } else {
                [weakSelf.favoriteCollectionView reloadData];
                [weakSelf loadNoContentViewWithContentView:weakSelf.favoriteCollectionView
                                            firstTitle:@"你还没有收藏任何内容哦~"
                                           secondTitle:@"可以在卡片详情中进行收藏"];
            }
            
            [weakSelf.favoriteCollectionView.mj_footer endRefreshing];
            
            if (totalCount.integerValue == self.favoriteArray.count) {
                [weakSelf.favoriteCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(YTKBaseRequest *request) {
        [weakSelf.favoriteCollectionView.mj_footer endRefreshing];
    }];
}


#pragma mark - collectionView About
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == _currentPublishCollectionView)
        return _currentPublishArray.count;
    
    if (collectionView == _historyPublishCollectionView)
        return _historyPublishArray.count;
        
//    return _commentEventArray.count;
    return _favoriteArray.count;
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PublishCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"publishCell" forIndexPath:indexPath];
    
    RecommendModel *recommendModel;
    
    if (collectionView == _currentPublishCollectionView) {
        
        recommendModel = [_currentPublishArray objectAtIndex:indexPath.row];
        
        cell.spreadCountLabel.text = [NSString stringWithFormat:@"%@", recommendModel.spreadTimes];
    }
    
    if (collectionView == _historyPublishCollectionView) {
        
        recommendModel = [_historyPublishArray objectAtIndex:indexPath.row];
        
        cell.messageCountLabel.text = recommendModel.commentTimes;
        cell.peopleCountLabel.text = recommendModel.spreadTimes;
    }
    
//    if (collectionView == _notificationCollectionView) {
//        recommendModel = [_commentEventArray objectAtIndex:indexPath.row];
//    }
    
    if (collectionView == _favoriteCollectionView) {
        recommendModel = [_favoriteArray objectAtIndex:indexPath.row];
    }
    
    cell.layer.cornerRadius = 2.0;
    
    cell.textLabel.text = nil;
    cell.photoImageView.image = nil;
    cell.voteImageView.image = nil;
    
    cell.leftDaysLabel.text = [NSString stringWithFormat:@"%@天结束传递", recommendModel.days];
    
    if ([recommendModel.eventType isEqualToString:TextEvent]) {
        cell.textLabel.text = recommendModel.textModel.content;
    }
    
    if ([recommendModel.eventType isEqualToString:VoteEvent]) {
        cell.voteImageView.image = [UIImage imageNamed:@"myCenter-voteType"];
        cell.textLabel.text = recommendModel.voteModel.title;
    }
    
    if ([recommendModel.eventType isEqualToString:PictureEvent]) {
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:recommendModel.spic]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendModel *recommendModel;
    
    if (collectionView == _currentPublishCollectionView) {
        recommendModel = [_currentPublishArray objectAtIndex:indexPath.row];
    }
    
    if (collectionView == _historyPublishCollectionView) {
        recommendModel = [_historyPublishArray objectAtIndex:indexPath.row];
    }
    
//    if (collectionView == _notificationCollectionView) {
//        recommendModel = [_commentEventArray objectAtIndex:indexPath.row];
//    }
    
    if (collectionView == _favoriteCollectionView) {
        recommendModel = [_favoriteArray objectAtIndex:indexPath.row];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    CardDetailViewController *cardDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"cardDetailID"];
    cardDetailViewController.recommendModel = recommendModel;
    WEAKSELF
    cardDetailViewController.removeThisCardBlock = ^{
        if (collectionView == weakSelf.currentPublishCollectionView) {
            [weakSelf.currentPublishArray removeObjectAtIndex:indexPath.row];
        }
        
        if (collectionView == weakSelf.historyPublishCollectionView) {
            [weakSelf.historyPublishArray removeObjectAtIndex:indexPath.row];
        }
        
//        if (collectionView == weakSelf.notificationCollectionView) {
//            [weakSelf.commentEventArray removeObjectAtIndex:indexPath.row];
//        }
        
        if (collectionView == weakSelf.favoriteCollectionView) {
            [weakSelf.favoriteArray removeObjectAtIndex:indexPath.row];
        }
        
        [collectionView reloadData];
    };
    
    [self.navigationController pushViewController:cardDetailViewController animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (scrollView == _currentPublishCollectionView ||
        scrollView == _historyPublishCollectionView) {//||
//        scrollView == _notificationCollectionView) {
//        scrollView == _favoriteCollectionView) {
        
        if (scrollView.contentSize.height > scrollView.frame.size.height) {
            scrollView.mj_footer.hidden = NO;
        }
    }
    else if (scrollView == _favoriteCollectionView) {
        scrollView.mj_footer.hidden = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == _centerScrollView) {
        if (scrollView.contentOffset.y > 226) {
            _currentPublishCollectionView.scrollEnabled = YES;
            _historyPublishCollectionView.scrollEnabled = YES;
//            _notificationCollectionView.scrollEnabled = YES;
            _favoriteCollectionView.scrollEnabled = YES;
        } else {
            _currentPublishCollectionView.scrollEnabled = NO;
            _historyPublishCollectionView.scrollEnabled = NO;
//            _notificationCollectionView.scrollEnabled = NO;
            _favoriteCollectionView.scrollEnabled = NO;
        }
    }
    
    if (scrollView == _publishScrollView) {
        CGRect rect = _slideImageView.frame;
        rect.origin.x = _currentButton.centerX - rect.size.width/2 + scrollView.contentOffset.x/3;
        _slideImageView.frame = rect;
    }
    
    if (scrollView == _currentPublishCollectionView ||
        scrollView == _historyPublishCollectionView ||
//        scrollView == _notificationCollectionView) {
        scrollView == _favoriteCollectionView) {
        
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointZero;
            
            scrollView.scrollEnabled = NO;
            [self scrollViewToTop];
        }
    }
    
    
    if (scrollView == _publishScrollView) {
        CGRect rect = _slideImageView.frame;
        rect.origin.x = _currentButton.centerX - rect.size.width/2 + scrollView.contentOffset.x/4;
        _slideImageView.frame = rect;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _publishScrollView) {
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        [self changeSelectedButtonColorWithIndex:index];
    }
}

- (void)changeSelectedButtonColorWithIndex:(NSInteger)index {
    [self setCurrentButton:index == 0 ? YES : NO
             historyButton:index == 1 ? YES : NO
           statisticButton:index == 2 ? YES : NO
        notificationButton:index == 3 ? YES : NO];
}

- (void)setCurrentButton:(BOOL)isCurrent historyButton:(BOOL)isHistory statisticButton:(BOOL)isStatistic notificationButton:(BOOL)isNotification {
    
    _currentButton.selected = isCurrent;
    _historyButton.selected = isHistory;
    _statisticsButton.selected = isStatistic;
//    _notificationButton.selected = isNotification;
    _favoriteButton.selected = isNotification;
}

#pragma mark - loadNoContentView

- (void)loadNoContentViewWithContentView:(UICollectionView *)contentView firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle {
    NoPublishView *noPublishView = [NoPublishView awakeWithNib];
    noPublishView.center = CGPointMake(CGRectGetWidth(contentView.frame)/2, CGRectGetHeight(noPublishView.frame)/2 + 52);
    noPublishView.firstLabel.text = firstTitle;
    noPublishView.secondLabel.text = secondTitle;
    [contentView addSubview:noPublishView];
    
    WEAKSELF
    noPublishView.PublishContentBlock = ^{
        if (weakSelf.PublishContentBlock) {
            weakSelf.PublishContentBlock();
        }
        [weakSelf dismissView];
    };
}

#pragma mark - Initialization

- (void)initCompleteBlock {
    WEAKSELF
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        
        if (location) {
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            [annotation setCoordinate:location.coordinate];
            
            if (regeocode) {
                [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
                [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
            }
            else {
                [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
                [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
            }
            
            STRONGSELF
            [strongSelf addAnnotationToMapView:annotation];
        }
    };
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation {
    [self.mapView addAnnotation:annotation];
    
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setZoomLevel:15.1 animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

- (void)initMapView {
    [self.mapView setDelegate:self];
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
}

#pragma mark - NSNotification Methods
- (void)favoriteRefresh:(NSNotification *)notification {
    [_favoriteArray removeAllObjects];
    _favoritePage = 0;
    [self requestMoreFavoriteWithOffset:0];
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.draggable = NO;
        
        _animateView = [[UIView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
        
        [annotationView addSubview:_animateView];
        
        _pointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myCenter-locationPoint"]];
        _pointImageView.frame = CGRectMake(0, 0, 12, 12);
        [_animateView addSubview:_pointImageView];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.6 target:self selector:@selector(pointImageViewAnimated) userInfo:nil repeats:YES];
        [_timer fire];
        
        return annotationView;
    }
    
    return nil;
}

- (void)pointImageViewAnimated {

    WEAKSELF
    [UIView animateWithDuration:0.1
                     animations:^{
                         weakSelf.pointImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              weakSelf.pointImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              [UIView animateWithDuration:0.2
                                                               animations:^{
                                                                   weakSelf.pointImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                               } completion:^(BOOL finished) {
                                                                   [weakSelf bigCircleViewAnimated];
                                                               }];
                                          }];
                     }];
}

- (void)bigCircleViewAnimated {
    
    __block WaterView *waterView = [[WaterView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    waterView.backgroundColor = [UIColor clearColor];
    [_animateView addSubview:waterView];
    
    [_animateView bringSubviewToFront:_pointImageView];
    
    [UIView animateWithDuration:1 animations:^{
        waterView.transform = CGAffineTransformMakeScale(3, 3);
        waterView.alpha = 0;
    } completion:^(BOOL finished) {
        
        waterView.transform = CGAffineTransformMakeScale(1, 1);
        waterView.alpha = 1.0;
        
        [UIView animateWithDuration:1 animations:^{
            waterView.transform = CGAffineTransformMakeScale(3, 3);
            waterView.alpha = 0;
        } completion:^(BOOL finished) {
            [waterView removeFromSuperview];
        }];
    }];
}

- (void)labelAnimatedWithPercent:(float)percent {

    POPAnimatableProperty *constantProperty = [POPAnimatableProperty propertyWithName:@"constant" initializer:^(POPMutableAnimatableProperty *prop){
        prop.readBlock = ^(NSLayoutConstraint *layoutConstraint, CGFloat values[]) {
            values[0] = [layoutConstraint constant];
        };
        prop.writeBlock = ^(NSLayoutConstraint *layoutConstraint, const CGFloat values[]) {
            [layoutConstraint setConstant:values[0]];
        };
    }];
    
    POPSpringAnimation *constantAnimation = [POPSpringAnimation animation];
    constantAnimation.property = constantProperty;
    constantAnimation.fromValue = @(self.scoreViewWidthConstraint.constant);
    constantAnimation.toValue = @((SCREEN_WIDTH - 16 * 2) * percent);
    constantAnimation.beginTime = CACurrentMediaTime() + 1.0f;
    constantAnimation.springBounciness = 10.0f;
    [self.scoreViewWidthConstraint pop_addAnimation:constantAnimation forKey:@"constantAnimation"];
    
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anSpring.toValue = @(16 * 2 * (1 - percent) + (SCREEN_WIDTH - 16 * 2) * percent);
    anSpring.beginTime = CACurrentMediaTime() + 1.0f;
    anSpring.springBounciness = 10.0f;
    [self.scoreLabelView pop_addAnimation:anSpring forKey:@"position"];
}

- (void)scrollViewToTop {
    WEAKSELF
    [UIView animateWithDuration:0.3
                     animations:^{
                         [weakSelf.centerScrollView setContentOffset:CGPointMake(0, -64)];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissView {
    
    [_timer invalidate];
    [self cleanUpAction];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBAcions
- (IBAction)dismissButton:(id)sender {
    [self dismissView];
}

- (IBAction)gotoMyWalletAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Wallet" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MyWallet"];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
    
#pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue destinationViewController] isKindOfClass:[SettingViewController class]]) {
        SettingViewController *settingViewController = [segue destinationViewController];
        WEAKSELF
        settingViewController.editNicknameBlock = ^(NSString *nickName) {
            weakSelf.nickNameLabel.text = nickName;
        };
        settingViewController.editHeadImageBlock = ^(UIImage *headImage) {
            weakSelf.headImageView.image = headImage;
        };
        settingViewController.editCityBlock = ^(NSString *city) {
            weakSelf.locationLabel.text = [NSString stringWithFormat:@"常在地区：%@", city];
        };
    }
    
    if ([[segue destinationViewController] isKindOfClass:[ScoreViewController class]]) {
        ScoreViewController *scoreViewController = [segue destinationViewController];
        scoreViewController.userModel = self.userModel;
    }
}

@end
