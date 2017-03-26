//
//  ContactListViewController.m
//  gulucheng
//
//  Created by PWC on 2017/2/4.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "UIViewController+SearchController.h"
#import "ContactListViewController.h"
#import "ChatViewController.h"
#import "OtherCenterViewController.h"
#import "ContactListTableViewCell.h"
#import "ListByImNamesApi.h"

static NSString *const ContactListCell = @"contactListCell";

@interface ContactListViewController () <EMSearchControllerDelegate> {
    UILocalizedIndexedCollation *indexCollation;
}

@property (weak, nonatomic) IBOutlet UIView *emptyDataView;

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *searchResultArray;

@end

@implementation ContactListViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {

    self.sectionTitles = [NSMutableArray array];
    self.searchResultArray = [NSMutableArray array];
    
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:_emptyDataView];
    
    self.showRefreshHeader = YES;
    self.tableView.backgroundColor = kCOLOR(239, 242, 247, 1.0);
    self.tableView.sectionIndexColor = kCOLOR(153, 153, 153, 1);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    [self setupSearchController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSearchController {
    [self enableSearchController];
    
    self.searchController.searchBar.placeholder = @"搜索用户";
    [self.searchController.searchBar sizeToFit];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.searchController.searchBar];
    self.tableView.tableHeaderView = headerView;
    
    WEAKSELF
    [self.resultController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        ContactListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactListCell];
        
        if (cell == nil) {
            cell = [ContactListTableViewCell cellFromNib];
        }
        
        UserModel *model = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        cell.userModel = model;
        
        return cell;

    }];
    
    [self.resultController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return 75;
    }];
    
    [self.resultController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UserModel *model = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        
        if (model) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IM" bundle:nil];
            ChatViewController *chatVc = [storyboard instantiateViewControllerWithIdentifier:@"chat"];
            chatVc.conversationUserModel = model;
            [weakSelf.navigationController pushViewController:chatVc animated:YES];
        }
        
        [weakSelf cancelSearch];
    }];
}

#pragma mark - listByImUserNames 根据环信用户名获得用户列表
- (void)listByImUserNames:(NSString *)userNames {
    WEAKSELF
    ListByImNamesApi *listByImNamesApi = [[ListByImNamesApi alloc] initWithUserNames:userNames];
    [listByImNamesApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            NSInteger highSection = [weakSelf.sectionTitles count];
            NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
            for (NSInteger i = 0; i < highSection; i++) {
                NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
                [sortedArray addObject:sectionArray];
            }
            
            NSArray *userModelArray = [UserModel JCParse:request.responseJSONObject[@"data"]];
            
            for (UserModel *userModel in userModelArray) {
                
                NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:userModel.nickName];
                NSInteger section;
                if (firstLetter.length > 0) {
                    section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
                } else {
                    section = [sortedArray count] - 1;
                }
                
                NSMutableArray *array = [sortedArray objectAtIndex:section];
                [array addObject:userModel];
            }

            // 每个section内的数组排序
            for (NSInteger i = 0; i < [sortedArray count]; i++) {
                NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(UserModel *obj1, UserModel *obj2) {
                    NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.nickName];
                    firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
                    
                    NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.nickName];
                    firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
                    
                    return [firstLetter1 caseInsensitiveCompare:firstLetter2];
                }];
                
                
                [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
            }
            
            // 去掉空的section
            for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
                NSArray *array = [sortedArray objectAtIndex:i];
                if ([array count] == 0) {
                    [sortedArray removeObjectAtIndex:i];
                    [weakSelf.sectionTitles removeObjectAtIndex:i];
                }
            }
            
            [weakSelf.dataArray addObjectsFromArray:sortedArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.dataArray.count) {
                    weakSelf.emptyDataView.hidden = YES;
                }
                else {
                    weakSelf.emptyDataView.hidden = NO;
                }
                [weakSelf.tableView reloadData];
                [weakSelf tableViewDidFinishTriggerHeader:YES reload:NO];
            });
        }
    } failure:^(YTKBaseRequest *request) {
        [weakSelf tableViewDidFinishTriggerHeader:YES reload:NO];
    }];
}

