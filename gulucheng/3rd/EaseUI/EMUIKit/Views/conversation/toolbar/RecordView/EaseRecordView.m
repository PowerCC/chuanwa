/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseRecordView.h"
#import "EMCDDeviceManager.h"
#import "EaseLocalDefine.h"

@interface EaseRecordView ()
{
    NSTimer *_timer;
    UIImageView *_recordAnimationView;
    UIImageView *_recordCancelImageView;
    UILabel *_textLabel;
}

@end

@implementation EaseRecordView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseRecordView *recordView = [self appearance];
//    recordView.voiceMessageAnimationImages = @[@"EaseUIResource.bundle/VoiceSearchFeedback001",@"EaseUIResource.bundle/VoiceSearchFeedback002",@"EaseUIResource.bundle/VoiceSearchFeedback003",@"EaseUIResource.bundle/VoiceSearchFeedback004",@"EaseUIResource.bundle/VoiceSearchFeedback005",@"EaseUIResource.bundle/VoiceSearchFeedback006",@"EaseUIResource.bundle/VoiceSearchFeedback007",@"EaseUIResource.bundle/VoiceSearchFeedback008",@"EaseUIResource.bundle/VoiceSearchFeedback009",@"EaseUIResource.bundle/VoiceSearchFeedback010",@"EaseUIResource.bundle/VoiceSearchFeedback011",@"EaseUIResource.bundle/VoiceSearchFeedback012",@"EaseUIResource.bundle/VoiceSearchFeedback013",@"EaseUIResource.bundle/VoiceSearchFeedback014",@"EaseUIResource.bundle/VoiceSearchFeedback015",@"EaseUIResource.bundle/VoiceSearchFeedback016",@"EaseUIResource.bundle/VoiceSearchFeedback017",@"EaseUIResource.bundle/VoiceSearchFeedback018",@"EaseUIResource.bundle/VoiceSearchFeedback019",@"EaseUIResource.bundle/VoiceSearchFeedback020"];

    recordView.voiceMessageAnimationImages = @[@"im-record-1",
                                               @"im-record-2",
                                               @"im-record-3",
                                               @"im-record-4",
                                               @"im-record-5",
                                               @"im-record-6",
                                               @"im-record-7",
                                               @"im-record-8"];
    
    recordView.upCancelText = NSEaseLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
    recordView.loosenCancelText = NSEaseLocalizedString(@"message.toolBar.record.loosenCancel", @"loosen the fingers, to cancel sending");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = kCOLOR(0, 0, 0, 0.6);
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 36.5) / 2, 40, 36.5, 46)];
        _recordAnimationView.image = [UIImage imageNamed:@"im-record-1"];
        _recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordAnimationView];
        
        _recordCancelImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 44) / 2, 40, 44, 43)];
        _recordCancelImageView.image = [UIImage imageNamed:@"im-record-cancel"];
        [self addSubview:_recordCancelImageView];
        
        _recordCancelImageView.hidden = YES;
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                               self.bounds.size.height - 41,
                                                               self.bounds.size.width - 10,
                                                               25)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = NSEaseLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - setter
- (void)setVoiceMessageAnimationImages:(NSArray *)voiceMessageAnimationImages
{
    _voiceMessageAnimationImages = voiceMessageAnimationImages;
}

- (void)setUpCancelText:(NSString *)upCancelText
{
    _upCancelText = upCancelText;
    _textLabel.text = _upCancelText;
}

- (void)setLoosenCancelText:(NSString *)loosenCancelText
{
    _loosenCancelText = loosenCancelText;
}

-(void)recordButtonTouchDown
{
    _recordAnimationView.hidden = NO;
    _recordCancelImageView.hidden = YES;
    
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    
}

-(void)recordButtonTouchUpInside
{
    [_timer invalidate];
}

-(void)recordButtonTouchUpOutside
{
    [_timer invalidate];
}

-(void)recordButtonDragInside
{
    _textLabel.text = _upCancelText;
//    _textLabel.backgroundColor = [UIColor clearColor];
    _recordAnimationView.hidden = NO;
    _recordCancelImageView.hidden = YES;
}

-(void)recordButtonDragOutside
{
    _textLabel.text = _loosenCancelText;
//    _textLabel.backgroundColor = [UIColor redColor];
    _recordAnimationView.hidden = YES;
    _recordCancelImageView.hidden = NO;
}

-(void)setVoiceImage {
    _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:0]];
    double voiceSound = 0;
    voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter];
    int index = voiceSound*[_voiceMessageAnimationImages count];
    if (index >= [_voiceMessageAnimationImages count]) {
        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages lastObject]];
    } else {
        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:index]];
    }
    
    /*
    if (0 < voiceSound <= 0.05) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback001"]];
    }else if (0.05<voiceSound<=0.10) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback002"]];
    }else if (0.10<voiceSound<=0.15) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback003"]];
    }else if (0.15<voiceSound<=0.20) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback004"]];
    }else if (0.20<voiceSound<=0.25) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback005"]];
    }else if (0.25<voiceSound<=0.30) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback006"]];
    }else if (0.30<voiceSound<=0.35) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback007"]];
    }else if (0.35<voiceSound<=0.40) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback008"]];
    }else if (0.40<voiceSound<=0.45) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback009"]];
    }else if (0.45<voiceSound<=0.50) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback010"]];
    }else if (0.50<voiceSound<=0.55) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback011"]];
    }else if (0.55<voiceSound<=0.60) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback012"]];
    }else if (0.60<voiceSound<=0.65) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback013"]];
    }else if (0.65<voiceSound<=0.70) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback014"]];
    }else if (0.70<voiceSound<=0.75) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback015"]];
    }else if (0.75<voiceSound<=0.80) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback016"]];
    }else if (0.80<voiceSound<=0.85) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback017"]];
    }else if (0.85<voiceSound<=0.90) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback018"]];
    }else if (0.90<voiceSound<=0.95) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback019"]];
    }else {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback020"]];
    }*/
}

@end
