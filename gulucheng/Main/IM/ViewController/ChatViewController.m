//
//  ChatViewController.m
//  gulucheng
//
//  Created by PWC on 2017/2/4.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "ChatViewController.h"
#import "OtherCenterViewController.h"
#import "UIViewController+SearchController.h"
#import "SRActionSheet.h"

#import "EaseEmotionManager.h"
#import "EaseEmoji.h"
#import "EaseEmotionEscape.h"
#import "EaseCustomMessageCell.h"

@interface ChatViewController () <SRActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation ChatViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    
    if (_fromPush) {
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"home-closed"]];
    }

    [AppDelegateInstance.homeViewController.messageButton setImage:[UIImage imageNamed:@"home-message"] forState:UIControlStateNormal];
    
    self.conversation = [[EMClient sharedClient].chatManager getConversation:self.conversationUserModel.imUname type:EMConversationTypeChat createIfNotExist:YES];
    
    self.messageCountOfPage = 10;
    self.timeCellHeight = 30;
    self.deleteConversationIfNull = YES;
    self.scrollToBottomWhenAppear = YES;
    self.messsagesSource = [NSMutableArray array];
    
    [self.conversation markAllMessagesAsRead:nil];
    
    [super viewDidLoad];
    
    [self customUI];
    [_avatarImageView circular];
    
    self.showRefreshHeader = YES;
    self.tableView.backgroundColor = kCOLOR(239, 242, 247, 1.0);
    
    
    [self loadUserData];
    [self acceptInvitationForUsername];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AppDelegateInstance.homeViewController.messageButton setImage:[UIImage imageNamed:@"home-message"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customUI {
    [[EaseBaseMessageCell appearance] setAvatarSize:0.f];
    [[EaseBaseMessageCell appearance] setMessageNameIsHidden:YES];
}

- (void)loadUserData {
    if (self.conversationUserModel) {
        _nickNameLabel.text = self.conversationUserModel.nickName;
        
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.conversationUserModel.avatar] placeholderImage:[UIImage imageNamed:@"logo"]];
    }
}

- (void)acceptInvitationForUsername {
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:self.conversationUserModel.imUname];
    if (!error) {
        NSLog(@"发送同意成功");
    }
}

#pragma mark - Actions
- (IBAction)backAction:(id)sender {
    if (_fromPush) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)gotoOtherCenterAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    OtherCenterViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"myCenterID"];
    vc.userID = self.conversationUserModel.userID;
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Public" bundle:nil] instantiateInitialViewController];
    nav.viewControllers = @[vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)showMoreOpAction:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [SRActionSheet sr_showActionSheetViewWithTitle:nil
                                 cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                                 otherButtonTitles:@[@"加入黑名单", @"清空聊天记录"]
                                          delegate:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataArray objectAtIndex:indexPath.row];
    
    //time cell
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *timeCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        timeCell.title = object;
        return timeCell;
    }
    else {
        id<IMessageModel> model = object;
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageViewController:cellForMessageModel:)]) {
            UITableViewCell *cell = [self.delegate messageViewController:tableView cellForMessageModel:model];
            if (cell) {
                if ([cell isKindOfClass:[EaseMessageCell class]]) {
                    EaseMessageCell *emcell= (EaseMessageCell*)cell;
                    if (emcell.delegate == nil) {
                        emcell.delegate = self;
                    }
                }
                return cell;
            }
        }
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
            BOOL flag = [self.dataSource isEmotionMessageFormessageViewController:self messageModel:model];
            if (flag) {
                NSString *CellIdentifier = [EaseCustomMessageCell cellIdentifierWithModel:model];
                //send cell
                EaseCustomMessageCell *sendCell = (EaseCustomMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                // Configure the cell...
                if (sendCell == nil) {
                    sendCell = [[EaseCustomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
                    sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(emotionURLFormessageViewController:messageModel:)]) {
                    EaseEmotion *emotion = [self.dataSource emotionURLFormessageViewController:self messageModel:model];
                    if (emotion) {
                        model.image = [UIImage sd_animatedEMGIFNamed:emotion.emotionOriginal];
                        model.fileURLPath = emotion.emotionOriginalURL;
                    }
                }
                sendCell.model = model;
                sendCell.delegate = self;
                return sendCell;
            }
        }
        
        NSString *CellIdentifier = [EaseMessageCell cellIdentifierWithModel:model];
        
        EaseBaseMessageCell *sendCell = (EaseBaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[EaseBaseMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sendCell.delegate = self;
        }
        
        sendCell.model = model;
        return sendCell;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        return 40;//self.timeCellHeight;
    }
    else {
        id<IMessageModel> model = object;
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageViewController:heightForMessageModel:withCellWidth:)]) {
            CGFloat height = [self.delegate messageViewController:self heightForMessageModel:model withCellWidth:tableView.frame.size.width];
            if (height) {
                return height;
            }
        }
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
            BOOL flag = [self.dataSource isEmotionMessageFormessageViewController:self messageModel:model];
            if (flag) {
                return [EaseCustomMessageCell cellHeightWithModel:model];
            }
        }
        
        return [EaseBaseMessageCell cellHeightWithModel:model];
    }
}

#pragma mark - SRActionSheetDelegate
- (void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index {
    if (index == 0) {
        EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:self.conversationUserModel.imUname relationshipBoth:YES];
        if (!error) {
            [MBProgressHUD showSuccess:@"已加入黑名单" toView:self.view];
        }
    }
    else if (index == 1) {
        WEAKSELF
        [[EMClient sharedClient].chatManager deleteConversation:self.conversationUserModel.imUname isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
            if (!aError) {
                [weakSelf.messsagesSource removeAllObjects];
                [weakSelf tableViewDidTriggerHeaderRefresh];
                [MBProgressHUD showSuccess:@"聊天记录已清空" toView:weakSelf.view];
            }
            else {
                [MBProgressHUD showSuccess:@"清空聊天记录出错" toView:weakSelf.view];
            }
        }];
    }
}
@end
