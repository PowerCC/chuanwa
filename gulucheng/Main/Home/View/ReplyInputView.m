//
//  ReplyInputView.m
//  GuluCheng
//
//  Created by 许坤志 on 16/9/6.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "ReplyInputView.h"

@interface ReplyInputView()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation ReplyInputView

+ (ReplyInputView *)awakeWithNib {
    
    ReplyInputView *view = nil;
    view = [[[NSBundle mainBundle] loadNibNamed:@"ReplyInputView" owner:self options:nil] objectAtIndex:0];
    [view.headImageView sd_setImageWithURL:[NSURL URLWithString:GlobalData.userModel.avatar]];
    view.sendButton.enabled = NO;
    
    return view;
}

- (IBAction)sendButtonAction:(id)sender {
    if (_sendButtonBlock) {
        _sendButtonBlock();
    }
    
    _textView.text = @"";
    _placeHolderLabel.hidden = NO;
    _sendButton.enabled = NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        _placeHolderLabel.hidden = NO;
        _sendButton.enabled = NO;
    } else if (textView.text.length < 200) {
        _placeHolderLabel.hidden = YES;
        _sendButton.enabled = YES;
    }

    static CGFloat maxHeight = 80.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    if (size.height > frame.size.height) {
        
        if (size.height >= maxHeight) {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH - 114, size.height);
    
    if (_ContentSizeBlock) {
        _ContentSizeBlock(size);
    }
}

@end
