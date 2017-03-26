//
//  NoDataView.m
//  JiaCheng
//
//  Created by 许坤志 on 16/7/7.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

+ (NoDataView *)awakeWithNib {
    NoDataView *view = nil;
    view = [[[NSBundle mainBundle] loadNibNamed:@"NoDataView" owner:self options:nil] objectAtIndex:0];
    return view;
}

- (IBAction)reloadButtonAction:(id)sender {
    if (_ReloadBlock) {
        _ReloadBlock();
        [self removeFromSuperview];
    }
}

@end
