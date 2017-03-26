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
    
//    self.talkCountLabel.text = commendModel.commentTimes;
//    self.peopleCountLabel.text = commendModel.spreadTimes;
        
//    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:GlobalData.userModel.latitude longitude:GlobalData.userModel.longitude];
//    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:commendModel.lat.doubleValue longitude:commendModel.lon.doubleValue];
//        
//    double distance = [curLocation distanceFromLocation:otherLocation];
    
    // 1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(GlobalData.userModel.latitude, GlobalData.userModel.longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(commendModel.lat.doubleValue, commendModel.lon.doubleValue));
    
    // 2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1, point2);
    
    
    self.distanceAndTimeAgoLabel.text = [NSString stringWithFormat:@"%.2fkm ∙ %@", distance / 1000, [NSString timeAgo:commendModel.createTime.integerValue]];
    
    self.locationLabel.text = commendModel.eventCity && commendModel.eventCity.length && ![commendModel.eventCity isEqualToString:@"null-null"] ? commendModel.eventCity : @"神秘地址";
    
}

@end
