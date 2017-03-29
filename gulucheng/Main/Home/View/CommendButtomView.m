//
//  CommendButtomView.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/11.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CommendButtomView.h"
#import "NSString+DateTime.h"
#import <MAMapKit/MAGeometry.h>

#define PI 3.1415926

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
    

//    if (commendModel.distMeter != nil && commendModel.distMeter.floatValue <= 100) {
//        self.distanceAndTimeAgoLabel.text = [NSString stringWithFormat:@"%.2f米 ∙ %@", commendModel.distMeter.floatValue, [NSString timeAgo:commendModel.createTime.integerValue]];
//    }
//    else {
//        self.distanceAndTimeAgoLabel.text = [NSString stringWithFormat:@"%.2fkm ∙ %@", commendModel.distKm.floatValue, [NSString timeAgo:commendModel.createTime.integerValue]];
//    }
    
    self.locationLabel.text = commendModel.eventCity && commendModel.eventCity.length && ![commendModel.eventCity isEqualToString:@"null-null"] ? commendModel.eventCity : @"神秘地址";
    
}

@end
