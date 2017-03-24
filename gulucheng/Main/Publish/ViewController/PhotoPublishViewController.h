//
//  PhotoPublishViewController.h
//  GuluCheng
//
//  Created by 许坤志 on 16/8/3.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "BasePublishViewController.h"

@interface PhotoPublishViewController : BasePublishViewController

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *selectedAssets;

@property (nonatomic, copy) void (^addPhotoBlock)(BOOL isPhotoPublishView);

@end
