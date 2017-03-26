//
//  Tool.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/23.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache/YYCache.h>

@interface Tool : NSObject

+ (BOOL)isAvilableWithTextField:(UITextField *)textField
                         string:(NSString *)string
                          range:(NSRange)range;

+ (void)changelineSpacingWithLabel:(UILabel *)label
                              text:(NSString *)text
                         lingSpace:(NSInteger)lineSpace
                            center:(BOOL)center;

+ (void)changelineSpacingWithTextView:(UITextView *)textView
                                 text:(NSString *)text
                            lingSpace:(NSInteger)lineSpace;

+ (NSString *)noneSpaseString:(NSString *)string;

+ (NSString *)parseString:(NSString *)string;

+ (void)saveImageToDeviceWithImage:(UIImage *)image;

+ (NSData *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth maxFileSize:(NSInteger)maxFileSize;

+ (UIImage *)getImageFromView:(UIView *)view;

+ (YYDiskCache *)yyDiskCache;

+ (NSString *)transToDateStringWithConfromTimesp:(NSInteger)confromTimesp;

+ (void)countDownWithTime:(NSInteger)time
           countDownBlock:(void (^)(NSInteger timeLeft))countDownBlock
                 endBlock:(void (^)())endBlock;

@end
