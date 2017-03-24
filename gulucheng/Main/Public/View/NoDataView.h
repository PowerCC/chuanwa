//
//  NoDataView.h
//  JiaCheng
//
//  Created by 许坤志 on 16/7/7.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (copy, nonatomic) void (^ReloadBlock)();

+ (NoDataView *)awakeWithNib;

@end
