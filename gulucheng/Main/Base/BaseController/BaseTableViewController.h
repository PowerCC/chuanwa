//
//  BaseTableViewController.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

@property (nonatomic, strong) UIView *navView;

- (BOOL)isSuccessWithRequest:(NSDictionary *)response;

@end
