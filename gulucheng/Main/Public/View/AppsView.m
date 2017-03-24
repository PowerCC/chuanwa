//
//  AppsView.m
//  gulucheng
//
//  Created by xukz on 16/9/21.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "AppsView.h"

@implementation AppsView

+ (AppsView *)awakeWithNib {
    AppsView *view = nil;
    view = [[[NSBundle mainBundle] loadNibNamed:@"AppsView" owner:self options:nil] objectAtIndex:0];
    return view;
}
- (IBAction)channelShareButtonAction:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    if (_ShareChannelButtonCompleteBlock) {
        _ShareChannelButtonCompleteBlock(senderButton.tag - 1);
    }
}

@end