- (void)sortDataArray:(NSArray *)buddyList {
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    NSMutableArray *contactsSource = [NSMutableArray array];
    
    // 从获取的数据中剔除黑名单中的好友
    EMError *error = nil;
    NSArray *blockList = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
    if (!error) {
        for (NSString *buddy in buddyList) {
            if (![blockList containsObject:buddy]) {
                [contactsSource addObject:buddy];
            }
        }
        
        // 建立索引的核心, 返回27，是a－z和＃
        indexCollation = [UILocalizedIndexedCollation currentCollation];
        [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
        
        // 按首字母分组
        NSMutableString *imNames = [NSMutableString string];
        for (NSString *buddy in contactsSource) {
            
            EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
            int tempIndex = 0;
            if (model) {
                
                [imNames appendString:buddy];
                if (tempIndex < contactsSource.count - 1) {
                    [imNames appendString:@","];
                }
                
                tempIndex++;
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
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [weakself.dataArray removeAllObjects];
        
        NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        if (!error && buddyList && buddyList.count) {
            NSMutableArray *contactsSource = [NSMutableArray arrayWithArray:buddyList];
            [weakself sortDataArray:contactsSource];
        }
    });
}

#pragma mark - UISearchControllerDelegate Methods
- (void)willPresentSearchController:(UISearchController *)searchController {
    searchController.searchBar.placeholder = @"请输入用户名";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    topView.tag = 20170208;
    topView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:topView];
    
    self.tableView.tableHeaderView.height = 64;
    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:self.tableView.tableHeaderView];
    [self.tableView endUpdates];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    searchController.searchBar.placeholder = @"搜索用户";
    
    UIView *topView = [[UIApplication sharedApplication].keyWindow viewWithTag:20170208];
    [topView removeFromSuperview];
    
    self.tableView.tableHeaderView.height = 44;
    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:self.tableView.tableHeaderView];
    [self.tableView endUpdates];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    searchController.searchBar.showsCancelButton = YES;
    UIButton *cancelButton = (UIButton *)[searchController.searchBar valueForKey:@"cancelButton"];
    [cancelButton setTitleColor:kCOLOR(255, 129, 105, 1)  forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    if ([self conformsToProtocol:@protocol(EMSearchControllerDelegate)]
        && [self respondsToSelector:@selector(searchTextChangeWithString:)]) {
        [self performSelector:@selector(searchTextChangeWithString:)
                   withObject:searchController.searchBar.text];
    }
}

#pragma mark - EMSearchControllerDelegate Methods
- (void)searchTextChangeWithString:(NSString *)aString {
    NSMutableArray *tempNameArray = [NSMutableArray array];
    
    for (NSArray *userSection in self.dataArray) {
        for (UserModel *userModel in userSection) {
            [tempNameArray addObject:userModel.nickName];
        }
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", aString];
    NSMutableArray *tempSearchResultArray = [[tempNameArray filteredArrayUsingPredicate:predicate] mutableCopy];
    
    [_searchResultArray removeAllObjects];
    for (NSArray *userSection in self.dataArray) {
        for (UserModel *userModel in userSection) {
            for (NSString *nickName in tempSearchResultArray) {
                if ([userModel.nickName isEqualToString:nickName]) {
                    [_searchResultArray addObject:userModel];
                }
            }
        }
    }
    
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.resultController.displaySource removeAllObjects];
        [weakSelf.resultController.displaySource addObjectsFromArray:weakSelf.searchResultArray];
        [weakSelf.resultController.tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataArray objectAtIndex:(section)] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"    %@", _sectionTitles[section]];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactListCell];
    
    if (cell == nil) {
        cell = [ContactListTableViewCell cellFromNib];
    }
    
    NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section)];
    UserModel *model = [userSection objectAtIndex:indexPath.row];
    cell.userModel = model;
    
    WEAKSELF
    cell.gotoOtherCenter = ^(NSString *userID) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        OtherCenterViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"myCenterID"];
        vc.userID = userID;
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Public" bundle:nil] instantiateInitialViewController];
        nav.viewControllers = @[vc];
        [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
    };
    
    return cell;

}

#pragma mark = UITableViewDelegate Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    headerView.backgroundColor = kCOLOR(239, 242, 247, 1.0);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 6, 30, 16)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = kCOLOR(153, 153, 153, 1.0);
    label.text = _sectionTitles[section];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section)];
    UserModel *model = [userSection objectAtIndex:indexPath.row];
    
    if (model) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IM" bundle:nil];
        ChatViewController *chatVc = [storyboard instantiateViewControllerWithIdentifier:@"chat"];
        chatVc.conversationUserModel = model;
        [self.navigationController pushViewController:chatVc animated:YES];
    }
}

@end
