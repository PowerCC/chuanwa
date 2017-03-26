//
//  VoteCommendView.m
//  gulucheng
//
//  Created by 许坤志 on 16/8/12.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "VoteCommendView.h"
#import "CommendButtomView.h"
#import "VoteCommendTableViewCell.h"

#import "VoteEventApi.h"

static NSString * const voteCell = @"voteCommendCell";

@interface VoteCommendView() <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITableView *voteTableView;

@property (strong, nonatomic) RecommendModel *voteCommendModel;
@property (strong, nonatomic) NSArray *voteOptionArray;
@property (strong, nonatomic) NSMutableArray *voteResultArray;
@property (strong, nonatomic) NSMutableArray *ratioArray;
@property (assign, nonatomic) NSInteger totolVote;
@property (assign, nonatomic) BOOL isHomeIn;

@end

@implementation VoteCommendView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"VoteCommendView" owner:self options:nil] objectAtIndex:0];
        self.voteViewFrame = frame;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchUpInside:)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTouchUpInside:)];
        labelTapGestureRecognizer.delegate = self;
        [self.nickNameLabel addGestureRecognizer:labelTapGestureRecognizer];
        
        UINib *voteCellNib = [UINib nibWithNibName:@"VoteCommendTableViewCell" bundle:nil];
        [self.voteTableView registerNib:voteCellNib forCellReuseIdentifier:voteCell];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = _voteViewFrame;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)touchUpInside:(UITapGestureRecognizer *)recognizer {
    if (!_voteTableView.userInteractionEnabled) {
        if (_voteViewTapBlock) {
            _voteViewTapBlock();
        }
    }
}

- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer {
    UILabel *label= (UILabel *)recognizer.view;
    if (_showCenterBlock) {
        _showCenterBlock();
    }
    NSLog(@"%@被点击了",label.text);
}

