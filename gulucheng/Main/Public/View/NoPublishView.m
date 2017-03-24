//
//  NoPublishView.m
//  GuluCheng
//
//  Created by xukz on 16/9/19.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "NoPublishView.h"

@implementation NoPublishView

+ (NoPublishView *)awakeWithNib {
    NoPublishView *view = nil;
    view = [[[NSBundle mainBundle] loadNibNamed:@"NoPublishView" owner:self options:nil] objectAtIndex:0];
    return view;
}

- (IBAction)publicContentButtonAction:(id)sender {
    if (_PublishContentBlock) {
        _PublishContentBlock();
        [self removeFromSuperview];
    }
}

@end
