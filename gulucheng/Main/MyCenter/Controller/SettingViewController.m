//
//  SettingViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/31.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "SettingViewController.h"
#import "HeadUpLoadViewController.h"
#import "EditNicknameViewController.h"
#import "ProvincialCitiesPickerview.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

#import "UpdateUserInfoApi.h"
#import "SRActionSheet.h"
#import "Tool.h"

@interface SettingViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SRActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *versionImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (nonatomic,strong) ProvincialCitiesPickerview *regionPickerView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:GlobalData.userModel.avatar]
                      placeholderImage:[UIImage imageNamed:@"myCenter-defaultHeadPhoto"]];
    _nickNameLabel.text = GlobalData.userModel.nickName;
    _genderLabel.text = GlobalData.userModel.gender.integerValue == 1 ? @"男" : @"女";
    _cityLabel.text = GlobalData.userModel.cityCode;
    
    [self judgeAPPVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cityButtonAction:(id)sender {
    
    NSString *address = _cityLabel.text;
    NSArray *array = [address componentsSeparatedByString:@" "];
    
    NSString *province = @"";//省
    NSString *city = @"";//市
    if (array.count > 1) {
        province = array[0];
        city = array[1];
    } else if (array.count > 0) {
        province = array[0];
    }
    
    [self.regionPickerView showPickerWithProvinceName:province cityName:city];
}

- (IBAction)checkNewVersionButtonAction:(id)sender {
    if (!_versionImageView.hidden) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/chuan-wa-chuan-di-shen-bian/id1169388161?mt=8"]];
    }
}


- (ProvincialCitiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[ProvincialCitiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        WEAKSELF
        _regionPickerView.completion = ^(NSString *provinceName, NSString *cityName) {
            STRONGSELF
            if (strongSelf) {
                strongSelf.cityLabel.text = [NSString stringWithFormat:@"%@ %@", provinceName, cityName];
            }
        };
        
        _regionPickerView.hideProvincialCitiesPickerview = ^{
            if (![weakSelf.cityLabel.text isEqualToString:GlobalData.userModel.cityCode]) {
                [weakSelf submitCityToServer];
            }
        };
        
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

- (void)submitCityToServer {
    
    [MBProgressHUD showMessage:Loading toView:self.view];
    UpdateUserInfoApi *updateUserInfoApi = [[UpdateUserInfoApi alloc] initWithNickName:nil
                                                                              cityCode:_cityLabel.text
                                                                                avatar:nil];
    
    WEAKSELF
    [updateUserInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            [MBProgressHUD showSuccess:@"保存成功" toView:weakSelf.view];
            
            GlobalData.userModel.cityCode = _cityLabel.text;
            
            if (weakSelf.editCityBlock) {
                weakSelf.editCityBlock(_cityLabel.text);
            }
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

- (void)submitHeadImageWithHeadImage:(UIImage *)headImage {
    
    [MBProgressHUD showMessage:Loading toView:self.view];
    UpdateUserInfoApi *updateUserInfoApi = [[UpdateUserInfoApi alloc] initWithNickName:nil
                                                                              cityCode:nil
                                                                                avatar:headImage];
    
    WEAKSELF
    [updateUserInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            [MBProgressHUD showSuccess:@"保存成功" toView:weakSelf.view];
            
            if (weakSelf.editHeadImageBlock) {
                weakSelf.editHeadImageBlock(headImage);
            }
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

- (IBAction)logOutButtonAction:(id)sender {
    [SRActionSheet sr_showActionSheetViewWithTitle:@"确定要退出当前账号吗？"
                                 cancelButtonTitle:@"取消"
                            destructiveButtonTitle:@"确定退出"
                                 otherButtonTitles:nil
                                          delegate:self];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *avatar = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self submitHeadImageWithHeadImage:avatar];
    _headImageView.image = avatar;
    [self imagePickerWillDissmissWithPickerController:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self imagePickerWillDissmissWithPickerController:picker];
}

- (void)imagePickerWillDissmissWithPickerController:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue destinationViewController] isKindOfClass:[EditNicknameViewController class]]) {
        EditNicknameViewController *editNicknameViewController = [segue destinationViewController];
        WEAKSELF
        editNicknameViewController.editNicknameBlock = ^(NSString *nickName) {
            weakSelf.nickNameLabel.text = nickName;
            GlobalData.userModel.nickName = nickName;
            
            if (weakSelf.editNicknameBlock) {
                weakSelf.editNicknameBlock(nickName);
            }
        };
    }
    
    if ([[segue destinationViewController] isKindOfClass:[HeadUpLoadViewController class]]) {
        HeadUpLoadViewController *headUpLoadViewController = [segue destinationViewController];
        headUpLoadViewController.transitioningDelegate = self;
        headUpLoadViewController.modalPresentationStyle = UIModalPresentationCustom;
        headUpLoadViewController.headImage = _headImageView.image;
        
        WEAKSELF
        headUpLoadViewController.photoButtonAction = ^(NSInteger index) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (index == 0) {
                    // 从相册中选取
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                        
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        picker.allowsEditing = YES;
                        picker.delegate = weakSelf;
                        
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {        //判断当前设备的系统是否是ios7.0以上
                            picker.edgesForExtendedLayout = UIRectEdgeNone;
                        }
                        
                        [weakSelf presentViewController:picker animated:YES completion:NULL];
                    }
                }
                
                if (index == 1) {
                    
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                        controller.allowsEditing = YES;
                        controller.delegate = weakSelf;
                        
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {        //判断当前设备的系统是否是ios7.0以上
                            controller.edgesForExtendedLayout = UIRectEdgeNone;
                        }
                        
                        [weakSelf presentViewController:controller
                                               animated:YES
                                             completion:^(void){
                                                 // [[UIApplication sharedApplication] setStatusBarHidden:YES];
                                                 // [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
                                             }];
                    }
                }
            }];
        };
    }
}

#pragma mark - SRActionSheetDelegate

- (void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index {
    if (index == 0) {
        [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
             [AppDelegateInstance gotoHomeLoginViewController];
        }];
    }
}

- (void)judgeAPPVersion {
    NSString *urlStr = @"https://itunes.apple.com/lookup?id=1169388161";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *appInfo = (NSDictionary *)jsonObject;
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    if (infoContent.count > 0) {
        NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
        
        NSLog(@"商店的版本是 %@",version);
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"当前的版本是 %@",currentVersion);
        
        
        if (![version isEqualToString:currentVersion]) {
            _versionImageView.hidden = NO;
        }
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
//                                                                  presentingController:(UIViewController *)presenting
//                                                                      sourceController:(UIViewController *)source {
//    return [PresentingAnimator new];
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    return [DismissingAnimator new];
//}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

@end
