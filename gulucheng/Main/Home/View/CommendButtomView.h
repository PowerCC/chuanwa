//
//  CommendButtomView.h
//  GuluCheng
//
//  Created by 许坤志 on 16/8/11.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface CommendButtomView : UIView

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UILabel *distanceAndTimeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *talkCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

+ (CommendButtomView *)awakeWithNib;
- (void)setFrame:(CGRect)frame commendModel:(RecommendModel *)commendModel;

@end
