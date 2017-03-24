//
//  IBButton.h
//  JiaCheng
//
//  Created by 许坤志 on 16/6/9.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBButton : UIButton

@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;

@end
