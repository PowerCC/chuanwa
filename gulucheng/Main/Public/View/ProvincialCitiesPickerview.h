//
//  ProvincialCitiesPickerview.h
//  GuluCheng
//
//  Created by 许坤志 on 16/7/30.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvincialCitiesPickerview : UIView

@property (nonatomic, copy) void (^completion)(NSString *provinceName, NSString *cityName);
@property (nonatomic, copy) void (^hideProvincialCitiesPickerview)();

- (void)showPickerWithProvinceName:(NSString *)provinceName cityName:(NSString *)cityName;//显示 省市名

@end
