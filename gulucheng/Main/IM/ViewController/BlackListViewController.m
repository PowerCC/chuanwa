//
//  BlackListViewController.m
//  GuluCheng
//
//  Created by PWC on 2017/2/10.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "BlackListViewController.h"
#import "ContactListTableViewCell.h"
#import "ListByImNamesApi.h"

static NSString *const ContactListCell = @"contactListCell";

@interface BlackListViewController ()

@property (weak, nonatomic) IBOutlet UIView *emptyDataView;

@end

@implementation BlackListViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"黑名单";
    
    [self.view bringSubviewToFront:_emptyDataView];
    
    self.showRefreshHeader = YES;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 8)];
    headerView.backgroundColor = kCOLOR(239, 242, 247, 1.0);
    self.tableView.backgroundColor = kCOLOR(239, 242, 247, 1.0);
    self.tableView.tableHeaderView = headerView;
    
    [self loadBlacklist];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - listByImUserNames 根据环信用户名获得用户列表
- (void)listByImUserNames:(NSString *)userNames {
    WEAKSELF
    ListByImNamesApi *listByImNamesApi = [[ListByImNamesApi alloc] initWithUserNames:userNames];
    [listByImNamesApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            NSArray *userModelArray = [UserModel JCParse:request.responseJSONObject[@"data"]];
            
            if (userModelArray.count) {
                [weakSelf.dataArray addObjectsFromArray:userModelArray];
            }
            
            if (weakSelf.dataArray.count) {
                weakSelf.emptyDataView.hidden = YES;
            }
            else {
                weakSelf.emptyDataView.hidden = NO;
            }
            
            [weakSelf.tableView reloadData];
            [weakSelf tableViewDidFinishTriggerHeader:YES reload:NO];
        }
    } failure:^(YTKBaseRequest *request) {
        [weakSelf tableViewDidFinishTriggerHeader:YES reload:NO];
    }];
}

- (void)loadBlacklist {
    
    [self.dataArray removeAllObjects];
    
    EMError *error = nil;
    NSArray *blacklist = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
    if (!error && blacklist && blacklist.count) {
        
        NSMutableString *imNames = [NSMutableString string];
        for (NSInteger i = 0; i < blacklist.count; i++) {
            [imNames appendString:blacklist[i]];
            if (i < blacklist.count - 1) {
                [imNames appendString:@","];
            }
        }
        
        if (imNames && imNames.length) {
            [self listByImUserNames:imNames];
        }
        else {
            [self.tableView reloadData];
            [self tableViewDidFinishTriggerHeader:YES reload:NO];
        }
    }
    else {
        [self.tableView reloadData];
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
    }
}

- (void)tableViewDidTriggerHeaderRefresh {
    [self loadBlacklist];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactListCell];
    
    if (cell == nil) {
        cell = [ContactListTableViewCell cellFromNib];
    }
    
    UserModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.userModel = model;
    cell.removeBlacklistButton.hidden = NO;
    
    WEAKSELF
    cell.removeBlacklist = ^(NSString *nickName, NSString *imUname) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确定将（%@）\n解除黑名单吗？", nickName]  preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:imUname];
            if (!error) {
                [weakSelf loadBlacklist];
                [MBProgressHUD showSuccess:@"已解除黑名单" toView:weakSelf.view];
            }
        }]];
        
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    };
    
    return cell;
    
}

#pragma mark = UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}


@end