- (void)voteRequestWithSelectedResult:(NSString *)voteResult {
    VoteEventApi *voteEventApi = [[VoteEventApi alloc] initWithfromEid:_voteCommendModel.eventId
                                                           EventVoteId:_voteCommendModel.voteModel.voteId
                                                                   eid:_voteCommendModel.eid
                                                                  vote:voteResult];
    [voteEventApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

- (void)loadVoteCommendModel:(RecommendModel *)voteCommendModel isHomeIn:(BOOL)isHomeIn {
    _isHomeIn = isHomeIn;
    _voteCommendModel = voteCommendModel;
    _questionLabel.text = voteCommendModel.voteModel.title;
    
    _voteOptionArray = [[NSArray alloc] initWithObjects:
                        voteCommendModel.voteModel.option1,
                        voteCommendModel.voteModel.option2,
                        voteCommendModel.voteModel.option3,
                        voteCommendModel.voteModel.option4,
                        voteCommendModel.voteModel.option5, nil];
    
    _voteResultArray = [[NSMutableArray alloc] initWithObjects:
                        voteCommendModel.voteModel.votes1,
                        voteCommendModel.voteModel.votes2,
                        voteCommendModel.voteModel.votes3,
                        voteCommendModel.voteModel.votes4,
                        voteCommendModel.voteModel.votes5, nil];
    
    if (isHomeIn) {
        _viewTopConstraint.constant = (475 - (42 + 12 + 44 * _voteResultArray.count)) / 2;
    } else {
        _viewTopConstraint.constant = 32;
    }
    
    // voteView的总高度
    _viewHeightConstraint.constant = 310 - 44 * (5 - _voteOptionArray.count);
    
    _ratioArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (NSString *result in _voteResultArray) {
        _totolVote = _totolVote + result.integerValue;
    }
    
    [_voteTableView reloadData];
    
    _nickNameLabel.text = voteCommendModel.nickName;
    _genderImageView.image = [UIImage imageNamed:voteCommendModel.gender.integerValue == 1 ? @"home-boy" : @"home-girl"];
    
    if (_isHomeIn) {
        _voteCountLabel.text = @"";
    } else {
        _voteCountLabel.text = [NSString stringWithFormat:@"%td人投票", _totolVote];
    }
    
    if (self.voteViewHeightBlock) {
        self.voteViewHeightBlock(310 - 44 * (5 - _voteOptionArray.count) + 32);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _voteOptionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VoteCommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:voteCell];

    cell.voteContentLabel.text = [_voteOptionArray objectAtIndex:indexPath.row];
        
    if (!_isHomeIn) {
        NSString *result = [_voteResultArray objectAtIndex:indexPath.row];
        cell.circleImageView.hidden = YES;
        
        cell.ratioLabel.text = [NSString stringWithFormat:@"%td%%", _totolVote == 0 ? _totolVote : (result.integerValue * 100 / _totolVote)];
        
        WEAKSELF
        GCD_AFTER(0.0, ^{
            cell.ratioLeftView.frame = CGRectMake(0, 3, 40, 35);
            cell.ratioRightView.frame  = CGRectMake(50,
                                                    3,
                                                    _totolVote == 0 ? _totolVote : (result.floatValue / weakSelf.totolVote) * (SCREEN_WIDTH - 50),
                                                    35);
            cell.ratioRightView.backgroundColor = [UIColor redColor];
            
            [weakSelf changeColorByVoteCommendTableViewCell:cell index:indexPath.row];
        });
        
        tableView.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _totolVote = _totolVote + 1;
    
    _voteCountLabel.text = [NSString stringWithFormat:@"%td人投票", _totolVote];
    
    [self voteRequestWithSelectedResult:[NSString stringWithFormat:@"votes%td", indexPath.row + 1]];
    
    tableView.userInteractionEnabled = NO;
    
    NSInteger temp = [[_voteResultArray objectAtIndex:indexPath.row] integerValue];
    [_voteResultArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%td", temp + 1]];
    
    VoteCommendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *result = [_voteResultArray objectAtIndex:indexPath.row];
    
    if (_recommendModelResultBlock) {
        [_voteCommendModel.voteModel setValue:[NSString stringWithFormat:@"%td", result.integerValue]
                                       forKey:[NSString stringWithFormat:@"votes%td", indexPath.row + 1]];
        _recommendModelResultBlock(_voteCommendModel);
    }
    
    cell.ratioLabel.text = [NSString stringWithFormat:@"%td%%", result.integerValue * 100 / _totolVote];
    [_ratioArray addObject:[NSString stringWithFormat:@"%td", result.integerValue * 100 / _totolVote]];
    
    [self changeColorByVoteCommendTableViewCell:cell index:indexPath.row];
    
    // 时间根据动画长度加长
    float animateTime;
    animateTime = (result.floatValue / _totolVote) * (SCREEN_WIDTH - 50) / 40 * 0.15;
    
    // 选择答案条的动画
    WEAKSELF
    GCD_AFTER(0.0, ^{
        cell.circleImageView.hidden = YES;
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             cell.ratioLeftView.frame = CGRectMake(0, 3, 40, 35);
                         }];
        
        [UIView animateWithDuration:animateTime
                         animations:^{
                             cell.ratioRightView.frame  = CGRectMake(50,
                                                                     3,
                                                                     (result.floatValue / weakSelf.totolVote) * (SCREEN_WIDTH - 50),
                                                                     35);
                         } completion:^(BOOL finished) {
                             [weakSelf otherAnimatedWithoutSelectedRow:indexPath.row];
                         }];
    });
}

// 等待被选择答案的长条动画完毕进行剩余选择项的动画
- (void)otherAnimatedWithoutSelectedRow:(NSInteger)selectedRow {
    
    NSInteger totalIndex = 0;
    
    for (int i = 0; i < _voteResultArray.count; i++) {
        
        if (i != selectedRow) {
            
            totalIndex ++;
            
            NSString *tempResult = [_voteResultArray objectAtIndex:i];
            
            VoteCommendTableViewCell *cell = [_voteTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            if (totalIndex < _voteResultArray.count - 1) {
                cell.ratioLabel.text = [NSString stringWithFormat:@"%td%%", tempResult.integerValue * 100 / _totolVote];
                [_ratioArray addObject:[NSString stringWithFormat:@"%td", tempResult.integerValue * 100 / _totolVote]];
            } else {
                NSInteger leftPercent = 100;
                for (NSString *percentString in _ratioArray) {
                    leftPercent = leftPercent - percentString.integerValue;
                }
                cell.ratioLabel.text = [NSString stringWithFormat:@"%td%%", leftPercent];
            }
        
            [self changeColorByVoteCommendTableViewCell:cell index:i];
            
            float animateTime;
            animateTime = (tempResult.floatValue / _totolVote) * (SCREEN_WIDTH - 50) / 40 * 0.15;
        
            WEAKSELF
            GCD_AFTER(0.0, ^{
                cell.circleImageView.hidden = YES;
                
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     cell.ratioLeftView.frame = CGRectMake(0, 3, 40, 35);
                                 }];
                
                [UIView animateWithDuration:animateTime
                                 animations:^{
                                     cell.ratioRightView.frame  = CGRectMake(50,
                                                                             3,
                                                                             ((tempResult.floatValue) / weakSelf.totolVote) * (SCREEN_WIDTH - 50),
                                                                             35);
                                 }];
            });
        }
    }
}

- (void)changeColorByVoteCommendTableViewCell:(VoteCommendTableViewCell *)cell index:(NSInteger)i {
    if (i == 0) {
        cell.ratioLeftView.backgroundColor = kCOLOR(255, 133, 117, 1.0);
        cell.ratioRightView.backgroundColor = kCOLOR(255, 133, 117, 1.0);
    }
    if (i == 1) {
        cell.ratioLeftView.backgroundColor = kCOLOR(255, 197, 95, 1.0);
        cell.ratioRightView.backgroundColor = kCOLOR(255, 197, 95, 1.0);
    }
    if (i == 2) {
        cell.ratioLeftView.backgroundColor = kCOLOR(114, 219, 191, 1.0);
        cell.ratioRightView.backgroundColor = kCOLOR(114, 219, 191, 1.0);
    }
    if (i == 3) {
        cell.ratioLeftView.backgroundColor = kCOLOR(141, 226, 254, 1.0);
        cell.ratioRightView.backgroundColor = kCOLOR(141, 226, 254, 1.0);
    }
    if (i == 4) {
        cell.ratioLeftView.backgroundColor = kCOLOR(237, 184, 239, 1.0);
        cell.ratioRightView.backgroundColor = kCOLOR(237, 184, 239, 1.0);
    }
}

@end
