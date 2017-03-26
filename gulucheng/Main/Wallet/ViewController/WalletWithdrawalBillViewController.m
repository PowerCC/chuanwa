//
//  WalletWithdrawalBillViewController.m
//  gulucheng
//
//  Created by 邹程 on 2017/3/15.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "WalletWithdrawalBillViewController.h"
#import "WalletWithdrawalCell.h"
#import "TradeLogsApi.h"
#import "TradeLogsModel.h"

static NSInteger const limit = 10;

@interface WalletWithdrawalBillViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *billTableView;

@property (weak, nonatomic) IBOutlet UIView *billEmptyView;

@property (strong, nonatomic) NSMutableArray *billDataArray;

@property (assign, nonatomic) NSInteger page;

@end

@implementation WalletWithdrawalBillViewController

- (void)dealloc {
    self.billTableView.dataSource = nil;
    self.billTableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self requestTradeLogsWithOffset:_page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.navigationItem.title = @"提现账单";

    self.billDataArray = [NSMutableArray arrayWithCapacity:4];
    self.page = 0;
    
    _billTableView.dataSource = self;
    _billTableView.delegate = self;
    
    WEAKSELF
    _billTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestTradeLogsWithOffset:limit * ++ weakSelf.page];
    }];
    _billTableView.mj_footer.hidden = YES;
}

#pragma mark - requestRewardListWithOffset
- (void)requestTradeLogsWithOffset:(NSInteger)offset {
    WEAKSELF
    TradeLogsApi *tradeLogsApi = [[TradeLogsApi alloc] initWithLimit:limit offset:_page];
    [tradeLogsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            NSArray *tradeLogsArray = [TradeLogsModel JCParse:request.responseJSONObject[@"data"][@"list"]];
            NSString *dataCount = request.responseJSONObject[@"data"][@"count"];
            
            if (tradeLogsArray && tradeLogsArray.count) {
                weakSelf.billEmptyView.hidden = YES;
                [weakSelf.billDataArray addObjectsFromArray:tradeLogsArray];
                [weakSelf.billTableView reloadData];
            }
            else {
                weakSelf.billEmptyView.hidden = NO;
            }
            
            [weakSelf.billTableView.mj_footer endRefreshing];
            
            if (dataCount.integerValue == weakSelf.billDataArray.count) {
                [weakSelf.billTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else {
            [weakSelf.billTableView.mj_footer endRefreshing];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.billTableView.mj_footer endRefreshing];
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
    return _billDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WalletWithdrawalCell *walletWithdrawalCell = [tableView dequeueReusableCellWithIdentifier:@"walletWithdrawalCell"];
    
    NSInteger row = indexPath.row;
    walletWithdrawalCell.tradeLogsModel = _billDataArray[row];
    
    return walletWithdrawalCell;
}

#pragma mark = UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 73.0;
}

@end
