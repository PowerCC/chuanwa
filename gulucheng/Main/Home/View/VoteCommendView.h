//
//  VoteCommendView.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/12.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface VoteCommendView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *voteView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;

@property (assign, nonatomic) CGRect voteViewFrame;

@property (copy, nonatomic) void (^voteViewTapBlock)();
@property (copy, nonatomic) void (^showCenterBlock)();
@property (copy, nonatomic) void (^voteViewHeightBlock)(float height);
@property (copy, nonatomic) void (^recommendModelResultBlock)(RecommendModel *recommendModel);

- (id)initWithFrame:(CGRect)frame;
- (void)loadVoteCommendModel:(RecommendModel *)textCommendModel isHomeIn:(BOOL)isHomeIn;

@end
