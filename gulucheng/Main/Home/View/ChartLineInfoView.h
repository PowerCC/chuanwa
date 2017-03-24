//
//  CommentTableViewCell.h
//  gulucheng
//
//  Created by 许坤志 on 16/8/25.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartLineInfoView : UIView

@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *bottomArray;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger maxValue;

@end
