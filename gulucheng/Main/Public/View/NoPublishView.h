//
//  NoPublishView.h
//  GuluCheng
//
//  Created by xukz on 16/9/19.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoPublishView : UIView

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *publishContentButton;

@property (copy, nonatomic) void (^PublishContentBlock)();

+ (NoPublishView *)awakeWithNib;

@end
