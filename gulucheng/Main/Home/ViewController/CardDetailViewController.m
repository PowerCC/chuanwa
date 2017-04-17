//
//  CardDetailViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/16.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CardDetailViewController.h"
#import "CardDataViewController.h"
#import "HomeViewController.h"
#import "ReportViewController.h"
#import "OtherCenterViewController.h"
#import "NotificationViewController.h"

#import "MagicMoveInverseTransition.h"
#import "PopAnimationTransition.h"
#import "TextCommendView.h"
#import "VoteCommendView.h"
#import "PhotoCommendView.h"
#import "DetailPhotoCommendView.h"
#import "CommendButtomView.h"
#import "CommentTableViewCell.h"
#import "NoPublishView.h"

#import "CommentListApi.h"
#import "SpreadListApi.h"
#import "CommentApi.h"
#import "ReplyCommentApi.h"
#import "DelEventApi.h"
#import "DeleteCommentApi.h"
#import "EventApi.h"

#import "FavoriteAddApi.h"
#import "FavoriteCancelApi.h"
#import "FavoriteListApi.h"
#import "FavoriteCheckApi.h"
#import "FavoriteUsersApi.h"

#import "TurnOnPushApi.h"
#import "TurnOffPushApi.h"

#import "CommentModel.h"
#import "PhotoModel.h"
#import "FavoriteUserModel.h"

#import "IBNavigationBar.h"
#import "SRActionSheet.h"
#import "Tool.h"

#import "ESPictureBrowser.h"
#import "UITableViewCell+WHC_AutoHeightForCell.h"

// 动画时间
#define kAnimationDuration 0.15
// view高度
#define kViewHeight 54

static NSString *const CommentCell = @"commentCell";
static NSString *const ReplyCommentCell = @"replyCommentCell";
static NSInteger const limit = 10;

@interface CardDetailViewController () <UINavigationControllerDelegate, SRActionSheetDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, ESPictureBrowserDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *tableContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardDetailViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliverTableViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectTableViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *slideImageView;

@property (weak, nonatomic) IBOutlet UIButton *topCollectButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *deliverButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) IBOutlet UIButton *commentTableViewTopButton;
@property (weak, nonatomic) IBOutlet UIButton *deliverTableViewTopButton;
@property (weak, nonatomic) IBOutlet UIButton *collectTableViewTopButton;

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UITableView *deliverTableView;
@property (weak, nonatomic) IBOutlet UITableView *collectTableView;

//@property (strong, nonatomic) CommentTableViewCell *reusableCell;

@property (assign, nonatomic) NSInteger commentPage;
@property (assign, nonatomic) NSInteger deliverPage;
@property (assign, nonatomic) NSInteger collectPage;

@property (strong, nonatomic) NSMutableArray *commentArray;
@property (strong, nonatomic) NSMutableArray *replyCommentArray;

@property (strong, nonatomic) NSMutableArray *deliverArray;
@property (strong, nonatomic) NSMutableArray *collectArray;

@property (copy, nonatomic) NSString *otherCenterID;
@property (copy, nonatomic) NSString *totalCommentCount;

@property (strong, nonatomic) UIImage *currentImage;
@property (strong, nonatomic) UIView *backView;

@property (weak, nonatomic) NSIndexPath *deleteIndexPath;
@property (weak, nonatomic) NSIndexPath *deleteRelpyIndexPath;

@property (assign, nonatomic) BOOL isSaveCard;
@property (assign, nonatomic) BOOL enableCardNotification;
@property (assign, nonatomic) BOOL disabledEditCardNotification;
@property (assign, nonatomic) BOOL isCommentReply;
@property (assign, nonatomic) BOOL fromCollectAction;

@property (assign, nonatomic) CGFloat commentCellHeight;

@property (strong, nonatomic) CommentReplyModel *replyCommentModel;

@property (strong, nonatomic) DetailPhotoCommendView *detailPhotoCommendView;
//@property (nonatomic, strong) IBNavigationBar *navigationBar;

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransition;

@property (assign, nonatomic) CGRect contentViewFrame;
@property (assign, nonatomic) CGRect photoViewFrame;
@property (assign, nonatomic) CGRect currentSlideImageViewFrame;

@end

@implementation CardDetailViewController

// 移除监听
- (void)dealloc {
    self.commentTableView.dataSource = nil;
    self.commentTableView.delegate = nil;
    
    self.deliverTableView.dataSource = nil;
    self.deliverTableView.delegate = nil;
    
    self.collectTableView.dataSource = nil;
    self.collectTableView.delegate = nil;
    
    self.detailScrollView.delegate = nil;
    self.tableScrollView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:N_NOTIFICATIONS_REFRESH object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    panGesture.delegate = self; // 设置手势代理，拦截手势触发
//    [self.view addGestureRecognizer:panGesture];
//    
//    // 禁止系统自带的滑动手势
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: kCOLOR(68, 68, 68, 1.0),
                                             NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
    
    _viewWidthConstraint.constant = SCREEN_WIDTH * 3;
    _cardDetailViewHeightConstraint.constant = SCREEN_HEIGHT - 64;
    
    _commentTableViewWidthConstraint.constant = SCREEN_WIDTH;
    _deliverTableViewWidthConstraint.constant = SCREEN_WIDTH;
    _collectTableViewWidthConstraint.constant = SCREEN_WIDTH;
    
    self.navView.backgroundColor = kCOLOR(255, 255, 255, 1.0);
    self.detailScrollView.scrollsToTop = NO;
    
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    
    self.deliverTableView.dataSource = self;
    self.deliverTableView.delegate = self;
    
    self.collectTableView.dataSource = self;
    self.collectTableView.delegate = self;
    
    self.commentTableView.scrollEnabled = NO;
    self.deliverTableView.scrollEnabled = NO;
    self.collectTableView.scrollEnabled = NO;
    
    self.commentButton.selected = YES;
    
    self.commentPage = 0;
    self.deliverPage = 0;
    self.collectPage = 0;
    
    self.commentArray = [[NSMutableArray alloc] initWithCapacity:20];
    self.replyCommentArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.deliverArray = [[NSMutableArray alloc] initWithCapacity:20];
    self.collectArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.viewHeightConstraint.constant = SCREEN_HEIGHT + 238;
    
//    [_tableContentView removeFromSuperview];
//    [_tableScrollView addSubview:_tableContentView];
//    _tableScrollView.contentSize = CGSizeMake(_viewWidthConstraint.constant, _viewHeightConstraint.constant);

    self.tableScrollView.scrollEnabled = NO;
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.0;
    [self.view addSubview:_backView];
    
    //添加这两行代码来自适应label的高度
    self.commentTableView.estimatedRowHeight = 72;
    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeKeyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(backHandle:)];
    [self.view addGestureRecognizer:panGesture];
    
    [self setExtraCellLineHidden:_commentTableView];
    [self setExtraCellLineHidden:_deliverTableView];
    [self setExtraCellLineHidden:_collectTableView];
    
    self.contentViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, 238);
    self.photoViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 20);

    // 创建底部展示传播次数 定位view
    if (!_commendButtomView) {
        _commendButtomView = [CommendButtomView awakeWithNib];
    }
    
    [self addFooter];
    
    [self requestFavoriteUsersWithOffset:0];
    [self requestSpreadWithOffset:0];
    [self requestCommentWithOffset:0];
