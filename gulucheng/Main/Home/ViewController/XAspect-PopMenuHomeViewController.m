//
//  XAspect-PopMenuHomeViewController.m
//  gulucheng
//
//  Created by 许坤志 on 16/9/3.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "HomeViewController.h"

#import "XAspect.h"

#define AtAspect XAspect_PopMenuHomeViewController

#define AtAspectOfClass HomeViewController
@classPatchField(HomeViewController)

AspectPatch(-, void, viewWillAppear:(BOOL)animated) {
    
    PopMenuModel* model = [PopMenuModel
                           allocPopMenuModelWithImageNameString:@"home-takePhoto"
                           AtTitleString:@"手机拍照"
                           AtTextColor:kCOLOR(34, 34, 34, 1.0)
                           AtTransitionType:PopMenuTransitionTypeSystemApi
                           AtTransitionRenderingColor:nil];
    
    PopMenuModel* model1 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"home-showPicture"
                            AtTitleString:@"相册选择"
                            AtTextColor:kCOLOR(34, 34, 34, 1.0)
                            AtTransitionType:PopMenuTransitionTypeSystemApi
                            AtTransitionRenderingColor:nil];
    
    PopMenuModel* model2 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"home-showText"
                            AtTitleString:@"发布文字"
                            AtTextColor:kCOLOR(34, 34, 34, 1.0)
                            AtTransitionType:PopMenuTransitionTypeSystemApi
                            AtTransitionRenderingColor:nil];
    
    PopMenuModel* model3 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"home-showVote"
                            AtTitleString:@"发布投票"
                            AtTextColor:kCOLOR(34, 34, 34, 1.0)
                            AtTransitionType:PopMenuTransitionTypeSystemApi
                            AtTransitionRenderingColor:nil];
    
    self.menu.dataSource = @[ model, model1, model2, model3];
    self.menu.delegate = self;
    self.menu.popMenuSpeed = 12.0f;
    self.menu.automaticIdentificationColor = false;
    self.menu.animationType = HyPopMenuViewAnimationTypeViscous;
    
    UIImageView *propagateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home-transform"]];
    propagateImageView.frame = CGRectMake(SCREEN_WIDTH / 2 - 253 / 2, 160, 253, 20);
    self.menu.topView = propagateImageView;
    
    return XAMessageForward(viewWillAppear:animated);
}

AspectPatch(-, void, viewDidLoad) {
    
    self.menu = [HyPopMenuView sharedPopMenuManager];
    
    return XAMessageForward(viewDidLoad);
}

AspectPatch(-, void, showMenuButtonAction:(id)sender) {
    
    [self judgeLocationServiceEnabled];
    
    return XAMessageForward(showMenuButtonAction:sender);
}

- (void)judgeLocationServiceEnabled {
    
    if (self.eventCity.length > 0) {
        self.menu.backgroundType = HyPopMenuViewBackgroundTypeLightBlur;
        [self.menu openMenu];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"传蛙需要手机开启定位服务才能正常工作哦" preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"开启定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    /*
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
            
            //定位功能可用，开始定位
            NSLog(@"---------d-----------f---------开启定位");

        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位失败........." preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];

            [alert addAction:action];

            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
            NSLog(@"---------d-----------f---------关闭定位");
        }
     */
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
#undef AtAspectOfClass
#undef AtAspect
