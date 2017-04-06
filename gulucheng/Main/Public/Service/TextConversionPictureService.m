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

+ (UIImage *)createTextSharePicture:(NSString *)text {
    
    if (!text || text.length == 0) {
        return nil;
    }
    
    // 文字居中显示在画布上
    NSMutableParagraphStyle *shareParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    shareParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    shareParagraphStyle.alignment = NSTextAlignmentLeft;
    
    CGFloat shareTextFontSize = text.length > 120 ? 48.0 : 62.0;
    CGFloat shareTextWidth = shareTextFontSize == 48 ? 568.0 : 580.0;
    CGSize shareTextSize = [text boundingRectWithSize:CGSizeMake(shareTextWidth, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:shareTextFontSize], NSForegroundColorAttributeName:kCOLOR(34, 34, 34, 1) }
                                          context:nil].size;
    
    // 文字居中显示在画布上
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;// 文字居中
    
    CGFloat fontSize = 38.0;
    
    // 计算文字所占的size，文字居中显示在画布上
    NSString *title = @"传蛙文字卡";
    CGSize titleTextSize = [title boundingRectWithSize:CGSizeMake(750.0, 750.0)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName:[UIColor whiteColor] }
                                          context:nil].size;
    
    
    
    CGFloat topAreaHeight = 588.0;
    CGFloat contentMinHeight = 472.0;
    CGFloat centerAreaMinHeight = 64.0 + shareTextSize.height + 82.0 + 73.0 + 35.0;
    if (centerAreaMinHeight < contentMinHeight) {
        centerAreaMinHeight = contentMinHeight;
    }
    
    CGFloat space = 70.0 + titleTextSize.height + 32.0;
    
    CGSize size = CGSizeMake(750.0, space + 54 + centerAreaMinHeight + 230.0);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 240.0 / 255.0, 242.0 / 255.0, 247.0 / 255.0, 1);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    
    CGContextSetRGBFillColor(context, 255.0 / 255.0, 129.0 / 255.0, 105.0 / 255.0, 1);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width, topAreaHeight));
    
    // 绘制文字
    CGRect rect = CGRectMake((size.width - titleTextSize.width) / 2, 70.0, titleTextSize.width, titleTextSize.height);
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle }];
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, CGRectMake((size.width - 40.0) / 2, space, 40.0, 8.0));
    
    // 阴影
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 60.0, kCOLOR(199, 195, 195, 1).CGColor);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, CGRectMake(35.0, space + 394.0, 680.0, centerAreaMinHeight - 350.0));
    CGContextRestoreGState(context);
    
    // 中心区域
    space += 54;
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, CGRectMake(35.0, space, 680.0, centerAreaMinHeight));
    
    // 绘制分享文字
    CGRect shareRect = CGRectMake((size.width - shareTextSize.width) / 2, space + 64.0, shareTextSize.width, shareTextSize.height);
    [text drawInRect:shareRect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:shareTextFontSize], NSForegroundColorAttributeName:kCOLOR(34, 34, 34, 1), NSParagraphStyleAttributeName:shareParagraphStyle }];
    
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
    
//    NSString *path_sandox = NSHomeDirectory();
//    //设置一个图片的存储路径
//    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/test.png"];
//    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
//    [UIImagePNGRepresentation(resultImg) writeToFile:imagePath atomically:YES];
    
    NSData *imageData = UIImageJPEGRepresentation(resultImg, 0.6);
    if (imageData && imageData.length > 0) {
        resultImg = [UIImage imageWithData:imageData];
    }
    
    CGImageRelease(cgimg);
    
    UIGraphicsEndImageContext();
    
    return resultImg;
}

@end
