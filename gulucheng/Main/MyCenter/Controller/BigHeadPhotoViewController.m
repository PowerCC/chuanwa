//
//  BigHeadPhotoViewController.m
//  GuluCheng
//
//  Created by xukz on 16/10/10.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BigHeadPhotoViewController.h"

@interface BigHeadPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImageView;

@end

@implementation BigHeadPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeView)];
    [self.view addGestureRecognizer:tap];
    
    self.headPhotoImageView.image = _headImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeView {
    [self dismissViewControllerAnimated:YES completion:nil];
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
