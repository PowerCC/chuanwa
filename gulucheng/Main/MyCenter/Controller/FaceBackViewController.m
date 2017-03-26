//
//  FaceBackViewController.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "FaceBackViewController.h"

#import "FaceBackApi.h"
#import "UIButton+Able.h"

@interface FaceBackViewController ()

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextView *faceBackTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;

@end

@implementation FaceBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_submitButton textDisableWithColor:Disable_orangeColor];
    
    [_faceBackTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_faceBackTextView becomeFirstResponder];
    //    NSLog(@"文本开始编辑");
}

- (void)textViewDidChange:(UITextView *)textView {
    //    NSLog(@"文本在变化");
    _textCountLabel.text = [NSString stringWithFormat:@"%d/200", (int)textView.text.length];
    
    if (textView.text.length >= 200) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的字数超过200了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        _faceBackTextView.text = [textView.text substringToIndex:200];
        _textCountLabel.text = [NSString stringWithFormat:@"200/200"];
        [_submitButton textDisableWithColor:Disable_orangeColor];
    } else if (textView.text.length == 0){
        _placeHolderLabel.hidden = NO;
        [_submitButton textDisableWithColor:Disable_orangeColor];
    } else if (textView.text.length < 200) {
        _placeHolderLabel.hidden = YES;
        [_submitButton textNormalWithColor:Them_orangeColor];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSLog(@"确定");
    }else{
        NSLog(@"取消");
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    //     NSLog(@"文本结束编辑");
}

- (IBAction)submitButtonAction:(id)sender {
    
    [MBProgressHUD showMessage:Loading toView:self.view];
    FaceBackApi *faceBackApi = [[FaceBackApi alloc] initWithContent:_faceBackTextView.text];
    
    WEAKSELF
    [faceBackApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            [MBProgressHUD showSuccess:@"提交成功" toView:weakSelf.view];
            GCD_AFTER(BackViewSeconds, ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
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
