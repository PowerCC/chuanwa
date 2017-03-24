//
//  HeadUpLoadViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/9/5.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "HeadUpLoadViewController.h"
#import "BigHeadPhotoViewController.h"

#import "UpdateUserInfoApi.h"

@interface HeadUpLoadViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation HeadUpLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeMenu)];
    [self.view addGestureRecognizer:tap];
    
    _headImageView.image = _headImage;
}

- (void)closeMenu {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)headButtonAction:(id)sender {

    UIButton *button = (UIButton *)sender;
    
    if (self.photoButtonAction) {
        self.photoButtonAction(button.tag);
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BigHeadPhotoViewController *bigHeadPhotoViewController = [segue destinationViewController];
    bigHeadPhotoViewController.headImage = _headImage;
}

@end
