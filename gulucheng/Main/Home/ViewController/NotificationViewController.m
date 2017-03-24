//
//  NotificationViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/22.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "NotificationViewController.h"
#import "HomeViewController.h"
#import "CardDetailViewController.h"
#import "NotificationCollectionViewCell.h"
#import "NoDataView.h"
#import "RecommendModel.h"
#import "UserEventVoModel.h"
#import "PhotoModel.h"
#import "UIImage+ColorImage.h"

#import "NotificationApi.h"
#import "EventNoticeListApi.h"

static NSInteger const limit = 24;

@interface NotificationViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *currentButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) IBOutlet UIButton *otherPeopleNewsButton;
@property (weak, nonatomic) IBOutlet UIButton *historyNewsButton;

@property (weak, nonatomic) IBOutlet UIImageView *lastMessageFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *historyFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *otherPeopleNewsFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *historyNewsFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *slideImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *notificationScrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *publishedCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *markCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *otherPeopleNewsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *historyNewsCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *publishedCollectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *markCollectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *otherPeopleNewsCollectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *historyNewsCollectionViewFlowLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidthConstraint;

@property (strong, nonatomic) UserEventVoModel *currentUserEventVoModel;

@property (assign, nonatomic) NSInteger lastMessagePage;
@property (assign, nonatomic) NSInteger historyPage;
@property (assign, nonatomic) NSInteger otherPeopleNewsPage;
@property (assign, nonatomic) NSInteger historyNewsPage;

@property (strong, nonatomic) NSMutableArray *lastMessageArray;
@property (strong, nonatomic) NSMutableArray *historyArray;
@property (strong, nonatomic) NSMutableArray *otherPeopleNewsArray;
@property (strong, nonatomic) NSMutableArray *historyNewsArray;

@end

@implementation NotificationViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationsRefresh:) name:N_NOTIFICATIONS_REFRESH object:nil];
    
    _lastMessagePage = 0;
    _historyPage = 0;
    _otherPeopleNewsPage = 0;
    _historyNewsPage = 0;
    
    _currentButton.selected = YES;
    
    _lastMessageArray = [[NSMutableArray alloc] initWithCapacity:20];
    _historyArray = [[NSMutableArray alloc] initWithCapacity:20];
    _otherPeopleNewsArray = [[NSMutableArray alloc] initWithCapacity:20];
    _historyNewsArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    _lastMessageFlagImageView.hidden = YES;
    _historyFlagImageView.hidden = YES;
    _otherPeopleNewsFlagImageView.hidden = YES;
    _historyNewsFlagImageView.hidden = YES;
    
    CGSize publishCellSize;
    if (iPhone4_4s || iPhone5_5s) {
        publishCellSize = CGSizeMake(110 * (320.0 / 375) - 1, 120 * (320.0 / 375));
    } else if (iPhone6_6s) {
        publishCellSize = CGSizeMake(110, 120);
    } else if (iPhone6_6sPlus) {
        publishCellSize = CGSizeMake(110 * (414.0 / 375) + 2, 120 * (414.0 / 375));
    }
    
    _publishedCollectionViewFlowLayout.itemSize = publishCellSize;
    _markCollectionViewFlowLayout.itemSize = publishCellSize;
    _otherPeopleNewsCollectionViewFlowLayout.itemSize = publishCellSize;
    _historyNewsCollectionViewFlowLayout.itemSize = publishCellSize;
    
//    [self requestMorePublishWithType:1 offset:0];
//    [self requestMorePublishWithType:2 offset:0];

    [self requestMyEventNoticeListWithType:1 ownFlag:1 offset:0];
    [self requestMyEventNoticeListWithType:2 ownFlag:1 offset:0];
    [self requestOtherEventNoticeListWithType:1 ownFlag:2 offset:0];
    [self requestOtherEventNoticeListWithType:2 ownFlag:2 offset:0];
    
    
    [self addFooter];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    if (_lastMessageFlagImageView.hidden && _historyFlagImageView.hidden && _otherPeopleNewsFlagImageView.hidden && _historyNewsFlagImageView.hidden) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:N_HOME_NO_NOTIFICATIONS object:nil];
