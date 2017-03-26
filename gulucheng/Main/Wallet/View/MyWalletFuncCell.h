//
//  MyWalletFuncCell.h
//  GuluCheng
//
//  Created by 邹程 on 2017/3/14.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWalletFuncModel.h"

@interface MyWalletFuncCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *funcImageView;
@property (weak, nonatomic) IBOutlet UILabel *funcLable;
@property (weak, nonatomic) IBOutlet UILabel *valueLable;

@property (weak, nonatomic) MyWalletFuncModel *funcModel;

@end
