//
//  VotePublishViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/3.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "VotePublishViewController.h"
#import "VoteTableViewCell.h"

#import "PublishVoteApi.h"
#import "UIButton+Able.h"

@interface VotePublishViewController ()

@property (strong, nonatomic) NSMutableArray *voteDefaultContentArray;
@property (strong, nonatomic) NSMutableArray *voteContentArray;

@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UITableView *voteTableView;
@property (weak, nonatomic) IBOutlet UITextField *voteQuestionTextField;

@end

@implementation VotePublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _voteDefaultContentArray = [@[@"输入选项1", @"输入选项2"] mutableCopy];
    _voteContentArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    [_publishButton textDisableWithColor:Disable_grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _voteDefaultContentArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VoteTableViewCell *voteCell = [tableView dequeueReusableCellWithIdentifier:@"voteCell"];
    
    WEAKSELF
    voteCell.deleteCellBlock = ^(NSInteger index) {
        [weakSelf.voteDefaultContentArray removeObjectAtIndex:weakSelf.voteDefaultContentArray.count - 1];
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView reloadData];
    };
    
    voteCell.textFieldBlock = ^{
        GCD_AFTER(0.1, ^{
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
            VoteTableViewCell *voteCell1 = [_voteTableView cellForRowAtIndexPath:indexPath1];
            VoteTableViewCell *voteCell2 = [_voteTableView cellForRowAtIndexPath:indexPath2];

            if (voteCell1.voteContentTextField.text.length > 0 && voteCell2.voteContentTextField.text.length > 0) {
                [weakSelf.publishButton textNormalWithColor:Them_orangeColor];
            } else {
                [weakSelf.publishButton textDisableWithColor:Disable_grayColor];
            }
        });
    };
    
    if (indexPath.row == _voteDefaultContentArray.count) {
        voteCell.voteContentTextField.userInteractionEnabled = NO;
        voteCell.voteCircleImageView.image = [UIImage imageNamed:@"publish-voteAdd"];
        voteCell.voteContentTextField.text = @"增加一条选项";
        voteCell.deleteButton.hidden = YES;
    }
    else {
        voteCell.deleteButton.tag = indexPath.row;
        voteCell.voteContentTextField.placeholder = [_voteDefaultContentArray objectAtIndex:indexPath.row];
        
        if (_voteDefaultContentArray.count > 2) {
            voteCell.deleteButton.hidden = NO;
        } else {
            voteCell.deleteButton.hidden = YES;
        }
    }
    
    return voteCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _voteDefaultContentArray.count) {
        [_voteDefaultContentArray addObject:[NSString stringWithFormat:@"输入选项%td", indexPath.row + 1]];
        
        // 从列表中添加
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView reloadData];
        
        if (indexPath.row == 4) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            cell.hidden = YES;
        }
    }
}

//- (IBAction)viewDismissButtonAction:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)checkVoteContentArray {
    NSInteger rows =  [_voteTableView numberOfRowsInSection:0];
    for (NSInteger row = 0; row < rows - 1; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        
        VoteTableViewCell *voteCell = [_voteTableView cellForRowAtIndexPath:indexPath];
        
        if (voteCell.voteContentTextField.text.length > 0) {
            [_voteContentArray addObject:voteCell.voteContentTextField.text];
        }
    }
}

- (IBAction)votePublishButtonAction:(id)sender {
    
    [self checkVoteContentArray];
    
    if (_voteContentArray.count > 0 && _voteQuestionTextField.text.length > 0) {
        
        [MBProgressHUD showMessage:Loading toView:self.view];
        PublishVoteApi *publishVoteApi = [[PublishVoteApi alloc] initWithTitle:_voteQuestionTextField.text
                                                                       option1:_voteContentArray.count > 0 ? [_voteContentArray objectAtIndex:0] : nil
                                                                       option2:_voteContentArray.count > 1 ? [_voteContentArray objectAtIndex:1] : nil
                                                                       option3:_voteContentArray.count > 2 ? [_voteContentArray objectAtIndex:2] : nil
                                                                       option4:_voteContentArray.count > 3 ? [_voteContentArray objectAtIndex:3] : nil
                                                                       option5:_voteContentArray.count > 4 ? [_voteContentArray objectAtIndex:4] : nil
                                                                     eventCity:self.eventCity
                                                                      latitude:self.latitude
                                                                     longitude:self.longitude];
        
        WEAKSELF
        [publishVoteApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            
            [MBProgressHUD hideHUDForView:weakSelf.view];
            
            if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
                
                [MBProgressHUD showSuccess:@"发布成功" toView:weakSelf.view];
                
                GCD_AFTER(1.0, ^{
                    
                    [weakSelf publishButtonActionWithEid:request.responseJSONObject[@"data"]
                                           eventType:@"vote"
                                           shareText:weakSelf.voteQuestionTextField.text
                                          shareImage:nil];
                    
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                });
            }
        } failure:^(YTKBaseRequest *request) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showSuccess:@"发布失败" toView:weakSelf.view];
        }];
    } else {
        [MBProgressHUD showError:@"请填写完整内容"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _voteQuestionTextField) {
        //限制输入字符个数
        if ((_voteQuestionTextField.text.length + string.length - range.length > 14) ) {
            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
