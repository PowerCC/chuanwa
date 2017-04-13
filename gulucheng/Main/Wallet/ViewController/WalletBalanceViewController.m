//
//  WalletBalanceViewController.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/14.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "WalletBalanceViewController.h"
#import "WalletBalanceCell.h"
#import "MyWalletApi.h"
#import "RewardListApi.h"
#import "MyWalletModel.h"
#import "RewardListModel.h"

@interface WalletBalanceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *balanceTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UITableView *rewardTableView;

@property (weak, nonatomic) IBOutlet UIView *balanceEmptyView;

@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;

@property (strong, nonatomic) MyWalletModel *myWalletModel;
@property (strong, nonatomic) NSMutableArray *rewardDataArray;

@end

@implementation WalletBalanceViewController

- (void)dealloc {
    self.rewardTableView.dataSource = nil;
    self.rewardTableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self requestMyWallet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.navView.hidden = YES;
//
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kCOLOR(255, 129, 105, 1)] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    self.navView.hidden = NO;
//    
//    self.navigationController.navigationBar.tintColor = NaviTintColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: kCOLOR(68, 68, 68, 1.0), NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"public-horizonLine"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_withdrawButton circularWithSize:CGSizeMake(3, 3)];
}

- (void)initUI {
    self.rewardDataArray = [NSMutableArray arrayWithCapacity:4];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 9, 200, 18)];
    label.text = @"奖金明细（元）";
    label.textColor = kCOLOR(153, 153, 153, 1);
    label.font = [UIFont systemFontOfSize:13];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 36.0)];
    [headerView addSubview:label];
    headerView.backgroundColor = kCOLOR(240, 242, 247, 1);
    
    _rewardTableView.tableHeaderView = headerView;
    _rewardTableView.dataSource = self;
    _rewardTableView.delegate = self;
    
    _withdrawButton.enabled = NO;
    _withdrawButton.backgroundColor = kCOLOR(255, 191, 184, 1);
}

#pragma mark - currentDate
- (NSString *)currentDate {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"更新时间：YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

#pragma mark - addTableFooter
- (void)addTableFooter {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    [button setTitle:@"查看更多" forState:UIControlStateNormal];
    [button setTitleColor:kCOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"wallet-rightArrow"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button addTarget:self action:@selector(gotoWalletBonusDetails) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40.0)];
    [footerView addSubview:button];
    footerView.backgroundColor = [UIColor whiteColor];

    _rewardTableView.tableFooterView = footerView;
    [_rewardTableView layoutIfNeeded];
}

#pragma mark - fillWalletData
- (void)fillWalletData {
    if (_myWalletModel) {
        _balanceTotalLabel.text = (!_myWalletModel.balanceTotal || [_myWalletModel.balanceTotal isEqualToString:@"0"]) ? @"0.00" : [NSString stringWithFormat:@"%.3f", _myWalletModel.balanceTotal.floatValue];
        _updateTimeLabel.text = !_myWalletModel.updateTime ? [self currentDate] : [NSString timestampSwitchTime:_myWalletModel.updateTime.doubleValue andFormatter:@"更新时间：YYYYMMdd"];
        _statusLabel.text = [_myWalletModel.status isEqualToString:@"-1"] ? @"余额状态：冻结" : @"余额状态：正常";
    }
}

#pragma mark - requestMyWallet
- (void)requestMyWallet {
    WEAKSELF
    MyWalletApi *myWalletApi = [[MyWalletApi alloc] init];
    [myWalletApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            weakSelf.myWalletModel = [MyWalletModel JCParse:request.responseJSONObject[@"data"]];
            
            [weakSelf fillWalletData];
            [weakSelf requestRewardListWithOffset];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - requestRewardListWithOffset
- (void)requestRewardListWithOffset {
    WEAKSELF
    RewardListApi *rewardListApi = [[RewardListApi alloc] initWithLimit:4 offset:0];
    [rewardListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            NSArray *rewardArray = [RewardListModel JCParse:request.responseJSONObject[@"data"][@"list"]];
            NSString *dataCount = request.responseJSONObject[@"data"][@"count"];
            
            if (rewardArray && rewardArray.count) {
                if (rewardArray.count > 0) {
                    weakSelf.rewardTableView.scrollEnabled = YES;
                    weakSelf.balanceEmptyView.hidden = YES;
                    weakSelf.withdrawButton.enabled = YES;
                    weakSelf.withdrawButton.backgroundColor = kCOLOR(255, 129, 105, 1);
                }
                else {
                    weakSelf.rewardTableView.scrollEnabled = NO;
                    weakSelf.balanceEmptyView.hidden = NO;
                }
                
                if (dataCount.integerValue > 4) {
                    [weakSelf addTableFooter];
                }
                
                [weakSelf.rewardDataArray addObjectsFromArray:rewardArray];
                [weakSelf.rewardTableView reloadData];
            }
            else {
                weakSelf.balanceEmptyView.hidden = NO;
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - gotoWalletBonusDetails
- (void)gotoWalletBonusDetails {
    NSString *identifier = @"walletBonusDetailsSegue";
    [self performSegueWithIdentifier:identifier sender:nil];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rewardDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WalletBalanceCell *walletBalanceCell = [tableView dequeueReusableCellWithIdentifier:@"walletBalanceCell"];
    
    NSInteger row = indexPath.row;
    walletBalanceCell.rewardListModel = _rewardDataArray[row];
    
    return walletBalanceCell;
}

#pragma mark = UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77.0;
}

@end
