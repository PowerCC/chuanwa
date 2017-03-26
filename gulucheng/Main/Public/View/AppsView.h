//
//  AppsView.h
//  gulucheng
//
//  Created by xukz on 16/9/21.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppsView : UIView

@property (copy, nonatomic) void (^ShareChannelButtonCompleteBlock)(NSInteger index);

+ (AppsView *)awakeWithNib;

@end
