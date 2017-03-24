//
//  ReportViewController.m
//  GuluCheng
//
//  Created by xukz on 16/9/14.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportCardApi.h"

@interface ReportViewController ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *selecteImageViews;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;

@property (assign, nonatomic) NSInteger reason;

@end

@implementation ReportViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navView.backgroundColor = kCOLOR(255, 255, 255, 1.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectButtonAction:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    
    _reason = senderButton.tag;

    for (UIImageView *selecteImageView in _selecteImageViews) {
        selecteImageView.hidden  = YES;
    }
    
    UIImageView *selectedImageView = [_selecteImageViews objectAtIndex:senderButton.tag - 1];
    selectedImageView.hidden = NO;
}

- (IBAction)reportButtonAction:(id)sender {
    ReportCardApi *reportCardApi = [[ReportCardApi alloc] initWithEid:_eid
                                                               reason:_reason];
    [MBProgressHUD showMessage:Loading toView:self.view];
    
    WEAKSELF
    [reportCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            [MBProgressHUD showSuccess:@"举报成功" toView:weakSelf.view];
            
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
