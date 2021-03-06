//
//  BasePublishViewController.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/4.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BasePublishViewController.h"
#import "HomeViewController.h"

@interface BasePublishViewController ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIButton *chatShareButton;
@property (weak, nonatomic) IBOutlet UIButton *sinaShareButton;
@property (weak, nonatomic) IBOutlet UIButton *qqShareButton;

@property (strong, nonatomic) HomeViewController *homeViewController;

@end

@implementation BasePublishViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.locationLabel setText:[NSString stringWithFormat:@"%@", self.eventCity]];
    
//    CGFloat locationLabelWidth = [self.locationLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
//                                                                       options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
//                                                                       context:nil].size.width;
//    
//    self.locationImageViewRightConstraint.constant =  (locationLabelWidth < SCREEN_WIDTH - 106) ? (locationLabelWidth + 17) : (SCREEN_WIDTH - 106 + 17);
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (IBAction)chatShareButtonAction:(id)sender {
    
    if (_chatShareButton.selected) {
        _chatShareButton.selected = NO;
    } else {
        _chatShareButton.selected = YES;
    }
}

- (IBAction)sinaShareButtonAction:(id)sender {
    
    if (_sinaShareButton.selected) {
        _sinaShareButton.selected = NO;
    } else {
        _sinaShareButton.selected = YES;
    }
}

- (IBAction)qqShareButtonAction:(id)sender {
    
    if (_qqShareButton.selected) {
        _qqShareButton.selected = NO;
    } else {
        _qqShareButton.selected = YES;
    }
}

- (void)publishButtonActionWithEid:(PublishModel *)publishModel eid:(NSString *)eid eventType:(NSString *)eventType shareText:(NSString *)shareText shareImage:(UIImage *)shareImage {

    WEAKSELF
    self.navigationController.navigationBar.hidden = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController *nav = [storyboard instantiateInitialViewController];
    nav.view.frame = weakSelf.view.bounds;
    self.homeViewController = (HomeViewController *)nav.topViewController;
    _homeViewController.eventId = eid;
    [_homeViewController eventRequest:eid success:^{
        if (weakSelf.publishBlock) {
            [weakSelf.view addSubview:nav.view];
            weakSelf.publishBlock (publishModel, eid, eventType, shareText, shareImage, weakSelf.chatShareButton.selected, weakSelf.sinaShareButton.selected, weakSelf.qqShareButton.selected);
            
            GCD_AFTER(1.2, ^{
                UIViewController *vc = ((BaseNavigationController *)weakSelf.presentingViewController).topViewController;
                weakSelf.navigationController.transitioningDelegate = vc;
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            });
        }
    } failure:^{
        if (weakSelf.publishBlock) {
            weakSelf.publishBlock (publishModel, eid, eventType, shareText, shareImage, weakSelf.chatShareButton.selected, weakSelf.sinaShareButton.selected, weakSelf.qqShareButton.selected);
            
            GCD_AFTER(1.2, ^{
                UIViewController *vc = ((BaseNavigationController *)weakSelf.presentingViewController).topViewController;
                weakSelf.navigationController.transitioningDelegate = vc;
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}

- (IBAction)viewDismissButtonAction:(id)sender {
    
    [self viewDismissAction];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要放弃发布卡片吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDismissAction {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