//    }
//    else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:N_HOME_HAVE_NOTIFICATIONS object:nil];
//    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    _scrollViewWidthConstraint.constant = SCREEN_WIDTH * 4;
    _notificationScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)notificationButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self changeSelectedButtonColorWithIndex:button.tag];
    
    [_notificationScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * button.tag, 0) animated:YES];
}

- (void)addFooter {
    WEAKSELF
    _publishedCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestMorePublishWithType:1 offset:limit * ++ _lastMessagePage];
        [weakSelf requestMyEventNoticeListWithType:1 ownFlag:1 offset:limit * ++ weakSelf.lastMessagePage];
    }];
    _publishedCollectionView.mj_footer.hidden = YES;
    
    _markCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestMorePublishWithType:2 offset:limit * ++ _historyPage];
        [weakSelf requestMyEventNoticeListWithType:2 ownFlag:1 offset:limit * ++ weakSelf.lastMessagePage];
    }];
    _markCollectionView.mj_footer.hidden = YES;
    
    _otherPeopleNewsCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestMorePublishWithType:2 offset:limit * ++ _historyPage];
        [weakSelf requestOtherEventNoticeListWithType:1 ownFlag:2 offset:limit * ++ weakSelf.otherPeopleNewsPage];
    }];
    _otherPeopleNewsCollectionView.mj_footer.hidden = YES;
    
    _historyNewsCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestMorePublishWithType:2 offset:limit * ++ _historyPage];
        [weakSelf requestOtherEventNoticeListWithType:2 ownFlag:2 offset:limit * ++ weakSelf.historyNewsPage];
    }];
    _historyNewsCollectionView.mj_footer.hidden = YES;
}

