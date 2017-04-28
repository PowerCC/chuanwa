//
//  OtherCenterViewController.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/31.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "OtherCenterViewController.h"

#import "CardDetailViewController.h"
#import "BigHeadPhotoViewController.h"
#import "ChatViewController.h"
#import "PublishCollectionViewCell.h"
#import "IBNavigationBar.h"
#import "NoPublishView.h"

#import "EventListApi.h"
#import "UserInfoApi.h"

#import "RecommendModel.h"

static NSInteger const limit = 10;

@interface OtherCenterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendAroundLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headBlueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet UIButton *currentButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) IBOutlet UIButton *statisticsButton;
@property (weak, nonatomic) IBOutlet UIImageView *slideImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *centerScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *publishScrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *currentPublishCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *historyPublishCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *currentCollectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *historyCollectionViewFlowLayout;

@property (weak, nonatomic) IBOutlet UIView *StatisticsView;

@property (weak, nonatomic) IBOutlet UILabel *totalCardCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoCardCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *textCardCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCardCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itCenterViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voteConstraint;

@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger historyPage;

@property (strong, nonatomic) NSMutableArray *currentPublishArray;
@property (strong, nonatomic) NSMutableArray *historyPublishArray;

@property (assign, nonatomic) BOOL isAnimateJust;

@property (strong, nonatomic) IBNavigationBar *navigationBar;

@property (strong, nonatomic) UIColor *currentNavBarColor;

@property (strong, nonatomic) UserModel *userModel;

@end

@implementation OtherCenterViewController

- (void)dealloc {
    
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    _itCenterViewHeightConstraint.constant = SCREEN_HEIGHT - 64 + 249;
    _viewWidthConstraint.constant = SCREEN_WIDTH * 3;
}

- (void)viewDidLoad {
    
//    self.navigationController.navigationBar.translucent = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _navigationBar = (IBNavigationBar *)self.navigationController.navigationBar;
    [_navigationBar setNavigationBarWithColor:[UIColor clearColor]];
    [_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: kCOLOR(68, 68, 68, 0.0),
                                             NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
    // 去掉导航分割线
    [_navigationBar setShadowImage:nil];
    [_navigationBar setShadowImage:[UIImage new]];
    
    _currentPage = 0;
    _historyPage = 0;
    
    _currentButton.selected = YES;
    
    _currentPublishArray = [[NSMutableArray alloc] initWithCapacity:20];
    _historyPublishArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    CGSize publishCellSize;
    if (iPhone4_4s || iPhone5_5s) {
        publishCellSize = CGSizeMake(175 * (320.0 / 375) - 2, 223 * (320.0 / 375) - 1);
    } else if (iPhone6_6s) {
        publishCellSize = CGSizeMake(175, 223);
    } else if (iPhone6_6sPlus) {
        publishCellSize = CGSizeMake(175 * (414.0 / 375) + 1, 223 * (414.0 / 375));
    }
    
    _currentCollectionViewFlowLayout.itemSize = publishCellSize;
    _historyCollectionViewFlowLayout.itemSize = publishCellSize;
    
    _currentPublishCollectionView.scrollEnabled = NO;
    _historyPublishCollectionView.scrollEnabled = NO;
    
    UserInfoApi *userInfoApi = [[UserInfoApi alloc] initWithOtherUserID:_userID];
    
    WEAKSELF
    [userInfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            weakSelf.userModel = [UserModel JCParse:request.responseJSONObject[@"data"]];
            
            if (!weakSelf.navigationItem.title) {
                weakSelf.title = weakSelf.userModel.nickName;
            }
            
            weakSelf.nickNameLabel.text = weakSelf.userModel.nickName;
            weakSelf.locationLabel.text = [NSString stringWithFormat:@"常在地区：%@", weakSelf.userModel.cityCode];
            
            weakSelf.totalCardLabel.text = weakSelf.userModel.events;
            weakSelf.sendAroundLabel.text = weakSelf.userModel.sendAround;
            
            [weakSelf.headBlueImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.userModel.avatar]
                                  placeholderImage:nil];
            [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.userModel.avatar]
                              placeholderImage:[UIImage imageNamed:@"home-commentDefaultHead"]];
            
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
    
    [self requestMorePublishWithType:1 offset:0];
    [self requestMorePublishWithType:2 offset:0];
    
    [self addFooter];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.translucent = NO;
    self.navView.backgroundColor = [UIColor whiteColor];
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
                    [weakSelf loadNoContentViewWithContentView:self.currentPublishCollectionView firstTitle:@"还没有任何内容~" secondTitle:@""];
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
                    [weakSelf loadNoContentViewWithContentView:weakSelf.historyPublishCollectionView firstTitle:@"还没有任何内容~" secondTitle:@""];
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

#pragma mark - Actions
- (IBAction)headButtonAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyCenter" bundle:nil];
    BigHeadPhotoViewController *bigHeadPhotoViewController = [storyboard instantiateViewControllerWithIdentifier:@"bigHeadPhoto"];
    bigHeadPhotoViewController.headImage = _headImageView.image;
    bigHeadPhotoViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:bigHeadPhotoViewController animated:YES completion:nil];
}

