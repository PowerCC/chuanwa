//
//  MyWalletViewController.m
//  GuluCheng
//
//  Created by PWC on 2017/3/14.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletFuncCell.h"
#import "MyWalletFuncModel.h"

@interface MyWalletViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *funcTableView;

@property (strong, nonatomic) NSMutableArray *funcDataArray;

@end

@implementation MyWalletViewController

- (void)dealloc {
    self.funcTableView.dataSource = nil;
    self.funcTableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.navigationItem.title = @"我的钱包";
    self.funcDataArray = [NSMutableArray arrayWithCapacity:2];
    
    MyWalletFuncModel *f1 = [[MyWalletFuncModel alloc] init];
    MyWalletFuncModel *f2 = [[MyWalletFuncModel alloc] init];
    
    f1.funcImageName = @"wallet-balance";
    f2.funcImageName = @"wallet-rule";
    
    f1.funcName = @"余额";
    f2.funcName = @"奖金规则";
    
    [_funcDataArray addObject:f1];
    [_funcDataArray addObject:f2];
    
    _funcTableView.dataSource = self;
    _funcTableView.delegate = self;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _funcDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyWalletFuncCell *myWalletFuncCell = [tableView dequeueReusableCellWithIdentifier:@"myWalletFuncCell"];
    
    NSInteger row = indexPath.row;
    
    MyWalletFuncModel *model = _funcDataArray[row];
    myWalletFuncCell.funcModel = model;
    
    return myWalletFuncCell;
}

#pragma mark = UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"walletBalanceSegue";
    NSInteger row = indexPath.row;
    if (row == 1) {
        identifier = @"walletRuleSegue";
    }
    
    [self performSegueWithIdentifier:identifier sender:nil];
}

@end