- (void)requestMorePublishWithType:(NSInteger)currentFlag offset:(NSInteger)offset {
    NotificationApi *notification = [[NotificationApi alloc] initWithOtherUserID:GlobalData.userModel.userID
                                                                           limit:limit
                                                                          offset:offset
                                                                     currentFlag:currentFlag];
    WEAKSELF
    [notification startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            NSString *totalCount = request.responseJSONObject[@"data"][@"count"];
            
            NSArray *notificationArray = [RecommendModel JCParse:request.responseJSONObject[@"data"][@"list"]];
            
            if (currentFlag == 1) {
                [weakSelf.lastMessageArray addObjectsFromArray:notificationArray];
                
                if (weakSelf.lastMessageArray.count) {
                    [weakSelf.publishedCollectionView reloadData];
                } else {
                    [AppDelegateInstance.homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-notice"] forState:UIControlStateNormal];
                    [weakSelf loadNoContentViewWithContentView:weakSelf.publishedCollectionView firstTitle:@"有留言会第一时间通知哦～" secondTitle:@""];
                }
                
                [weakSelf.publishedCollectionView.mj_footer endRefreshing];
                
                if (totalCount.integerValue == weakSelf.lastMessageArray.count) {
                    [weakSelf.publishedCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            if (currentFlag == 2) {
                [weakSelf.historyArray addObjectsFromArray:notificationArray];
                
                if (weakSelf.historyArray.count) {
                    [weakSelf.markCollectionView reloadData];
                } else {
                    [weakSelf loadNoContentViewWithContentView:weakSelf.markCollectionView firstTitle:@"发布优质内容 一定会有留言哦！" secondTitle:@""];
                }
                
                [weakSelf.markCollectionView.mj_footer endRefreshing];
                
                if (totalCount.integerValue == weakSelf.historyArray.count) {
                    [weakSelf.markCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

- (void)requestMyEventNoticeListWithType:(NSInteger)currentFlag ownFlag:(NSInteger)ownFloag offset:(NSInteger)offset {
    EventNoticeListApi *notification = [[EventNoticeListApi alloc] initWithOtherUserID:GlobalData.userModel.userID
                                                                           limit:limit
                                                                          offset:offset
                                                                     currentFlag:currentFlag
                                                                         ownFlag:ownFloag];
    WEAKSELF
    [notification startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            NSString *totalCount = request.responseJSONObject[@"data"][@"count"];
            
//            NSArray *notificationArray = [RecommendModel JCParse:request.responseJSONObject[@"data"][@"list"]];
            
            NSArray *notificationArray = [UserEventVoModel JCParse:request.responseJSONObject[@"data"][@"list"]];
            
            if (currentFlag == 1) {
                
                for (UserEventVoModel *model in notificationArray) {
                    if (model.lastCommentTimes.integerValue > 0) {
                        [weakSelf.lastMessageArray addObject:model];
                    }
                }

                if (weakSelf.lastMessageArray.count) {
                    weakSelf.lastMessageFlagImageView.hidden = NO;
                    [weakSelf.publishedCollectionView reloadData];
                    [AppDelegateInstance.homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-haveNotice"] forState:UIControlStateNormal];
                } else {
                    weakSelf.lastMessageFlagImageView.hidden = YES;
                    [weakSelf.publishedCollectionView reloadData];
                    [AppDelegateInstance.homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-notice"] forState:UIControlStateNormal];
                    [weakSelf loadNoContentViewWithContentView:weakSelf.publishedCollectionView firstTitle:@"有留言会第一时间通知哦～" secondTitle:@""];
                }
                
                [weakSelf.publishedCollectionView.mj_footer endRefreshing];
                
                if (totalCount.integerValue == weakSelf.lastMessageArray.count) {
                    [weakSelf.publishedCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            if (currentFlag == 2) {
                [weakSelf.historyArray addObjectsFromArray:notificationArray];
                
                if (weakSelf.historyArray.count) {
                    [weakSelf.markCollectionView reloadData];
                } else {
                    [weakSelf.markCollectionView reloadData];
                    [weakSelf loadNoContentViewWithContentView:weakSelf.markCollectionView firstTitle:@"发布优质内容 一定会有留言哦！" secondTitle:@""];
                }
                
                [weakSelf.markCollectionView.mj_footer endRefreshing];
                
                if (totalCount.integerValue == weakSelf.historyArray.count) {
                    [weakSelf.markCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (currentFlag == 1) {
            [weakSelf.publishedCollectionView.mj_footer endRefreshing];
        }
        if (currentFlag == 2) {
            [weakSelf.markCollectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)requestOtherEventNoticeListWithType:(NSInteger)currentFlag ownFlag:(NSInteger)ownFloag offset:(NSInteger)offset {
    EventNoticeListApi *notification = [[EventNoticeListApi alloc] initWithOtherUserID:GlobalData.userModel.userID
                                                                                 limit:limit
                                                                                offset:offset
                                                                           currentFlag:currentFlag
                                                                               ownFlag:ownFloag];
    WEAKSELF
    [notification startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            NSString *totalCount = request.responseJSONObject[@"data"][@"count"];
            
//            NSArray *notificationArray = [RecommendModel JCParse:request.responseJSONObject[@"data"][@"list"]];
            
            NSArray *notificationArray = [UserEventVoModel JCParse:request.responseJSONObject[@"data"][@"list"]];
            
            if (currentFlag == 1) {
                [weakSelf.otherPeopleNewsArray addObjectsFromArray:notificationArray];
                
                if (weakSelf.otherPeopleNewsArray.count) {
                    weakSelf.otherPeopleNewsFlagImageView.hidden = NO;
                    [weakSelf.otherPeopleNewsCollectionView reloadData];
                    [AppDelegateInstance.homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-haveNotice"] forState:UIControlStateNormal];
                } else {
                    weakSelf.otherPeopleNewsFlagImageView.hidden = YES;
                    [weakSelf.otherPeopleNewsCollectionView reloadData];
                    [AppDelegateInstance.homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-notice"] forState:UIControlStateNormal];
                    [weakSelf loadNoContentViewWithContentView:weakSelf.otherPeopleNewsCollectionView firstTitle:@"有新动态会第一时间通知哦～" secondTitle:@""];
                }
                
                [weakSelf.otherPeopleNewsCollectionView.mj_footer endRefreshing];
                
                if (totalCount.integerValue == weakSelf.otherPeopleNewsArray.count) {
                    [weakSelf.otherPeopleNewsCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            if (currentFlag == 2) {
                [weakSelf.historyNewsArray addObjectsFromArray:notificationArray];
                
                if (weakSelf.historyNewsArray.count) {
                    [weakSelf.historyNewsCollectionView reloadData];
                } else {
                    [weakSelf.historyNewsCollectionView reloadData];
                    [weakSelf loadNoContentViewWithContentView:weakSelf.historyNewsCollectionView firstTitle:@"给别人的卡片留言一定会收到回复哦～" secondTitle:@""];
                }
                
                [weakSelf.historyNewsCollectionView.mj_footer endRefreshing];
                
                if (totalCount.integerValue == weakSelf.historyNewsArray.count) {
                    [weakSelf.historyNewsCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (currentFlag == 1) {
            [weakSelf.otherPeopleNewsCollectionView.mj_footer endRefreshing];
        }
        if (currentFlag == 2) {
            [weakSelf.historyNewsCollectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - NSNotification Methods
- (void)notificationsRefresh:(NSNotification *)notification {
    
    _lastMessagePage = 0;
//    _historyPage = 0;
    _otherPeopleNewsPage = 0;
    _historyNewsPage = 0;
    
    [_lastMessageArray removeAllObjects];
//    [_historyArray removeAllObjects];
    [_otherPeopleNewsArray removeAllObjects];
    [_historyNewsArray removeAllObjects];
    
    [self requestMyEventNoticeListWithType:1 ownFlag:1 offset:0];
//    [self requestMyEventNoticeListWithType:2 ownFlag:1 offset:0];
    [self requestOtherEventNoticeListWithType:1 ownFlag:2 offset:0];
    [self requestOtherEventNoticeListWithType:2 ownFlag:2 offset:0];
}

#pragma mark - collectionView About
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == _publishedCollectionView) {
        return _lastMessageArray.count;
    }
    else if (collectionView == _markCollectionView) {
        return _historyArray.count;
    }
    else if (collectionView == _otherPeopleNewsCollectionView) {
        return _otherPeopleNewsArray.count;
    }
    
    return _historyNewsArray.count;
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"notificaitonCell" forIndexPath:indexPath];
    
//    RecommendModel *recommendModel;
    UserEventVoModel *userEventVoModel;
    
    if (collectionView == _publishedCollectionView) {
        
        userEventVoModel = [_lastMessageArray objectAtIndex:indexPath.row];
        cell.commendTimeLabel.text = userEventVoModel.lastCommentTimes;
    }
    else if (collectionView == _markCollectionView) {
        
        userEventVoModel = [_historyArray objectAtIndex:indexPath.row];
    }
    else if (collectionView == _otherPeopleNewsCollectionView) {
        
        userEventVoModel = [_otherPeopleNewsArray objectAtIndex:indexPath.row];
        cell.commendTimeLabel.text = userEventVoModel.lastNoticeTimes;
    }
    else if (collectionView == _historyNewsCollectionView) {
        
        userEventVoModel = [_historyNewsArray objectAtIndex:indexPath.row];
    }
    
    cell.layer.cornerRadius = 3.0;
    
    cell.contentLabel.text = nil;
    cell.notificationCloseImageView.image = nil;
    cell.photoImageView.image = nil;
    cell.voteImageView.image = nil;
    
    if ([userEventVoModel.pushFlag isEqualToString:@"-1"]) {
        cell.notificationCloseImageView.image = [UIImage imageNamed:@"notificatoin-close"];
    }
    
    if ([userEventVoModel.eventType isEqualToString:TextEvent]) {
        cell.contentLabel.text = userEventVoModel.textModel.content;
    }
    
    if ([userEventVoModel.eventType isEqualToString:VoteEvent]) {
        cell.voteImageView.image = [UIImage imageNamed:@"myCenter-voteType"];
        cell.contentLabel.text = userEventVoModel.voteModel.title;
    }
    
    if ([userEventVoModel.eventType isEqualToString:PictureEvent]) {
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:userEventVoModel.spic]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    RecommendModel *recommendModel;
    UserEventVoModel *userEventVoModel;
    
    if (collectionView == _publishedCollectionView) {
        userEventVoModel = [_lastMessageArray objectAtIndex:indexPath.row];
        
        WEAKSELF
        GCD_AFTER(1.0, ^{
            [weakSelf.lastMessageArray removeObjectAtIndex:indexPath.row];
            [collectionView reloadData];
            
            if (weakSelf.lastMessageArray.count == 0) {
                [AppDelegateInstance.homeViewController.notificationButton setImage:[UIImage imageNamed:@"home-notice"] forState:UIControlStateNormal];
                [weakSelf loadNoContentViewWithContentView:weakSelf.publishedCollectionView firstTitle:@"有留言会第一时间通知哦～" secondTitle:@""];
            }
        });
        
        [_historyArray insertObject:userEventVoModel atIndex:0];
        [_markCollectionView reloadData];
        
        if (_historyArray.count > 0) {
            for (UIView *view in self.markCollectionView.subviews) {
                if ([view isKindOfClass:[NoDataView class]]) {
                    view.hidden = YES;
                }
            }
        }
    }
    else if (collectionView == _markCollectionView) {
        userEventVoModel = [_historyArray objectAtIndex:indexPath.row];
    }
    else if (collectionView == _otherPeopleNewsCollectionView) {
        userEventVoModel = [_otherPeopleNewsArray objectAtIndex:indexPath.row];
    }
    else if (collectionView == _historyNewsCollectionView) {
        userEventVoModel = [_historyNewsArray objectAtIndex:indexPath.row];
    }

    CardDetailViewController *cardDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cardDetailID"];
    WEAKSELF
    cardDetailViewController.removeThisCardBlock = ^{
        [weakSelf.historyArray removeObjectAtIndex:indexPath.row];
        [weakSelf.markCollectionView reloadData];
    };
    
    RecommendModel *recommendModel = [[RecommendModel alloc] init];
    recommendModel.uid = userEventVoModel.uid;
    recommendModel.eid = userEventVoModel.eid;
    
    cardDetailViewController.recommendModel = recommendModel;
    cardDetailViewController.isfromNewNotice = YES;
    
    [self.navigationController pushViewController:cardDetailViewController animated:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (scrollView == _publishedCollectionView || scrollView == _markCollectionView || scrollView == _otherPeopleNewsCollectionView || scrollView == _historyNewsCollectionView) {
        if (scrollView.contentSize.height > scrollView.frame.size.height) {
            scrollView.mj_footer.hidden = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _notificationScrollView) {
        CGRect rect = _slideImageView.frame;
        rect.origin.x = _currentButton.centerX - rect.size.width / 2 + scrollView.contentOffset.x / 4;
        _slideImageView.frame = rect;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _notificationScrollView) {
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        [self changeSelectedButtonColorWithIndex:index];
    }
}

- (void)changeSelectedButtonColorWithIndex:(NSInteger)index {
    [self setCurrentButton:index == 0 ? YES : NO
             historyButton:index == 1 ? YES : NO
     otherPeopleNewsButton:index == 2 ? YES : NO
         historyNewsButton:index == 3 ? YES : NO];
}

- (void)setCurrentButton:(BOOL)isCurrent historyButton:(BOOL)isHistory otherPeopleNewsButton:(BOOL)isOtherPeopleNews historyNewsButton:(BOOL)isHistoryNews {
    _currentButton.selected = isCurrent;
    _historyButton.selected = isHistory;
    _otherPeopleNewsButton.selected = isOtherPeopleNews;
    _historyNewsButton.selected = isHistoryNews;
}

- (void)loadNoContentViewWithContentView:(UICollectionView *)contentView firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle {
    
    NoDataView *noDataView = [NoDataView awakeWithNib];
    noDataView.center = CGPointMake(CGRectGetWidth(contentView.frame)/2, CGRectGetHeight(noDataView.frame)/2 + 45);
    noDataView.imageView.image = [UIImage imageNamed:@"home-haveNoNotificaiton"];
    noDataView.firstLabel.text = firstTitle;
    noDataView.secondLabel.text = @"";
    [contentView addSubview:noDataView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if ([[segue destinationViewController] isKindOfClass:[CardDetailViewController class]]) {
//        CardDetailViewController *cardDetailViewController = [segue destinationViewController];
//        cardDetailViewController.recommendModel = _currentRecommendModel;
//        cardDetailViewController.isFromNewComment = YES;
//    }
}

#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if ([toVC isKindOfClass:[HomeViewController class]]) {
        // 去掉导航分割线
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    
    return nil;
}

@end
