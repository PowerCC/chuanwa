//
//  HomeViewController.h
//  GuluCheng
//
//  Created by 许坤志 on 16/7/31.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BaseShareViewController.h"
#import "VoteCommendView.h"
#import "PhotoCommendView.h"
#import "CommendButtomView.h"

#import "TZImagePickerController.h"
#import "HyPopMenuView.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface HomeViewController : BaseShareViewController <HyPopMenuViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, AMapLocationManagerDelegate> {
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
}

@property (nonatomic, strong) VoteCommendView *voteCommendView;
@property (nonatomic, strong) PhotoCommendView *photoCommendView;

@property (nonatomic, strong) CommendButtomView *commendButtomView;

@property (nonatomic, strong) HyPopMenuView *menu;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, copy) NSString *eventCity;
@property (nonatomic, copy) NSString *eventId;

@property (nonatomic, strong) UIImagePickerController *imagePickerVC;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGRect finalCellRect;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;

@property (weak, nonatomic) IBOutlet UIView *publishImageContentView;
@property (weak, nonatomic) IBOutlet UIView *publishHintView;
@property (weak, nonatomic) IBOutlet UIView *otherHintView;

@property (weak, nonatomic) IBOutlet UILabel *publishHintLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherHintLabel;

- (IBAction)showMenuButtonAction:(id)sender;

- (void)eventRequest:(NSString *)eid
             success:(void(^)())success
             failure:(void(^)())failure;

- (void)textPublishAction;
- (void)votePublishAction;
- (void)photoPublishAction;
- (void)takePhotoAction;

- (void)showPublishHintView:(NSString *)value;
- (void)showOtherHintView:(NSString *)value;

- (void)reGeocodeAction;

@end