//    [self requestEvent];
    
    
    WEAKSELF
    _replyInputView = [ReplyInputView awakeWithNib];
    _replyInputView.frame = CGRectMake(0, SCREEN_HEIGHT - 54, SCREEN_WIDTH, 54);
    [self.view addSubview:_replyInputView];
    
    _replyInputView.ContentSizeBlock = ^(CGSize contentSize) {
        [weakSelf updateHeight:contentSize];
    };
    
    _replyInputView.sendButtonBlock = ^{
        [weakSelf updateHeight:CGSizeMake(SCREEN_WIDTH, 34)];
        
        if (weakSelf.replyCommentModel) {
            [weakSelf replyCommentRequestWithUid:weakSelf.replyCommentModel.uid fromCommentId:weakSelf.replyCommentModel.fromCommentId comment:weakSelf.replyInputView.textView.text];
        }
        else {
            [weakSelf commentRequestWithComment:weakSelf.replyInputView.textView.text];
        }
        
        [weakSelf closeKeyboard];
    };
    
    BOOL isMyselfCard = [_recommendModel.uid isEqualToString:GlobalData.userModel.userID];
    if (!isMyselfCard) {
        [self requestFavoriteCheck];
    }
    else {
        _topCollectButton.hidden = YES;
    }
    
//    self.reusableCell = [_commentTableView dequeueReusableCellWithIdentifier:CommentCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置导航分割线
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"public-horizonLine"]];
    
    // 添加通知监听键盘的弹出与隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1) {
        return NO;
    }
    
    return YES;
}

#pragma mark - loadViewsWithStartY
- (void)loadViewsWithStartY:(float)y commendModel:(RecommendModel *)commendModel {
    // 底部内容
    [_commendButtomView setFrame:CGRectMake(0,
                                            y,
                                            SCREEN_WIDTH,
                                            _recommendModel.eventPicVos.count > 1 ? commendButtomViewPageHeight : commendButtomViewHeight)
                    commendModel:commendModel];
    
    [_contentView addSubview:_commendButtomView];
    
    // 为了让很长的图片响应滑动事件
    if ([_recommendModel.eventType isEqualToString:PictureEvent]) {
        _contentViewHeightConstraint.constant = y;
    }
    _viewHeightConstraint.constant = (SCREEN_HEIGHT - 64) + y + (_recommendModel.eventPicVos.count > 1 ? commendButtomViewPageHeight : commendButtomViewHeight);
}

#pragma mark - loadCurrentImageView 加载当前图片视图
- (void)loadCurrentImageView {
    
    _isSaveCard = NO;
    if ([_recommendModel.eventType isEqualToString:PictureEvent] && _recommendModel.eventPicVos && _recommendModel.eventPicVos.count) {
        PhotoModel *photoModel = [_recommendModel.eventPicVos objectAtIndex:_commendButtomView.pageControl.currentPage];
        self.currentImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:photoModel.picPath];
        if (self.currentImage) {
            _isSaveCard = YES;
        }
    }
}

#pragma mark - addFooter 添加页脚
- (void)addFooter {
    WEAKSELF
    
//    if (_commentTableView.mj_footer.state == MJRefreshStateIdle) {
        _commentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestCommentWithOffset:limit * ++ weakSelf.commentPage];
        }];
        _commentTableView.mj_footer.hidden = YES;
//    }
    
//    if (_deliverTableView.mj_footer.state == MJRefreshStateIdle) {
        _deliverTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestSpreadWithOffset:limit * ++ weakSelf.deliverPage];
        }];
        _deliverTableView.mj_footer.hidden = YES;
//    }
    
//    if (_collectTableView.mj_footer.state == MJRefreshStateIdle) {
        _collectTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestFavoriteUsersWithOffset:limit * ++ weakSelf.collectPage];
        }];
        _collectTableView.mj_footer.hidden = YES;
//    }
}

