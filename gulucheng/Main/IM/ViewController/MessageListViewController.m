//
//  MessageListViewController.m
//  gulucheng
//
//  Created by PWC on 2017/2/3.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "UIViewController+SearchController.h"
#import "MessageListViewController.h"
#import "ChatViewController.h"
#import "MessageListTableViewCell.h"
#import "ListByImNamesApi.h"

static NSString *const MessageListCell = @"messageListCell";

@interface MessageListViewController () <EMSearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *emptyDataView;

@property (strong, nonatomic) NSMutableArray *searchResultArray;

@end

@implementation MessageListViewController

- (void)dealloc {

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [self.view bringSubviewToFront:_emptyDataView];
    
    self.searchResultArray = [NSMutableArray array];
    
    self.showRefreshHeader = YES;
    self.tableView.backgroundColor = kCOLOR(239, 242, 247, 1.0);
    
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
        MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageListCell];
        
        if (cell == nil) {
            cell = [MessageListTableViewCell cellFromNib];
        }
        
        id<IConversationModel> model = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        EaseConversationModel *ecModel = (EaseConversationModel *)model;
        cell.userModel = ecModel.chuanwaUserModel;
        cell.model = model;
        
        if (weakSelf.dataSource && [weakSelf.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
            NSMutableAttributedString *attributedText = [[weakSelf.dataSource conversationListViewController:weakSelf latestMessageTitleForConversationModel:model] mutableCopy];
            [attributedText addAttributes:@{NSFontAttributeName : cell.contentLabel.font} range:NSMakeRange(0, attributedText.length)];
            cell.contentLabel.attributedText = attributedText;
        } else {
            cell.contentLabel.attributedText = [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[weakSelf _latestMessageTitleForConversationModel:model]textFont:cell.contentLabel.font];
        }
        
        if (weakSelf.dataSource && [weakSelf.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
            cell.timeLabel.text = [weakSelf.dataSource conversationListViewController:weakSelf latestMessageTimeForConversationModel:model];
        } else {
            cell.timeLabel.text = [weakSelf _latestMessageTimeForConversationModel:model];
        }
        
        return cell;
    }];
    
    [self.resultController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return 75;
    }];
    
    [self.resultController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        EaseConversationModel *model = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        if (model) {
            UserModel *userModel = model.chuanwaUserModel;
            if (userModel) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IM" bundle:nil];
                ChatViewController *chatVc = [storyboard instantiateViewControllerWithIdentifier:@"chat"];
                chatVc.conversationUserModel = userModel;
                [weakSelf.navigationController pushViewController:chatVc animated:YES];
            }
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
            
            NSArray *userModelArray = [UserModel JCParse:request.responseJSONObject[@"data"]];
            
            if (userModelArray.count) {
                for (NSInteger i = 0; i < weakSelf.dataArray.count; i++) {
                    EaseConversationModel *model = weakSelf.dataArray[i];
                    for (UserModel *userModel in userModelArray) {
                        if ([model.conversation.conversationId isEqualToString:userModel.imUname]) {
                            model.chuanwaUserModel = userModel;
                            break;
                        }
                    }
                }
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

#pragma mark - tableViewDidTriggerHeaderRefresh
- (void)tableViewDidTriggerHeaderRefresh {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray *sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if (message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           } else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    [self.dataArray removeAllObjects];
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
            model = [self.dataSource conversationListViewController:self
                                               modelForConversation:converstion];
        }
        else {
            model = [[EaseConversationModel alloc] initWithConversation:converstion];
        }
        
        [self.dataArray addObject:model];
    }
        
    EMError *error = nil;
    NSArray *imUnameArray = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        if (imUnameArray && imUnameArray.count) {
            NSMutableString *imNames = [NSMutableString string];
            for (NSInteger i = 0; i < imUnameArray.count; i++) {
                [imNames appendString:imUnameArray[i]];
                if (i < imUnameArray.count - 1) {
                    [imNames appendString:@","];
                }
            }
            
            if (imNames && imNames.length) {
                [self listByImUserNames:imNames];
            }
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
    if (cancelButton) {
        [cancelButton setTitleColor:kCOLOR(255, 129, 105, 1) forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    if ([self conformsToProtocol:@protocol(EMSearchControllerDelegate)]
        && [self respondsToSelector:@selector(searchTextChangeWithString:)]) {
        [self performSelector:@selector(searchTextChangeWithString:)
                   withObject:searchController.searchBar.text];
    }
}

#pragma mark - EMSearchControllerDelegate Methods
- (void)searchTextChangeWithString:(NSString *)aString {
    
    NSMutableArray *tempNameArray = [NSMutableArray array];
    
    for (EaseConversationModel *ecModel in self.dataArray) {
        [tempNameArray addObject:ecModel.chuanwaUserModel.nickName];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", aString];
    NSMutableArray *tempSearchResultArray = [[tempNameArray filteredArrayUsingPredicate:predicate] mutableCopy];
    
    [_searchResultArray removeAllObjects];
    for (EaseConversationModel *ecModel in self.dataArray) {
        for (NSString *nickName in tempSearchResultArray) {
            if ([ecModel.chuanwaUserModel.nickName isEqualToString:nickName]) {
                [_searchResultArray addObject:ecModel];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageListCell];
    
    if (cell == nil) {
        cell = [MessageListTableViewCell cellFromNib];
    }
    
    if ([self.dataArray count] <= indexPath.row) {
        return cell;
    }

    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
    EaseConversationModel *ecModel = (EaseConversationModel *)model;
    cell.userModel = ecModel.chuanwaUserModel;
    cell.model = model;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
        NSMutableAttributedString *attributedText = [[self.dataSource conversationListViewController:self latestMessageTitleForConversationModel:model] mutableCopy];
        [attributedText addAttributes:@{NSFontAttributeName : cell.contentLabel.font} range:NSMakeRange(0, attributedText.length)];
        cell.contentLabel.attributedText = attributedText;
    } else {
        cell.contentLabel.attributedText = [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.contentLabel.font];
    }
    
    if (cell.contentLabel.text == nil || cell.contentLabel.text.length == 0) {
        cell.contentLabel.text = @" ";
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [self.dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
    
    return cell;
}

#pragma mark = UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model) {
        UserModel *userModel = model.chuanwaUserModel;
        if (userModel) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IM" bundle:nil];
            ChatViewController *chatVc = [storyboard instantiateViewControllerWithIdentifier:@"chat"];
            chatVc.conversationUserModel = userModel;
            [self.navigationController pushViewController:chatVc animated:YES];
        }
    }
}

#pragma mark - EMChatManagerDelegate Methods
- (void)messagesDidReceive:(NSArray *)aMessages {
    if (aMessages && aMessages.count) {
        [self tableViewDidTriggerHeaderRefresh];
    }
}

@end
