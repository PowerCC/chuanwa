//
//  PhotoPublishViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/3.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "PhotoPublishViewController.h"
#import "TZImagePickerController.h"
#import "PhotoCollectionViewCell.h"
#import "BigHeadPhotoViewController.h"

#import "PublishPictureApi.h"

#import "UIButton+Able.h"
#import "Tool.h"

@interface PhotoPublishViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *publishCollectionViewFlowLayout;

@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UITextView *publishTextView;

@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionViewHeightConstraint;

@end

@implementation PhotoPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeKeyboard)];
    tap.delegate = self;
    [self.scrollView addGestureRecognizer:tap];
    
    CGSize publishCellSize;
    publishCellSize = CGSizeMake(114 * (SCREEN_WIDTH / 375), 114 * (SCREEN_WIDTH / 375));
    _publishCollectionViewFlowLayout.itemSize = publishCellSize;
    
    [self collectionViewHeightWithCount:_photoArray.count];
    
    if (_photoArray.count > 0) {
        [_publishButton textNormalWithColor:Them_orangeColor];
    } else {
        [_publishButton textDisableWithColor:Disable_grayColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDismissAction {
    [_publishTextView resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - collectionView About
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoArray.count + 1;
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    if (indexPath.row == _photoArray.count) {
        cell.photoImageView.image = [UIImage imageNamed:@"publish-addPhoto"];
        cell.photoDeleteButton.hidden = YES;
    } else {
        cell.photoImageView.image = [_photoArray objectAtIndex:indexPath.row];
        cell.photoDeleteButton.hidden = NO;
    }
    
    WEAKSELF
    cell.deletePhotoBlock = ^{
        [collectionView performBatchUpdates:^{
            
            [weakSelf.photoArray removeObjectAtIndex:indexPath.row];
            [weakSelf.selectedAssets removeObjectAtIndex:indexPath.row];
            
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [weakSelf collectionViewHeightWithCount:weakSelf.photoArray.count];
            [collectionView reloadData];
            
            if (weakSelf.photoArray.count > 0) {
                [weakSelf.publishButton textNormalWithColor:Them_orangeColor];
            } else {
                [weakSelf.publishButton textDisableWithColor:Disable_grayColor];
            }
        }];
    };
    
//    cell.deleteBtn.tag = indexPath.row;
//    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _photoArray.count) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:nil];
        
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
        imagePickerVc.isSelectOriginalPhoto = YES;
        
        // 1.如果你需要将拍照按钮放在外面，不要传这个参数
        imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
        
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
        
        WEAKSELF
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            weakSelf.photoArray = [NSMutableArray arrayWithArray:photos];
            weakSelf.selectedAssets = [NSMutableArray arrayWithArray:assets];
            
            [weakSelf collectionViewHeightWithCount:weakSelf.photoArray.count];
            [weakSelf.photoCollectionView reloadData];
            
            if (weakSelf.photoArray.count > 0) {
                [weakSelf.publishButton textNormalWithColor:Them_orangeColor];
            } else {
                [weakSelf.publishButton textDisableWithColor:Disable_grayColor];
            }
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    } else {
//        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
//        imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
//        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
//        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//            _selectedAssets = [NSMutableArray arrayWithArray:assets];
//            _isSelectOriginalPhoto = isSelectOriginalPhoto;
//            _layout.itemCount = _selectedPhotos.count;
//            [_collectionView reloadData];
//            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//        }];
//        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyCenter" bundle:nil];
        BigHeadPhotoViewController *bigHeadPhotoViewController = [storyboard instantiateViewControllerWithIdentifier:@"bigHeadPhoto"];
        bigHeadPhotoViewController.headImage = _photoArray[indexPath.row];
        bigHeadPhotoViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:bigHeadPhotoViewController animated:YES completion:nil];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_publishTextView becomeFirstResponder];
    //    NSLog(@"文本开始编辑");
    WEAKSELF
    GCD_AFTER(0.15, ^{
        int height;
        if (_photoArray.count < 9) {
            height = (4 + 114 * (SCREEN_WIDTH / 375)) * ((_photoArray.count + 1)/3 + ((_photoArray.count + 1)%3 > 0 ? 1 : 0) - 1);
        } else {
            height = (4 + 114 * (SCREEN_WIDTH / 375)) * ((_photoArray.count)/3 + ((_photoArray.count)%3 > 0 ? 1 : 0) - 1);
        }
        
        [weakSelf.scrollView setContentOffset:CGPointMake(0, height)
                                     animated:YES];
        
    });
    
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"文本在变化");
    _textCountLabel.text = [NSString stringWithFormat:@"%d/144", (int)textView.text.length];
    
    if (textView.text.length > 144) {
        _placeHolderLabel.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的字数超过144了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        _publishTextView.text = [textView.text substringToIndex:144];
        _textCountLabel.text = [NSString stringWithFormat:@"144/144"];
        [_publishButton textNormalWithColor:Them_orangeColor];
        return;
    } else if (textView.text.length == 0){
        _placeHolderLabel.hidden = NO;
        if (_photoArray.count == 0) {
            [_publishButton textDisableWithColor:Disable_grayColor];
        }
    } else if (textView.text.length <= 144) {
        _placeHolderLabel.hidden = YES;
        if (_photoArray.count > 0) {
            [_publishButton textNormalWithColor:Them_orangeColor];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        [_publishTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // [self closeKeyboard];
}

- (void)closeKeyboard {
    [_publishTextView resignFirstResponder];
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)publishButtonAction:(id)sender {
    
    [_publishTextView resignFirstResponder];
    
    [MBProgressHUD showMessage:Loading toView:self.view];
    PublishPictureApi *publishPictureApi = [[PublishPictureApi alloc] initWithImages:_photoArray
                                                                              remark:_publishTextView.text
                                                                           eventCity:self.eventCity
                                                                            latitude:self.latitude
                                                                           longitude:self.longitude];
    
    WEAKSELF
    [publishPictureApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            PublishModel *publishModel = [PublishModel JCParse:request.responseJSONObject[@"data"]];
            if (publishModel) {
//                [MBProgressHUD showSuccess:@"发布成功" toView:weakSelf.view];
                [weakSelf publishButtonActionWithEid:publishModel
                                                 eid:publishModel.eventId
                                           eventType:@"pic"
                                           shareText:nil
                                          shareImage:[UIImage imageWithData:[Tool compressImage:weakSelf.photoArray.firstObject toTargetWidth:1024 maxFileSize:100]]];
            }
        }
    } failure:^(YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showSuccess:@"发布失败" toView:weakSelf.view];
    }];
}

- (void)collectionViewHeightWithCount:(NSInteger)photoCount {
    if (photoCount < 9) {
        _photoCollectionViewHeightConstraint.constant = 12 + (4 + 114 * (SCREEN_WIDTH / 375)) * ((photoCount + 1)/3 + ((photoCount + 1)%3 > 0 ? 1 : 0));
    } else {
        _photoCollectionViewHeightConstraint.constant = 12 + (4 + 114 * (SCREEN_WIDTH / 375)) * ((photoCount)/3 + ((photoCount)%3 > 0 ? 1 : 0));
    }
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
