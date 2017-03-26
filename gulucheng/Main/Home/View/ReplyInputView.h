//
//  ReplyInputView.h
//  GuluCheng
//
//  Created by 许坤志 on 16/9/6.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>

//改变根据文字改变TextView的高度
typedef void (^ContentSizeBlock)(CGSize contentSize);

@interface ReplyInputView : UIView

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (copy, nonatomic) void (^ContentSizeBlock)(CGSize contentSize);
@property (copy, nonatomic) void (^sendButtonBlock)();

+ (ReplyInputView *)awakeWithNib;

@end
