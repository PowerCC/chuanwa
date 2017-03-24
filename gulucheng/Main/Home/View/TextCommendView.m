//
//  TextCommendView.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/12.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "TextCommendView.h"
#import "CommendButtomView.h"
#import "Tool.h"

@implementation TextCommendView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TextCommendView" owner:self options:nil] objectAtIndex:0];
        self.textViewFrame = frame;
        
        UITapGestureRecognizer *textTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTouchUpInside:)];
        [self addGestureRecognizer:textTapGestureRecognizer];
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTouchUpInside:)];
        [self.nameLabel addGestureRecognizer:labelTapGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)loadTextCommendModel:(RecommendModel *)textCommendModel {
    
//    [Tool changelineSpacingWithLabel:_textLabel text:textCommendModel.textModel.content lingSpace:5 center:NO];
    
    _textLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 32.0;
    _textLabel.text = textCommendModel.textModel.content;
    _nameLabel.text = textCommendModel.nickName;
    _genderImageView.image = [UIImage imageNamed:textCommendModel.gender.integerValue == 1 ? @"home-boy" : @"home-girl"];
    
    
    [self layoutIfNeeded];
    CGFloat selfHeight = [_textLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    CGRect rect = self.frame;
    rect.origin.y = 10;
    rect.size.height = selfHeight + 50;
    self.frame = rect;
    
    if (self.textLabelHeightBlock) {
        self.textLabelHeightBlock(selfHeight + 60);
    }
    
//    // 获取文字高度
//    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    paragraphStyle.lineSpacing = 5;
//    
//    // 设置文字属性 要和label的一致
//    NSDictionary *attrs = @{NSFontAttributeName: _textLabel.font,
//                            NSParagraphStyleAttributeName: paragraphStyle};
//    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT);
//    
//    // 计算文字占据的高度
//    CGSize size = [textCommendModel.textModel.content boundingRectWithSize:maxSize
//                                                                   options:NSStringDrawingUsesLineFragmentOrigin
//                                                                attributes:attrs
//                                                                   context:nil].size;
//    
//    //_textViewFrame = CGRectMake(_textViewFrame.origin.x, _textViewFrame.origin.y, _textViewFrame.size.width, size.height);
//    
//    if (self.textLabelHeightBlock) {
//        
//        self.textLabelHeightBlock(size.height + 50);
//        
////        GCD_AFTER(0.0, ^{
////            
////        });
//    }
}

- (void)textTouchUpInside:(UITapGestureRecognizer *)recognizer {
    
    if (_textViewTapBlock) {
        _textViewTapBlock();
    }
}

- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer {
    UILabel *label= (UILabel *)recognizer.view;
    if (_showCenterBlock) {
        _showCenterBlock();
    }
    NSLog(@"%@被点击了",label.text);
}

@end
