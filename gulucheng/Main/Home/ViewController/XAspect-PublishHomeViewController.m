//
//  XAspect-PublishHomeViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/3.
//  Copyright © 2016年 许坤志. All rights reserved.
//

//#import "XAspect-PublishHomeViewController.h"
//
//@implementation XAspect_PublishHomeViewController
//
//@end


#import "HomeViewController.h"
#import "CustomAnimationController.h"
#import "TextPublishViewController.h"
#import "VotePublishViewController.h"
#import "PhotoPublishViewController.h"

#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import "TZImageManager.h"

#import "XAspect.h"

#define AtAspect PublishHomeViewController

#define AtAspectOfClass HomeViewController
@classPatchField(HomeViewController)

- (void)hintView:(PublishModel *)publishModel {
    if (publishModel.oneDayMaxRewards != nil && publishModel.oneDayMaxRewards.integerValue > 0) {
        if (publishModel.rewardFail != nil) {
            if ([publishModel.rewardFail isEqualToString:@"1"]) {
                [self showOtherHintView:publishModel.oneDayMaxRewards];
            }
            else {
                [self showPublishHintView:publishModel.rewardFail];
            }
        }
    }
}

AspectPatch(-, void, viewDidLoad) {
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    return XAMessageForward(viewDidLoad);
}

AspectPatch(-, void, textPublishAction) {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TextPublish" bundle:nil];
    UINavigationController *navViewController = [storyboard instantiateInitialViewController];
    TextPublishViewController *textViewController = (TextPublishViewController *)navViewController.topViewController;
    textViewController.latitude = self.latitude;
    textViewController.longitude = self.longitude;
    textViewController.eventCity = self.eventCity;
    
    textViewController.publishBlock = ^(PublishModel *publishModel, NSString *eid, NSString *eventType, NSString *shareText, UIImage *shareImage, BOOL isChat, BOOL isSina, BOOL isQQZone) {
        self.eid = eid;
        self.eventType = eventType;
        self.shareText = shareText;
        self.shareImage = shareImage;
        
        [self hintView:publishModel];
        
        [self showAlertWithChat:isChat isSina:isSina isQQZone:isQQZone];
    };
    
    [self.baseNav presentToAnyViewControllerWithCustomAnimation:navViewController customAnimation:[[CustomPublishAnimationController alloc] init] hiddenNav:YES];
//    [self presentViewController:navViewController animated:YES completion:nil];
    
    
    return XAMessageForward(textPublishAction);
}

AspectPatch(-, void, votePublishAction) {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"VotePublish" bundle:nil];
    UINavigationController *navViewController = [storyboard instantiateInitialViewController];
    VotePublishViewController *voteViewController = (VotePublishViewController *)navViewController.topViewController;
    voteViewController.latitude = self.latitude;
    voteViewController.longitude = self.longitude;
    voteViewController.eventCity = self.eventCity;
    
    voteViewController.publishBlock = ^(PublishModel *publishModel, NSString *eid, NSString *eventType, NSString *shareText, UIImage *shareImage, BOOL isChat, BOOL isSina, BOOL isQQZone) {
        self.eid = eid;
        self.eventType = eventType;
        self.shareText = shareText;
        self.shareImage = shareImage;
        
        [self hintView:publishModel];
        
        [self showAlertWithChat:isChat isSina:isSina isQQZone:isQQZone];
    };
    
    [self.baseNav presentToAnyViewControllerWithCustomAnimation:navViewController customAnimation:[[CustomPublishAnimationController alloc] init] hiddenNav:YES];
//    [self presentViewController:navViewController animated:YES completion:nil];
    
    return XAMessageForward(votePublishAction);
}

AspectPatch(-, void, photoPublishAction) {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.navigationBar.tintColor = NaviTintColor;
    imagePickerVc.oKButtonTitleColorDisabled = BGGrayColor;
    imagePickerVc.oKButtonTitleColorNormal = Them_orangeColor;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
//        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        
        [self presentPhotoViewController];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    return XAMessageForward(photoPublishAction);
}

- (UIImagePickerController *)imagePickerVc {
    if (self.imagePickerVC == nil) {
        self.imagePickerVC = [[UIImagePickerController alloc] init];
        self.imagePickerVC.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        self.imagePickerVC.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        self.imagePickerVC.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return self.imagePickerVC;
}

// 拍照
AspectPatch(-, void, takePhotoAction) {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:self.imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
    
    return XAMessageForward(takePhotoAction);
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) { // 如果保存失败，基本是没有相册权限导致的...
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法保存图片" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                alert.tag = 1;
                [alert show];
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
//                        [_selectedAssets addObject:assetModel.asset];
//                        [_selectedPhotos addObject:image];
                        
                        _selectedPhotos = [NSMutableArray arrayWithObject:image];
                        _selectedAssets = [NSMutableArray arrayWithObject:assetModel.asset];

                        [self presentPhotoViewController];
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    [self presentPhotoViewController];
}

- (void)presentPhotoViewController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoPublish" bundle:nil];
    UINavigationController *navViewController = [storyboard instantiateInitialViewController];
    PhotoPublishViewController *photoVC = (PhotoPublishViewController *)navViewController.topViewController;
    photoVC.photoArray = _selectedPhotos;
    photoVC.selectedAssets = _selectedAssets;
    
    photoVC.latitude = self.latitude;
    photoVC.longitude = self.longitude;
    photoVC.eventCity = self.eventCity;
    
    WEAKSELF
    photoVC.publishBlock = ^(PublishModel *publishModel, NSString *eid, NSString *eventType, NSString *shareText, UIImage *shareImage, BOOL isChat, BOOL isSina, BOOL isQQZone) {
        weakSelf.eid = eid;
        weakSelf.eventType = eventType;
        weakSelf.shareText = shareText;
        weakSelf.shareImage = shareImage;
        
        [self hintView:publishModel];
        
        [weakSelf showAlertWithChat:isChat isSina:isSina isQQZone:isQQZone];
    };
    
    GCD_AFTER(0.0, ^{
        [weakSelf.baseNav presentToAnyViewControllerWithCustomAnimation:navViewController customAnimation:[[CustomPublishAnimationController alloc] init] hiddenNav:YES];
//        [weakSelf presentViewController:navViewController animated:YES completion:nil];
    });
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    
}

AspectPatch(-, void, prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender) {
    
    
    return XAMessageForward(prepareForSegue:segue sender:sender);
}


@end
#undef AtAspectOfClass
#undef AtAspect
