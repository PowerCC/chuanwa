//
//  ScoreViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 2016/10/17.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "ScoreViewController.h"

@interface ScoreViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.91chuanwa.com/score/main.html?score=%@&nextScore=%@&thisScore=%@&sendAround=%@", self.userModel.score, self.userModel.nextScore, self.userModel.thisScore, self.userModel.sendAround];
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [_webView loadRequest:request];
}

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
