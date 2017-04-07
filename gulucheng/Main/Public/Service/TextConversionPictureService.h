//
//  TextConversionPictureService.h
//  gulucheng
//
//  Created by 邹程 on 2017/4/5.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextConversionPictureService : NSObject

+ (UIImage *)createTextSharePicture:(NSString *)text;

+ (UIImage *)createWalletBalanceCellTextPicture:(NSString *)text;

+ (UIImage *)createWalletBalanceCellVotePicture:(NSString *)text;

@end
