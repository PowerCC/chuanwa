//
//  WalletBonusDetailsViewController.m
//  gulucheng
//
//  Created by 邹程 on 2017/3/15.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "WalletBonusDetailsViewController.h"
#import "WalletBonusDetailsCell.h"
#import "RewardListApi.h"
#import "RewardListModel.h"

static NSInteger const limit = 10;

@interface WalletBonusDetailsViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *bonusDetailsTableView;

@property (strong, nonatomic) NSMutableArray *bonusDataArray;

@property (assign, nonatomic) NSInteger page;

@end

@implementation WalletBonusDetailsViewController

- (void)dealloc {
    self.bonusDetailsTableView.dataSource = nil;
    self.bonusDetailsTableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self requestRewardListWithOffset:_page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.navigationItem.title = @"奖金明细";
    
    self.bonusDataArray = [NSMutableArray array];
    self.page = 0;
    
    _bonusDetailsTableView.dataSource = self;
    _bonusDetailsTableView.delegate = self;
    
    WEAKSELF
    _bonusDetailsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestRewardListWithOffset:limit * ++ weakSelf.page];
    }];
    _bonusDetailsTableView.mj_footer.hidden = YES;
}

- (void)requestRewardListWithOffset:(NSInteger)offset {
    WEAKSELF
    RewardListApi *rewardListApi = [[RewardListApi alloc] initWithLimit:limit offset:offset];
    [rewardListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            NSArray *rewardArray = [RewardListModel JCParse:request.responseJSONObject[@"data"][@"list"]];
            NSString *dataCount = request.responseJSONObject[@"data"][@"count"];
            
            if (rewardArray && rewardArray.count) {
                [weakSelf.bonusDataArray addObjectsFromArray:rewardArray];
                [weakSelf.bonusDetailsTableView reloadData];
            }
            
            [weakSelf.bonusDetailsTableView.mj_footer endRefreshing];
            
            if (dataCount.integerValue == weakSelf.bonusDataArray.count) {
                [weakSelf.bonusDetailsTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else {
            [weakSelf.bonusDetailsTableView.mj_footer endRefreshing];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.bonusDetailsTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height > scrollView.frame.size.height) {
        scrollView.mj_footer.hidden = NO;
    }
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bonusDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WalletBonusDetailsCell *walletBonusDetailsCell = [tableView dequeueReusableCellWithIdentifier:@"walletBonusDetailsCell"];
    
    NSInteger row = indexPath.row;
    walletBonusDetailsCell.rewardListModel = _bonusDataArray[row];
    
    return walletBonusDetailsCell;
}
                                        
#pragma mark = UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77.0;
}

@end