- (IBAction)publishButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self changeSelectedButtonColorWithIndex:button.tag];
    
    [_publishScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * button.tag, 0) animated:YES];
}

- (IBAction)toChatButtonAction:(id)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IM" bundle:nil];
//    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"chat"];
    
    if (_userModel && _userModel.imUuid) {
//        ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationChatter:_userModel.imUuid conversationType:EMConversationTypeChat];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IM" bundle:nil];
        ChatViewController *chatVc = [storyboard instantiateViewControllerWithIdentifier:@"chat"];
        chatVc.conversationUserModel = _userModel;
        [self.navigationController pushViewController:chatVc animated:YES];
    }

}

#pragma mark - collectionView About
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == _currentPublishCollectionView)
        return _currentPublishArray.count;
    
    return _historyPublishArray.count;
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PublishCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"publishCell" forIndexPath:indexPath];
    
    RecommendModel *recommendModel;
    
    if (collectionView == _currentPublishCollectionView) {
        recommendModel = [_currentPublishArray objectAtIndex:indexPath.row];
    }
    
    if (collectionView == _historyPublishCollectionView) {
        recommendModel = [_historyPublishArray objectAtIndex:indexPath.row];
    }
    
    cell.layer.cornerRadius = 2.0;
    
    cell.textLabel.text = nil;
    cell.photoImageView.image = nil;
    cell.voteImageView.image = nil;
    
    cell.messageCountLabel.text = recommendModel.commentTimes;
    cell.peopleCountLabel.text = recommendModel.spreadTimes;
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
    
    if (!_isAnimateJust) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        CardDetailViewController *cardDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"cardDetailID"];
        cardDetailViewController.recommendModel = recommendModel;
        
        [self.navigationController pushViewController:cardDetailViewController animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (scrollView == _currentPublishCollectionView || scrollView == _historyPublishCollectionView) {
        if (scrollView.contentSize.height > scrollView.frame.size.height) {
            scrollView.mj_footer.hidden = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _centerScrollView) {
        if (scrollView.contentOffset.y > 184) {
            _currentPublishCollectionView.scrollEnabled = YES;
            _historyPublishCollectionView.scrollEnabled = YES;
        } else {
            _currentPublishCollectionView.scrollEnabled = NO;
            _historyPublishCollectionView.scrollEnabled = NO;
        }
        
        // 设置颜色
        [_navigationBar setNavigationBarWithColor:kCOLOR(255, 255, 255, scrollView.contentOffset.y/188)];
        
        // 文字
        [_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kCOLOR(68, 68, 68, scrollView.contentOffset.y/184),
                                                 NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
        // 设置导航分割线
        [_navigationBar setShadowImage:[UIImage imageWithColor:kCOLOR(222, 222, 222, scrollView.contentOffset.y/184)]];
    }
    
    if (scrollView == _publishScrollView) {
        CGRect rect = _slideImageView.frame;
        rect.origin.x = _currentButton.centerX - rect.size.width/2 + scrollView.contentOffset.x/3;
        _slideImageView.frame = rect;
    }
    
    if (scrollView == _currentPublishCollectionView || scrollView == _historyPublishCollectionView) {
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointZero;
            
            scrollView.scrollEnabled = NO;
            [self scrollViewToTop];
        }
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
           statisticButton:index == 2 ? YES : NO];
}

- (void)setCurrentButton:(BOOL)isCurrent historyButton:(BOOL)isHistory statisticButton:(BOOL)isStatistic {
    _currentButton.selected = isCurrent;
    _historyButton.selected = isHistory;
    _statisticsButton.selected = isStatistic;
}

- (void)scrollViewToTop {
    [UIView animateWithDuration:0.3
                     animations:^{
                         [_centerScrollView setContentOffset:CGPointZero];
                     }];
    
    _isAnimateJust = YES;
    WEAKSELF
    GCD_AFTER(1.0, ^{
        weakSelf.isAnimateJust = NO;
    });
}

- (void)loadNoContentViewWithContentView:(UICollectionView *)contentView firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle {
    NoPublishView *noPublishView = [NoPublishView awakeWithNib];
    noPublishView.center = CGPointMake(CGRectGetWidth(contentView.frame)/2, CGRectGetHeight(noPublishView.frame)/2 + 75);
    noPublishView.firstLabel.text = firstTitle;
    noPublishView.secondLabel.text = secondTitle;
    noPublishView.publishContentButton.hidden = YES;
    [contentView addSubview:noPublishView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