#pragma mark - loadContent 加载内容
- (void)loadContent {
    
    WEAKSELF
    
    // 文字
    if ([_recommendModel.eventType isEqualToString:TextEvent]) {
        self.textCommendView = [[TextCommendView alloc] initWithFrame:_contentViewFrame];
        
        self.textCommendView.textLabel.numberOfLines = 0;
        if (iPhone4_4s) {
            if (self.recommendModel.textModel.content.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
            }
        }
        else if (iPhone5_5s) {
            if (self.recommendModel.textModel.content.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
            }
        }
        else if (iPhone6_6s) {
            if (self.recommendModel.textModel.content.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
            }
        }
        else if (iPhone6_6sPlus) {
            if (self.recommendModel.textModel.content.length > 120) {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:24];
            }
            else {
                self.textCommendView.textLabel.font = [UIFont systemFontOfSize:31];
            }
        }

        self.textCommendView.textLabelHeightBlock = ^(float height) {
//            if (height <= 238) {
//                weakSelf.textCommendView.textTopConstraint.constant = (238 - height)/2;
//                [weakSelf loadViewsWithStartY:238 commendModel:weakSelf.recommendModel];
//            } else {
//                weakSelf.textCommendView.textTopConstraint.constant = 0;
//                [weakSelf loadViewsWithStartY:height commendModel:weakSelf.recommendModel];
//            }
            [weakSelf loadViewsWithStartY:height commendModel:weakSelf.recommendModel];
            
            if (weakSelf.totalCommentCount.integerValue == 0 && weakSelf.recommendModel.spreadTimes.integerValue > 0) {
                [weakSelf changeSelectedButtonColorWithIndex:1];
                [weakSelf.tableScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
            }
            else {
                [weakSelf changeSelectedButtonColorWithIndex:0];
                [weakSelf.tableScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        };
        
        [self.textCommendView loadTextCommendModel:_recommendModel];
        [_contentView addSubview:self.textCommendView];
        
        //[self loadViewsWithStartY:238 commendModel:self.recommendModel];
        
        self.textCommendView.textViewTapBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        self.textCommendView.showCenterBlock = ^{
            weakSelf.otherCenterID = weakSelf.recommendModel.uid;
            [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
        };
    }
    
    // 投票
    if ([_recommendModel.eventType isEqualToString:VoteEvent]) {
        
        _voteCommendView = [[VoteCommendView alloc] initWithFrame:_contentViewFrame];
        _voteCommendView.backgroundColor = [UIColor clearColor];
        _voteCommendView.voteViewHeightBlock = ^(float height) {
            [weakSelf loadViewsWithStartY:height commendModel:weakSelf.recommendModel];
        };
        [_voteCommendView loadVoteCommendModel:_recommendModel isHomeIn:NO];
        [_contentView addSubview:_voteCommendView];
        
        _voteCommendView.showCenterBlock = ^{
            weakSelf.otherCenterID = weakSelf.recommendModel.uid;
            [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
        };
        
        if (weakSelf.totalCommentCount.integerValue == 0 && weakSelf.recommendModel.spreadTimes.integerValue > 0) {
            [weakSelf changeSelectedButtonColorWithIndex:1];
            [weakSelf.tableScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        }
        else {
            [weakSelf changeSelectedButtonColorWithIndex:0];
            [weakSelf.tableScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    
    // 图片
    if ([_recommendModel.eventType isEqualToString:PictureEvent]) {
        
        _detailPhotoCommendView = [[DetailPhotoCommendView alloc] initWithFrame:_photoViewFrame];
        [_contentView addSubview:_detailPhotoCommendView];
        
        _detailPhotoCommendView.currentPhotoPage = _currentPhotoPage.integerValue;
        [_detailPhotoCommendView reloadCollectionViewWithPhotoCommendModel:_recommendModel];
        
        _detailPhotoCommendView.photoViewHeightBlock = ^(float height) {
            [weakSelf loadViewsWithStartY:height commendModel:weakSelf.recommendModel];
            
            if (weakSelf.totalCommentCount.integerValue == 0 && weakSelf.recommendModel.spreadTimes.integerValue > 0) {
                [weakSelf changeSelectedButtonColorWithIndex:1];
                [weakSelf.tableScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
            }
            else {
                [weakSelf changeSelectedButtonColorWithIndex:0];
                [weakSelf.tableScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        };
        
        _detailPhotoCommendView.currentPageBlock = ^(NSInteger currentPage) {
            GCD_AFTER(0.3, ^{
                weakSelf.commendButtomView.pageControl.currentPage = currentPage;
            });
        };
        
        _detailPhotoCommendView.showCenterBlock = ^{
            weakSelf.otherCenterID = weakSelf.recommendModel.uid;
            [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
        };
        
        _detailPhotoCommendView.photoSelectedBlock = ^(NSInteger currentIndex) {
            ESPictureBrowser *pictureBrowser = [[ESPictureBrowser alloc] init];
            pictureBrowser.delegate = weakSelf;
            [pictureBrowser showFromView:weakSelf.view picturesCount:weakSelf.recommendModel.eventPicVos.count currentPictureIndex:currentIndex];
        };
    }
}

#pragma mark - requestEvent 详情请求
- (void)requestEvent {
    WEAKSELF
    
    BOOL load = YES;
    if (_recommendModel.nickName && _recommendModel.gender) {
        [self loadContent];
        load = NO;
    }
    
    EventApi *eventApi = [[EventApi alloc] initWithEid:_recommendModel.eid];
    [eventApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            weakSelf.recommendModel = [RecommendModel JCParse:request.responseJSONObject[@"data"]];
            
            if (load) {
                [weakSelf loadContent];
            }
            
            weakSelf.commendButtomView.talkCountLabel.text = [NSString stringWithFormat:@"%@", weakSelf.totalCommentCount];
            [weakSelf.commentButton setTitle:[NSString stringWithFormat:@"留言 %@", weakSelf.totalCommentCount] forState:UIControlStateNormal];
            
            weakSelf.commendButtomView.peopleCountLabel.text = [NSString stringWithFormat:@"%@", weakSelf.recommendModel.spreadTimes];
            [weakSelf.deliverButton setTitle:[NSString stringWithFormat:@"传递 %@", weakSelf.recommendModel.spreadTimes] forState:UIControlStateNormal];
            
//            [weakSelf.collectButton setTitle:[NSString stringWithFormat:@"收藏 %@", weakSelf.favoriteCount] forState:UIControlStateNormal];
            
//            GCD_AFTER(0.5, ^{
//                // 评论没内容，传递有内容 跳转到传递页面
//                if (weakSelf.totalCommentCount.integerValue == 0 && weakSelf.recommendModel.spreadTimes.integerValue > 0) {
//                    [weakSelf changeSelectedButtonColorWithIndex:1];
//                    [weakSelf.tableScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
//                }
//                else {
//                    [weakSelf changeSelectedButtonColorWithIndex:0];
//                    [weakSelf.tableScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//                }
//            });
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        GCD_AFTER(0.5, ^{
            [weakSelf changeSelectedButtonColorWithIndex:0];
            [weakSelf.tableScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        });
    }];
}

#pragma mark - requestCommentWithOffset 留言请求
- (void)requestCommentWithOffset:(NSInteger)offset {

    WEAKSELF
    CommentListApi *commentListApi = [[CommentListApi alloc] initWithEid:_recommendModel.eid
                                                                  offset:offset
                                                          fromNewNotice:_isfromNewNotice];
    [commentListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {

            NSArray *tempCommentArray = [CommentModel JCParse:request.responseJSONObject[@"data"][@"commentList"]];
            
            weakSelf.totalCommentCount = request.responseJSONObject[@"data"][@"commentCount"];
            NSString *noReplyCount = request.responseJSONObject[@"data"][@"noReplyCount"];
//            weakSelf.commendButtomView.talkCountLabel.text = [NSString stringWithFormat:@"%@", totalCommentCount];
//            [weakSelf.commentButton setTitle:[NSString stringWithFormat:@"留言 %@", totalCommentCount] forState:UIControlStateNormal];
//            weakSelf.commentButton.titleLabel.text = [NSString stringWithFormat:@"留言 %@", noReplyCount];
//            [weakSelf.commentButton sizeToFit];
            
            [weakSelf.commentArray addObjectsFromArray:tempCommentArray];
            
            if (weakSelf.commentArray.count) {
                [weakSelf.commentTableView reloadData];
            } else {
                [weakSelf.commentTableView reloadData];
                [weakSelf loadNoContentViewWithContentView:weakSelf.commentTableView firstTitle:@"暂无留言，马上抢沙发~" secondTitle:@""];
            }
            
            [weakSelf.commentTableView.mj_footer endRefreshing];
            
            if (noReplyCount.integerValue == weakSelf.commentArray.count) {
                [weakSelf.commentTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [weakSelf requestEvent];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [weakSelf.commentTableView.mj_footer endRefreshing];
        [weakSelf requestEvent];
    }];
}

#pragma mark - requestSpreadWithOffset 传递请求
- (void)requestSpreadWithOffset:(NSInteger)offset {
    WEAKSELF
    SpreadListApi *spreadListApi = [[SpreadListApi alloc] initWithEid:_recommendModel.eid
                                                               offset:offset
                                                                limit:limit];
    [spreadListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            NSArray *tempDeliverArray = [CommentModel JCParse:request.responseJSONObject[@"data"][@"spreadList"]];
            
            NSString *totalSpreadCount = request.responseJSONObject[@"data"][@"spreadCount"];
//            weakSelf.commendButtomView.peopleCountLabel.text = [NSString stringWithFormat:@"%@", totalSpreadCount];
//            [weakSelf.deliverButton setTitle:[NSString stringWithFormat:@"传递 %@", totalSpreadCount] forState:UIControlStateNormal];

            [weakSelf.deliverArray addObjectsFromArray:tempDeliverArray];
            
            if (weakSelf.deliverArray.count) {
                [weakSelf.deliverTableView reloadData];
            } else {
                [weakSelf.deliverTableView reloadData];
                [weakSelf loadNoContentViewWithContentView:weakSelf.deliverTableView firstTitle:@"寂寞沙洲冷，求传递！" secondTitle:@""];
            }
            
            [weakSelf.deliverTableView.mj_footer endRefreshing];
            
            if (totalSpreadCount.integerValue == weakSelf.deliverArray.count) {
                [weakSelf.deliverTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [weakSelf.deliverTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - requestFavoriteCheck 检查卡片收藏和push状态
- (void)requestFavoriteCheck {
    WEAKSELF
    FavoriteCheckApi *favoriteCheckApi = [[FavoriteCheckApi alloc] initWithEid:_recommendModel.eid];
    [favoriteCheckApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            //  1: 当前状态是收藏
            // -1: 当前状态是未收藏
            NSString *favorite = request.responseJSONObject[@"data"][@"favorite"];
            if (favorite.integerValue == 1) {
                weakSelf.topCollectButton.selected = YES;
            }
            else if (favorite.integerValue == -1) {
                weakSelf.topCollectButton.selected = NO;
            }
            
            //  1: 当前状态是发push
            // -1: 当前状态是不发push
            // -2: 不允许修改push发送状态
            NSString *sendPush = request.responseJSONObject[@"data"][@"sendPush"];
            if (sendPush.integerValue == 1) {
                weakSelf.enableCardNotification = YES;
            }
            else if (sendPush.integerValue == -1) {
                weakSelf.enableCardNotification = NO;
            }
            else if (sendPush.integerValue == -2) {
                weakSelf.disabledEditCardNotification = YES;
            }
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

#pragma mark - requestFavoriteUsersWithOffset 卡片收藏用户请求
- (void)requestFavoriteUsersWithOffset:(NSInteger)offset {
    WEAKSELF
    FavoriteUsersApi *favoriteUsersApi = [[FavoriteUsersApi alloc] initWithEid:_recommendModel.eid
                                                                         limit:limit
                                                                        offset:offset];
    [favoriteUsersApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            NSArray *favoriteArray = [FavoriteUserModel JCParse:request.responseJSONObject[@"data"][@"favoriteList"]];
            
            NSString *favoriteCount = request.responseJSONObject[@"data"][@"favoriteCount"];
            
            [weakSelf changeSelectedButtonColorWithIndex:0];
            [weakSelf.tableScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            [weakSelf.collectButton setTitle:[NSString stringWithFormat:@"收藏 %@", favoriteCount] forState:UIControlStateNormal];
//            [weakSelf.tableScrollView layoutSubviews];
//            weakSelf.collectButton.titleLabel.text = [NSString stringWithFormat:@"收藏 %@", favoriteCount];
//            [weakSelf.collectButton setNeedsLayout];
//            [weakSelf.collectButton layoutIfNeeded];

            
            [weakSelf.collectArray addObjectsFromArray:favoriteArray];

            if (weakSelf.collectArray.count > 0) {
                UIView *view = [weakSelf.collectTableView viewWithTag:2016];
                if (view) {
                    [view removeFromSuperview];
                }
                
                [weakSelf.collectTableView reloadData];
            } else {
                [weakSelf.collectTableView reloadData];
                [weakSelf loadNoContentViewWithContentView:weakSelf.collectTableView firstTitle:@"如果喜欢，别客气，收藏吧！" secondTitle:@""];
            }

            [weakSelf.collectTableView.mj_footer endRefreshing];
            
            if (favoriteCount.integerValue == weakSelf.collectArray.count) {
                [weakSelf.collectTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (_fromCollectAction) {
                GCD_AFTER(0.5, ^{
                    [weakSelf changeSelectedButtonColorWithIndex:2];
                    [weakSelf.tableScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:YES];
                });
            }
            
//            [weakSelf requestEvent];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//                // 评论没内容，传递有内容 跳转到传递页面
//                if (weakSelf.recommendModel.commentTimes.integerValue == 0 && weakSelf.recommendModel.spreadTimes.integerValue > 0) {
//                    [weakSelf changeSelectedButtonColorWithIndex:1];
//                    [weakSelf.tableScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
//                }
//            });
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [weakSelf.collectTableView.mj_footer endRefreshing];
//        [weakSelf requestEvent];
    }];
}

#pragma mark - commentRequestWithComment 评论请求
- (void)commentRequestWithComment:(NSString *)comment {
    WEAKSELF
    CommentApi *commentApi = [[CommentApi alloc] initWithEid:_recommendModel.eid
                                                     comment:comment];
    [commentApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            CommentModel *commentModel = [CommentModel JCParse:request.responseJSONObject[@"data"]];
            [weakSelf.commentArray insertObject:commentModel atIndex:0];
            
            // 从列表中添加
//            [weakSelf.commentTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
//                                         withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.commentTableView reloadData];
            
            weakSelf.recommendModel.commentTimes = [NSString stringWithFormat:@"%td", weakSelf.commentArray.count];
            [weakSelf.commentButton setTitle:[NSString stringWithFormat:@"留言 %lu", (unsigned long)weakSelf.commentArray.count]
                                forState:UIControlStateNormal];
            weakSelf.commendButtomView.talkCountLabel.text = weakSelf.recommendModel.commentTimes;
            
            for (UIView *view in weakSelf.commentTableView.subviews) {
                if ([view isKindOfClass:[NoPublishView class]]) {
                    view.hidden = YES;
                }
            }
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - replyCommentRequestWithUid 回复某人的评论请求
- (void)replyCommentRequestWithUid:(NSString *)uid
                     fromCommentId:(NSString *)fromCommentId
                           comment:(NSString *)comment {
    WEAKSELF
    ReplyCommentApi *replyCommentApi = [[ReplyCommentApi alloc] initWithEid:_recommendModel.eid comment:comment replyToUid:uid fromCommentId:fromCommentId];
    [replyCommentApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            [weakSelf.commentArray removeAllObjects];
            [weakSelf requestCommentWithOffset:0];
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}


#pragma mark - turnOnOrTurnOffPushRequest 打开/关闭卡片Push请求
- (void)turnOnOrTurnOffPushRequest {
    WEAKSELF
    if (_enableCardNotification) {
        TurnOffPushApi *turnOffPushApi = [[TurnOffPushApi alloc] initWithEid:_recommendModel.eid];
        [MBProgressHUD showMessage:Loading toView:self.view];
        [turnOffPushApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
                [MBProgressHUD hideHUDForView:weakSelf.view];
                weakSelf.enableCardNotification = NO;
                [MBProgressHUD showSuccess:@"卡片通知已关闭" toView:weakSelf.view];
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showSuccess:@"关闭卡片通知发生错误" toView:weakSelf.view];
        }];
    }
    else {
        TurnOnPushApi *turnOnPushApi = [[TurnOnPushApi alloc] initWithEid:_recommendModel.eid];
        [MBProgressHUD showMessage:Loading toView:self.view];
        [turnOnPushApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
                [MBProgressHUD hideHUDForView:weakSelf.view];
                weakSelf.enableCardNotification = YES;
                [MBProgressHUD showSuccess:@"卡片通知已开启" toView:weakSelf.view];
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showSuccess:@"开启卡片通知发生错误" toView:weakSelf.view];
        }];
    }
}

#pragma mark - removeThisCardRequest 删除卡片请求
- (void)removeThisCardRequest {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除此卡片吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        WEAKSELF
        DelEventApi *delEventApi = [[DelEventApi alloc] initWithEid:_recommendModel.eid];
        
        [MBProgressHUD showMessage:Loading toView:weakSelf.view];
        [delEventApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
                [MBProgressHUD hideHUDForView:weakSelf.view];
                
                [MBProgressHUD showSuccess:@"删除成功" toView:weakSelf.view];
                
                if (weakSelf.removeThisCardBlock) {
                    weakSelf.removeThisCardBlock();
                }
                
                GCD_AFTER(BackViewSeconds, ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
        }];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - deleteMessageWithMessageModel 删除评论
- (void)deleteMessageWithMessageModel:(CommentModel *)commentModel {
    DeleteCommentApi *deleteCommentApi = [[DeleteCommentApi alloc] initWithEid:commentModel.eid
                                                                     commentId:commentModel.commentId];
    [deleteCommentApi start];
}

- (void)deleteMessageWithReplyModel:(CommentReplyModel *)commentReplyModel {
    DeleteCommentApi *deleteCommentApi = [[DeleteCommentApi alloc] initWithEid:commentReplyModel.eid
                                                                     commentId:commentReplyModel.commentReplyId];
    [deleteCommentApi start];
}

#pragma mark - gestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - changeSelectedButtonColorWithIndex
- (void)changeSelectedButtonColorWithIndex:(NSInteger)index {
    [self setCommentButton:index == 0 ? YES : NO
             deliverButton:index == 1 ? YES : NO
             collectButton:index == 2 ? YES : NO];
    
    [self showReplyInputViewByIndex:index];
}

#pragma mark - setCommentButton
- (void)setCommentButton:(BOOL)isComment deliverButton:(BOOL)isDeliver collectButton:(BOOL)isCollect {
    _commentButton.selected = isComment;
    _deliverButton.selected = isDeliver;
    _collectButton.selected = isCollect;
}

#pragma mark - scrollViewToTop
- (void)scrollViewToTop {
    [UIView animateWithDuration:0.3
                     animations:^{
                         [_detailScrollView setContentOffset:CGPointMake(0, -64)];
                     }];
}

#pragma mark - actions 按钮动作
- (IBAction)topCollectButtonAction:(id)sender {
    WEAKSELF
    if (_topCollectButton.selected) {
        FavoriteCancelApi *favoriteCancelApi = [[FavoriteCancelApi alloc] initWithEid:_recommendModel.eid];
        [MBProgressHUD showMessage:Loading toView:self.view];
        [favoriteCancelApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
                weakSelf.topCollectButton.selected = NO;
                [MBProgressHUD hideHUDForView:weakSelf.view];
                [MBProgressHUD show:@"已取消收藏" customIcon:@"home-cancelCollect" view:weakSelf.view];
                [weakSelf.collectArray removeAllObjects];
                
                weakSelf.fromCollectAction = YES;
                [weakSelf requestFavoriteUsersWithOffset:0];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:N_MY_CENTER_FAVORITE_REFRESH object:weakSelf.recommendModel.eid];
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showSuccess:@"取消收藏发生错误" toView:weakSelf.view];
        }];
    }
    else {
        FavoriteAddApi *favoriteAddApi = [[FavoriteAddApi alloc] initWithEid:_recommendModel.eid];
        [MBProgressHUD showMessage:Loading toView:self.view];
        [favoriteAddApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
                weakSelf.topCollectButton.selected = YES;
                [MBProgressHUD hideHUDForView:weakSelf.view];
                [MBProgressHUD show:@"收藏成功" customIcon:@"home-collectOk" view:weakSelf.view];
                [weakSelf.collectArray removeAllObjects];
                
                weakSelf.fromCollectAction = YES;
                [weakSelf requestFavoriteUsersWithOffset:0];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:N_MY_CENTER_FAVORITE_REFRESH object:weakSelf.recommendModel.eid];             
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showSuccess:@"收藏发生错误" toView:weakSelf.view];
        }];
    }
}

- (IBAction)shareButtonAction:(id)sender {
    
    self.currentRecommendModel = _recommendModel;
    self.pageControlIndex = _commendButtomView.pageControl.currentPage;
    
    [self shareButtonAction];
}

- (IBAction)moreButtonAction:(id)sender {
    
    BOOL isMyselfCard = [_recommendModel.uid isEqualToString:GlobalData.userModel.userID];
    [self loadCurrentImageView];
    
    if (_disabledEditCardNotification) {
        [SRActionSheet sr_showActionSheetViewWithTitle:nil
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:_isSaveCard ? (@[@"保存到本地", isMyselfCard ? @"删除该卡片" : @"举报该卡片"]) : (@[isMyselfCard ? @"删除该卡片" : @"举报该卡片"])
                                              delegate:self];
    }
    else {
        NSString *cardNotification = @"";
        if (!isMyselfCard) {
            cardNotification = !_enableCardNotification ? @"开启该卡片通知" : @"关闭该卡片通知";
            [SRActionSheet sr_showActionSheetViewWithTitle:nil
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:_isSaveCard ? (@[@"保存到本地", cardNotification, isMyselfCard ? @"删除该卡片" : @"举报该卡片"]) : (@[cardNotification, isMyselfCard ? @"删除该卡片" : @"举报该卡片"])
                                                  delegate:self];
        }
        else {
            [SRActionSheet sr_showActionSheetViewWithTitle:nil
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:_isSaveCard ? (@[@"保存到本地", isMyselfCard ? @"删除该卡片" : @"举报该卡片"]) : (@[isMyselfCard ? @"删除该卡片" : @"举报该卡片"])
                                                  delegate:self];
        }
    }
}

- (IBAction)detailViewButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self changeSelectedButtonColorWithIndex:button.tag];
    [_tableScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * button.tag, 0) animated:YES];
}

- (IBAction)commentTableViewToTopAction:(id)sender {
    [_commentTableView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)deliverTableViewToTopAction:(id)sender {
    [_deliverTableView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)collectTableViewToTopAction:(id)sender {
    [_collectTableView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _commentTableView) {
        return _commentArray.count;
    }
    else if (tableView == _deliverTableView) {
        return _deliverArray.count;
    }
    
    return _collectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:CommentCell];
    commentCell.cellIndexPath = nil;
    
    FavoriteUserModel *favoriteUserModel;
    
    WEAKSELF
    if (tableView == _commentTableView) {
        commentCell.commentModel = [_commentArray objectAtIndex:indexPath.row];
        commentCell.cellIndexPath = indexPath;
        commentCell.headButtonTapBlock = ^(CommentModel *commentModel) {
            BOOL isMyselfCard = [commentModel.uid isEqualToString:GlobalData.userModel.userID];
            if (!isMyselfCard) {
                weakSelf.otherCenterID = commentModel.uid;
                [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
            }
        };
        
        commentCell.nickNameTapBlock = ^(NSString *uid) {
            if (uid && uid.length) {
                NSLog(@"%@", uid);
                
                weakSelf.otherCenterID = uid;
                [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
            }
        };
        
        commentCell.replyNickNameTapBlock = ^(NSString *replyUid) {
            if (replyUid && replyUid.length) {
                NSLog(@"%@", replyUid);
                
                weakSelf.otherCenterID = replyUid;
                [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
            }
        };
        
        commentCell.commentContentButtonTapBlock = ^(CommentModel *commentModel, NSIndexPath *cellIndexPath) {
            weakSelf.isCommentReply = NO;
            if ([commentModel.uid isEqualToString:GlobalData.userModel.userID]) {
                [SRActionSheet sr_showActionSheetViewWithTitle:@"确定要删除这条留言吗？"
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:@"删除留言"
                                             otherButtonTitles:nil
                                                      delegate:weakSelf];
                weakSelf.deleteIndexPath = cellIndexPath;
            }
            else {
                CommentReplyModel *commentReplyModel = [[CommentReplyModel alloc] init];
                commentReplyModel.fromCommentId = commentModel.commentId;
                commentReplyModel.uid = commentModel.uid;
                weakSelf.replyCommentModel = commentReplyModel;
                [weakSelf showReplyInputViewByIndex:0];
                weakSelf.replyInputView.placeHolderLabel.text = [NSString stringWithFormat:@"回复%@", commentModel.nickName];
                [weakSelf.replyInputView.textView becomeFirstResponder];
            }
        };
        
        commentCell.longPressCommentContentBlock = ^(CommentModel *commentModel, NSIndexPath *cellIndexPath) {
            weakSelf.isCommentReply = NO;
            if ([weakSelf.recommendModel.uid isEqualToString:GlobalData.userModel.userID]) {
                [SRActionSheet sr_showActionSheetViewWithTitle:@"确定要删除这条留言吗？"
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:@"删除留言"
                                             otherButtonTitles:nil
                                                      delegate:weakSelf];
                weakSelf.deleteIndexPath = cellIndexPath;
            }
        };
        
        commentCell.replyContentTapBlock = ^(CommentReplyModel *commentReplyModel) {
            if (![commentReplyModel.uid isEqualToString:GlobalData.userModel.userID]) {
                weakSelf.replyCommentModel = commentReplyModel;
                [weakSelf showReplyInputViewByIndex:0];
                weakSelf.replyInputView.placeHolderLabel.text = [NSString stringWithFormat:@"回复%@", commentReplyModel.nickName];
                [weakSelf.replyInputView.textView becomeFirstResponder];
            }
        };
        
        commentCell.longPressReplyContentBlock = ^(CommentReplyModel *commentReplyModel, NSIndexPath *replyIndexPath) {
            weakSelf.isCommentReply = YES;
            if ([weakSelf.recommendModel.uid isEqualToString:GlobalData.userModel.userID] || [commentReplyModel.uid isEqualToString:GlobalData.userModel.userID] || [commentCell.commentModel.uid  isEqualToString:GlobalData.userModel.userID]) {
                [SRActionSheet sr_showActionSheetViewWithTitle:@"确定要删除这条留言吗？"
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:@"删除留言"
                                             otherButtonTitles:nil
                                                      delegate:weakSelf];
                
                weakSelf.replyCommentModel = commentReplyModel;
                
                weakSelf.deleteIndexPath = indexPath;
                weakSelf.deleteRelpyIndexPath = replyIndexPath;
            }
        };
        
        [commentCell loadReplyData];
    }
    else if (tableView == _deliverTableView) {
        commentCell.commentModel = [_deliverArray objectAtIndex:indexPath.row];
        commentCell.headButtonTapBlock = ^(CommentModel *commentModel) {
            BOOL isMyselfCard = [commentModel.uid isEqualToString:GlobalData.userModel.userID];
            if (!isMyselfCard) {
                weakSelf.otherCenterID = commentModel.uid;
                [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
            }
        };
    }
    else {
        favoriteUserModel = [_collectArray objectAtIndex:indexPath.row];
        [commentCell.headImageView sd_setImageWithURL:[NSURL URLWithString:favoriteUserModel.avatar]
                                     placeholderImage:[UIImage imageNamed:@"home-commentDefaultHead"]];
        commentCell.genderImageView.image = [UIImage imageNamed:favoriteUserModel.gender.integerValue == 1 ? @"home-boy" : @"home-girl"];
        commentCell.nickNameLabel.text = favoriteUserModel.nickName;
        commentCell.timeLabel.text = [NSDate timeAgo:favoriteUserModel.createTime.doubleValue];
        
        commentCell.headButtonTapBlock = ^{
            BOOL isMyselfCard = [favoriteUserModel.uid isEqualToString:GlobalData.userModel.userID];
            if (!isMyselfCard) {
                weakSelf.otherCenterID = favoriteUserModel.uid;
                [weakSelf performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
            }
        };
    }

    return commentCell;
}

#pragma mark = UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 230;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == _commentTableView) {
//        CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:CommentCell];
//        commentCell.commentModel = [_commentArray objectAtIndex:indexPath.row];
//        
//        [commentCell.replyCommentTableView layoutIfNeeded];
//        [commentCell.contentView layoutIfNeeded];
//        CGFloat systemLayoutSizeHeight = [commentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        
//        return systemLayoutSizeHeight;
//    }
//    else {
//        return 72;
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *commentModel;
    FavoriteUserModel *favoriteUserModel;
    
    if (tableView == _commentTableView) {
        commentModel = [_commentArray objectAtIndex:indexPath.row];
        _otherCenterID = commentModel.uid;
    }
    else if (tableView == _deliverTableView) {
        commentModel = [_deliverArray objectAtIndex:indexPath.row];
        _otherCenterID = commentModel.uid;
    }
    else {
        favoriteUserModel = [_collectArray objectAtIndex:indexPath.row];
        _otherCenterID = favoriteUserModel.uid;
    }
    
    if (![commentModel.uid isEqualToString:GlobalData.userModel.userID]) {
        [self performSegueWithIdentifier:@"otherCenterSegue" sender:nil];
    }
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self closeKeyboard];
    
    if (scrollView == _commentTableView || scrollView == _deliverTableView || scrollView == _collectTableView) {
        if (scrollView.contentSize.height > scrollView.frame.size.height) {
            scrollView.mj_footer.hidden = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _detailScrollView) {
        
        if (scrollView.contentOffset.y + 1 >= _viewHeightConstraint.constant - SCREEN_HEIGHT) {
            _commentTableView.scrollEnabled = YES;
            _deliverTableView.scrollEnabled = YES;
            _collectTableView.scrollEnabled = YES;
        } else {
            _commentTableView.scrollEnabled = NO;
            _deliverTableView.scrollEnabled = NO;
            _collectTableView.scrollEnabled = NO;
        }
    }
    
    if (scrollView == _tableScrollView) {
        CGRect rect = _slideImageView.frame;
        rect.origin.x = _commentButton.centerX - rect.size.width/2 + (_deliverButton.center.x - _commentButton.center.x)/SCREEN_WIDTH * scrollView.contentOffset.x;
        _slideImageView.frame = rect;
        _currentSlideImageViewFrame = rect;
    }
    
    if (scrollView == _commentTableView || scrollView == _deliverTableView || scrollView == _collectTableView) {
        if (scrollView.contentOffset.y < 0) {
            _commentTableView.scrollEnabled = NO;
            _deliverTableView.scrollEnabled = NO;
            _collectTableView.scrollEnabled = NO;
            
            [self scrollViewToTop];
        }
    }
    
    if (scrollView == _commentTableView) {
        if (scrollView.contentOffset.y > 0) {
            _commentTableViewTopButton.hidden = NO;
        } else {
            _commentTableViewTopButton.hidden = YES;
        }
    }
    
    if (scrollView == _deliverTableView) {

        if (scrollView.contentOffset.y > 0) {
            _deliverTableViewTopButton.hidden = NO;
        } else {
            _deliverTableViewTopButton.hidden = YES;
        }
    }
    
    if (scrollView == _collectTableView) {
        
        if (scrollView.contentOffset.y > 0) {
            _collectTableViewTopButton.hidden = NO;
        } else {
            _collectTableViewTopButton.hidden = YES;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _tableScrollView) {
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        
        [self changeSelectedButtonColorWithIndex:index];
    }
}

#pragma mark - showReplyInputViewByIndex
- (void)showReplyInputViewByIndex:(NSInteger)index {
    _replyInputView.placeHolderLabel.text = @"在这里说点什么吧";
    [UIView animateWithDuration:0.2
                     animations:^{
                         _replyInputView.frame = CGRectMake(0,
                                                            (index == 0 ? SCREEN_HEIGHT - 54 : SCREEN_HEIGHT),
                                                            SCREEN_WIDTH,
                                                            54);
                     }];
    
}

// 清楚tableview多余的cell
- (void)setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view =[[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)closeKeyboard {
    // 隐藏键盘
    _replyCommentModel = nil;
    _replyInputView.placeHolderLabel.text = @"在这里说点什么吧";
    [_replyInputView.textView resignFirstResponder];
}

- (void)backHandle:(UIPanGestureRecognizer *)recognizer {
    [self customControllerPopHandle:recognizer];
}

- (void)customControllerPopHandle:(UIPanGestureRecognizer *)recognizer {
    if(self.navigationController.childViewControllers.count == 1) {
        return;
    }
    // _interactiveTransition就是代理方法2返回的交互对象，我们需要更新它的进度来控制POP动画的流程。（以手指在视图中的位置与屏幕宽度的比例作为进度）
    CGFloat process = [recognizer translationInView:self.view].x / self.view.bounds.size.width;
    process = MIN(1.0, MAX(0.0, process));
    
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        // 此时，创建一个UIPercentDrivenInteractiveTransition交互对象，来控制整个过程中动画的状态
        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged) {
        [_interactiveTransition updateInteractiveTransition:process]; // 更新手势完成度
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded ||recognizer.state == UIGestureRecognizerStateCancelled) {
        // 手势结束时，若进度大于0.5就完成pop动画，否则取消
        if(process > 0.5) {
            [_interactiveTransition finishInteractiveTransition];
        }
        else {
            [_interactiveTransition cancelInteractiveTransition];
        }
        
        _interactiveTransition = nil;
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    // 拿到键盘弹出时间
    double duration = [notification.userInfo[
                                             UIKeyboardAnimationDurationUserInfoKey
                                             ] doubleValue];
    
    // 计算transform
    CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat ty = keyboardY - SCREEN_HEIGHT;
    
    /**
     *  像这种移动后又回到原始位置的建议使用transform,因为transform可以直接清零回到原来的位置
     */
    [UIView animateWithDuration:duration
                     animations:^{
                         self.replyInputView.transform = CGAffineTransformMakeTranslation(0, ty);
                         
                         if (ty < 0) {
                             _backView.alpha = 0.4;
                         } else {
                             _backView.alpha = 0.0;
                         }
                     }];
    
    if (ty < 0) {
        [self.detailScrollView setContentOffset:CGPointMake(0, self.detailScrollView.contentSize.height - SCREEN_HEIGHT) animated:YES];
    }
}

//更新replyView的高度约束
- (void)updateHeight:(CGSize)contentSize {
    
    float height;
    if (contentSize.height == 34) {
        height = contentSize.height + 20;
    }
    else {
        height = contentSize.height + 24;
    }
    
    CGRect frame = self.replyInputView.frame;
    frame.origin.y -= height - frame.size.height;  //高度往上拉伸
    frame.size.height = height;
    self.replyInputView.frame = frame;
}

- (void)loadNoContentViewWithContentView:(UITableView *)contentView firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle {
    
    UIView *view = [contentView viewWithTag:2016];
    if (view) {
        [view removeFromSuperview];
    }
    
    NoPublishView *noPublishView = [NoPublishView awakeWithNib];
    noPublishView.center = CGPointMake(CGRectGetWidth(contentView.frame)/2, CGRectGetHeight(noPublishView.frame)/2 + 75);
    noPublishView.firstLabel.text = firstTitle;
    noPublishView.secondLabel.text = secondTitle;
    noPublishView.publishContentButton.hidden = YES;
    noPublishView.tag = 2016;
    [contentView addSubview:noPublishView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[CardDataViewController class]]) {
        CardDataViewController *cardDataViewController = [segue destinationViewController];
        cardDataViewController.recommendModel = _recommendModel;
    }
    
    if ([[segue destinationViewController] isKindOfClass:[ReportViewController class]]) {
        ReportViewController *reportViewController = [segue destinationViewController];
        reportViewController.eid = _recommendModel.eid;
    }
    
    UIViewController *destinationViewController = [segue destinationViewController].childViewControllers.firstObject;
    
    if ([destinationViewController isKindOfClass:[OtherCenterViewController class]]) {
        OtherCenterViewController *otherCenterViewController = (OtherCenterViewController *)destinationViewController;
        otherCenterViewController.userID = _otherCenterID;
    }
}

#pragma mark - SRActionSheetDelegate

- (void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index {
    
    if ([actionSheet.title isEqualToString:@"确定要删除这条留言吗？"]) {
        
        if (index == 0) {
            if (!_isCommentReply) {
                NSUInteger dIndex;
                if (_deleteIndexPath == nil) {
                    dIndex = 0;
                }
                else {
                    dIndex = _deleteIndexPath.row;
                }
                
                if (dIndex > _commentArray.count - 1) {
                    dIndex = _commentArray.count - 1;
                }
                
                CommentModel *commentModel = [_commentArray objectAtIndex:dIndex];
                
                _deleteIndexPath = [NSIndexPath indexPathForRow:dIndex inSection:0];
                
                // 从数据源中删除
                [_commentArray removeObjectAtIndex:dIndex];
                [_commentTableView reloadData];
                
                // 从列表中删除
//                [_commentTableView deleteRowsAtIndexPaths:@[_deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self deleteMessageWithMessageModel:commentModel];
                
                self.commendButtomView.talkCountLabel.text = [NSString stringWithFormat:@"%td", _commentArray.count];
                [self.commentButton setTitle:[NSString stringWithFormat:@"留言 %td", _commentArray.count] forState:UIControlStateNormal];
                
                WEAKSELF
                GCD_AFTER(0.5, ^{
                    if (_commentArray.count == 0) {
                        [weakSelf loadNoContentViewWithContentView:weakSelf.commentTableView
                                                        firstTitle:@"暂无留言，马上抢沙发~"
                                                       secondTitle:@""];
                    }
                });
            }
            else {
                // 删除留言回复
                [self deleteMessageWithReplyModel:_replyCommentModel];
                
                CommentModel *commentModel = [_commentArray objectAtIndex:_deleteIndexPath.row];
                if (commentModel) {
                    NSMutableArray *tempReplyList = [NSMutableArray arrayWithArray:commentModel.replyList];
                    
                    if (tempReplyList && tempReplyList.count && tempReplyList.count > _deleteRelpyIndexPath.row) {
                        [tempReplyList removeObjectAtIndex:_deleteRelpyIndexPath.row];
                        commentModel.replyList = tempReplyList;
                        
                        [_commentTableView reloadRowsAtIndexPaths:@[_deleteIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
            }
        }
    }
    else {
        BOOL isMyselfCard = [_recommendModel.uid isEqualToString:GlobalData.userModel.userID];
        if (_isSaveCard) {
            if (index == 0) {
                // 保存到相册
                [Tool saveImageToDeviceWithImage:self.currentImage];
            }
            else if (index == 1) {
                if (!isMyselfCard && !_disabledEditCardNotification) {
                    // 开启或关闭卡片通知
                    [self turnOnOrTurnOffPushRequest];
                }
                else {
                    // 删除或者举报
                    if (isMyselfCard) {
                        [self removeThisCardRequest];
                    } else {
                        [self performSegueWithIdentifier:@"reportSegue" sender:nil];
                    }
                }
            }
            else if (index == 2) {
                // 删除或者举报
                if (isMyselfCard) {
                    [self removeThisCardRequest];
                } else {
                    [self performSegueWithIdentifier:@"reportSegue" sender:nil];
                }
            }
        }
        else {
            if (index == 0) {
                if (!isMyselfCard && !_disabledEditCardNotification) {
                    // 开启或关闭卡片通知
                    [self turnOnOrTurnOffPushRequest];
                }
                else {
                    // 删除或者举报
                    if (isMyselfCard) {
                        [self removeThisCardRequest];
                    } else {
                        [self performSegueWithIdentifier:@"reportSegue" sender:nil];
                    }
                }
            }
            else if (index == 1) {
                // 删除或者举报
                if (isMyselfCard) {
                    [self removeThisCardRequest];
                } else {
                    [self performSegueWithIdentifier:@"reportSegue" sender:nil];
                }
            }
        }
    }
}

#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if ([toVC isKindOfClass:[HomeViewController class]] ||
        [toVC isKindOfClass:[OtherCenterViewController class]] ||
        [toVC isKindOfClass:[NotificationViewController class]]) {
        // 去掉导航分割线
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    
    if ([fromVC isKindOfClass:[CardDetailViewController class]]) {
//        if ([_recommendModel.eventType isEqualToString:TextEvent] || [_recommendModel.eventType isEqualToString:VoteEvent]) {
//            
//            if ([toVC isKindOfClass:[HomeViewController class]]) {
//                MagicMoveInverseTransition *inverseTransition = [[MagicMoveInverseTransition alloc] init];
//                return inverseTransition;
//            } else {
//                return nil;
//            }
//        }
        
        if(operation == UINavigationControllerOperationPop) {
            return [[PopAnimationTransition alloc] init];
        }
        
        return nil;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if([animationController isKindOfClass:[PopAnimationTransition class]]) {
        return _interactiveTransition;
    }
    return nil;
}

#pragma mark - ESPictureBrowserDelegate Methods
- (UIView *)pictureView:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
    return nil;
}

- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    PhotoModel *photoModel = _recommendModel.eventPicVos[index];
    return photoModel.picPath;
}

//#pragma mark - ReplyCommentContentViewDelegate Methods
//-(void)replyCommentContentItemAction:(CommentReplyModel *)commentReplyModel {
//    if (![commentReplyModel.uid isEqualToString:GlobalData.userModel.userID]) {
//        self.replyCommentModel = commentReplyModel;
//        [self showReplyInputViewByIndex:0];
//        self.replyInputView.placeHolderLabel.text = [NSString stringWithFormat:@"回复%@", commentReplyModel.nickName];
//        [self.replyInputView.textView becomeFirstResponder];
//    }
//}

@end
