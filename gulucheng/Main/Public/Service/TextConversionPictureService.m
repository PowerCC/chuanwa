//
//  TextConversionPictureService.m
//  gulucheng
//
//  Created by 邹程 on 2017/4/5.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "TextConversionPictureService.h"

@implementation TextConversionPictureService

+ (void)createTextSharePicture {
    
    // 文字居中显示在画布上
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;// 文字居中
    
    CGFloat fontSize = 38.0;
    
    // 计算文字所占的size，文字居中显示在画布上
    NSString *title = @"传蛙文字卡";
    CGSize sizeText = [title boundingRectWithSize:CGSizeMake(750.0, 750.0)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor whiteColor] } context:nil].size;
    
    
    
    CGFloat topAreaHeight = 588.0;
    CGFloat centerAreaMinHeight = 472.0;
    CGFloat space = 70.0 + sizeText.height + 32.0;
    
    CGSize size = CGSizeMake(750.0, space + 54 + centerAreaMinHeight + 230.0);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 240.0 / 255.0, 242.0 / 255.0, 247.0 / 255.0, 1);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    
    CGContextSetRGBFillColor(context, 255.0 / 255.0, 129.0 / 255.0, 105.0 / 255.0, 1);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width, topAreaHeight));
    
    // 绘制文字
    CGRect rect = CGRectMake((size.width - sizeText.width) / 2, 70.0, sizeText.width, sizeText.height);
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle }];
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, CGRectMake((size.width - 40.0) / 2, space, 40.0, 8.0));
    
    
    // 阴影
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 60.0, kCOLOR(199, 195, 195, 1).CGColor);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, CGRectMake(35.0, topAreaHeight, 680.0, 80));
    CGContextRestoreGState(context);
    
    // 中心区域
    space += 54;
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, CGRectMake(35.0, space, 680.0, centerAreaMinHeight));
    
    // logo图片
    space += centerAreaMinHeight;
    UIImage *logoImage = [UIImage imageNamed:@"share-text-picture-logo"];
    [logoImage drawInRect:CGRectMake((size.width - 195.0) / 2, space - 73.0 - 35.0, 195.0, 73.0)];
    
    // desc图片
    UIImage *descImage = [UIImage imageNamed:@"share-text-picture-desc"];
    [descImage drawInRect:CGRectMake(62.0, size.height - 83.0 - 72.0, 350.0, 83.0)];
    
    // orCode图片
    UIImage *orCodeImage = [UIImage imageNamed:@"share-text-picture-or-code"];
    [orCodeImage drawInRect:CGRectMake(size.width - 134.0 - 62.0, size.height - 134.0 - 46.0, 134.0, 134.0)];
    
    CGImageRef cgimg = CGBitmapContextCreateImage(context);
    UIImage *resultImg = [UIImage imageWithCGImage:cgimg];
    
    
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/test.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(resultImg) writeToFile:imagePath atomically:YES];
    
    CGImageRelease(cgimg);
    
    UIGraphicsEndImageContext();
}

@end
