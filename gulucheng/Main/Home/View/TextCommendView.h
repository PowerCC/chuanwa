//
//  TextCommendView.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/12.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface TextCommendView : UIView

- (id)initWithFrame:(CGRect)frame;
- (void)loadTextCommendModel:(RecommendModel *)textCommendModel;

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIView *businessView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceAndTimeAgoLabel;
//@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *slogenLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessViewDistanceAndTimeAgoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;

@property (weak, nonatomic) IBOutlet UIButton *nickNameButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTopConstraint;

@property (assign, nonatomic) CGRect textViewFrame;

@property (copy, nonatomic) void (^textViewTapBlock)();
@property (copy, nonatomic) void (^showCenterBlock)();
@property (copy, nonatomic) void (^textLabelHeightBlock)(float height);

@end
