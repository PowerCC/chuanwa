//
//  CommendButtomView.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/11.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CommendButtomView.h"

@implementation CommendButtomView

+ (CommendButtomView *)awakeWithNib {
    
    CommendButtomView *view = nil;
    view = [[[NSBundle mainBundle] loadNibNamed:@"CommendButtomView" owner:self options:nil] objectAtIndex:0];
    
    return view;
}

- (void)setFrame:(CGRect)frame commendModel:(RecommendModel *)commendModel {
    self.frame = frame;
    
    if (commendModel.eventPicVos.count == 1) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.numberOfPages = commendModel.eventPicVos.count;
    }
    
//    self.talkCountLabel.text = commendModel.commentTimes;
//    self.peopleCountLabel.text = commendModel.spreadTimes;
    
    self.locationLabel.text = commendModel.eventCity && commendModel.eventCity.length && ![commendModel.eventCity isEqualToString:@"null-null"] ? commendModel.eventCity : @"神秘地址";
    
}

@end
