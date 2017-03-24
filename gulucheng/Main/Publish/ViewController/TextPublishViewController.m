//
//  TextPublishViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/3.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "TextPublishViewController.h"
#import "UIButton+Able.h"

#import "PublishTextApi.h"
#import "Tool.h"

@interface TextPublishViewController ()

@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UITextView *publishTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;

@end

@implementation TextPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_publishButton textDisableWithColor:Disable_grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_publishTextView becomeFirstResponder];
    //    NSLog(@"文本开始编辑");
}

- (void)textViewDidChange:(UITextView *)textView {
    //    NSLog(@"文本在变化");
    _textCountLabel.text = [NSString stringWithFormat:@"%d/240", (int)textView.text.length];
    
    if (textView.text.length > 240) {
        _placeHolderLabel.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的字数超过240了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        _publishTextView.text = [textView.text substringToIndex:240];
        _textCountLabel.text = [NSString stringWithFormat:@"240/240"];
        [_publishButton textNormalWithColor:Them_orangeColor];
        return;
    } else if (textView.text.length == 0){
        _placeHolderLabel.hidden = NO;
        [_publishButton textDisableWithColor:Disable_grayColor];
    } else if (textView.text.length <= 240) {
        _placeHolderLabel.hidden = YES;
        [_publishButton textNormalWithColor:Them_orangeColor];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    //     NSLog(@"文本结束编辑");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        [_publishTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)viewDismissAction {
    [_publishTextView resignFirstResponder];
}

- (IBAction)publishButtonAction:(id)sender {
    
    [_publishTextView resignFirstResponder];
    
    [MBProgressHUD showMessage:Loading toView:self.view];
    PublishTextApi *publishTextApi = [[PublishTextApi alloc] initWithContent:_publishTextView.text
                                                                   eventCity:self.eventCity
                                                                    latitude:self.latitude
                                                                   longitude:self.longitude];
    
    WEAKSELF
    [publishTextApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            [MBProgressHUD showSuccess:@"发布成功" toView:weakSelf.view];
            
            GCD_AFTER(1.0, ^{
                
                [weakSelf publishButtonActionWithEid:request.responseJSONObject[@"data"]
                                       eventType:@"text"
                                       shareText:weakSelf.publishTextView.text
                                      shareImage:nil];
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            });
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showSuccess:@"发布失败" toView:weakSelf.view];
    }];
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
