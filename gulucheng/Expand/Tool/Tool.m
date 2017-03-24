//
//  Tool.m
//  gulucheng
//
//  Created by 许坤志 on 16/7/23.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "Tool.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation Tool

+ (BOOL)isAvilableWithTextField:(UITextField *)textField string:(NSString *)string range:(NSRange)range {
    NSString* text = textField.text;
    //删除
    if([string isEqualToString:@""]) {
        
        //删除一位
        if(range.length == 1){
            //最后一位,遇到空格则多删除一次
            if (range.location == text.length-1 ) {
                if ([text characterAtIndex:text.length-1] == ' ') {
                    [textField deleteBackward];
                }
                return YES;
            }
            //从中间删除
            else {
                NSInteger offset = range.location;
                
                if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
                    [textField deleteBackward];
                    offset --;
                }
                [textField deleteBackward];
                textField.text = [self parseString:textField.text];
                UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                return NO;
            }
        }
        else if (range.length > 1) {
            BOOL isLast = NO;
            //如果是从最后一位开始
            if(range.location + range.length == textField.text.length )  {
                isLast = YES;
            }
            [textField deleteBackward];
            textField.text = [self parseString:textField.text];
            
            NSInteger offset = range.location;
            if (range.location == 3 || range.location  == 8) {
                offset ++;
            }
            if (isLast) {
                //光标直接在最后一位了
            } else {
                UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            }
            
            return NO;
        }
        else {
            return YES;
        }
    }
    
    else if (string.length > 0) {
        
        //限制输入字符个数
        if (([self noneSpaseString:textField.text].length + string.length - range.length > 11) ) {
            return NO;
        }
        //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
        //            if(![string isNum]){
        //                return NO;
        //            }
        [textField insertText:string];
        textField.text = [self parseString:textField.text];
        
        NSInteger offset = range.location + string.length;
        if (range.location == 3 || range.location  == 8) {
            offset ++;
        }
        UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
        textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
        return NO;
    } else {
        return YES;
    }
}

+ (NSString*)noneSpaseString:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSString*)parseString:(NSString *)string {
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (mStr.length > 3) {
        [mStr insertString:@" " atIndex:3];
    }
    if (mStr.length > 8) {
        [mStr insertString:@" " atIndex:8];
    }
    
    return  mStr;
}

+ (void)saveImageToDeviceWithImage:(UIImage *)image {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *asSetUrl,NSError *error){
        if (error) {
            [MBProgressHUD showError:@"保存失败"];
        } else {
            [MBProgressHUD showError:@"保存成功"];
        }
    }];
}

+ (NSData *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth maxFileSize:(NSInteger)maxFileSize {
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //压
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(newImage, compression);
    while (imageData.length / 1000 > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(newImage, compression);
    }
    
    return imageData;
}

//把UIView 转换成图片
+ (UIImage *)getImageFromView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (YYDiskCache *)yyDiskCache {
    NSString *basePath = [kPathDocument stringByAppendingPathComponent:@"FileCacheBenchmarkSmall"];
    YYDiskCache *yyDisk = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:@"yy"]];
    return yyDisk;
}

#pragma mark - Label&UITextView
+ (void)changelineSpacingWithLabel:(UILabel *)label text:(NSString *)text lingSpace:(NSInteger)lineSpace center:(BOOL)center {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.paragraphSpacing = 5.0;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
    label.textAlignment = center ? NSTextAlignmentCenter : NSTextAlignmentLeft;
}

+ (void)changelineSpacingWithTextView:(UITextView *)textView text:(NSString *)text lingSpace:(NSInteger)lineSpace {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;// 字体的行间距
    paragraphStyle.paragraphSpacing = 5.0;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

+ (NSString *)transToDateStringWithConfromTimesp:(NSInteger)confromTimesp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm"];
    NSDate *confromDate = [NSDate dateWithTimeIntervalSince1970:confromTimesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromDate];
    return confromTimespStr;
}

+ (void)countDownWithTime:(NSInteger)time
           countDownBlock:(void (^)(NSInteger timeLeft))countDownBlock
                 endBlock:(void (^)())endBlock {
    __block NSInteger timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (endBlock) {
                    endBlock();
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                timeout--;
                if (countDownBlock) {
                    countDownBlock(timeout);
                }
            });
        }
    });
    dispatch_resume(_timer);
}

@end
