//
//  CardDataViewController.m
//  GuluCheng
//
//  Created by 许坤志 on 16/8/26.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "CardDataViewController.h"
#import "ChartLineInfoView.h"
#import "StatisticsApi.h"
#import "StatisticsModel.h"
#import "NSDate+Extend.h"

@interface CardDataViewController ()

@property (strong, nonatomic) NSMutableArray *showArray;
@property (strong, nonatomic) NSMutableArray *spreadArray;
@property (strong, nonatomic) NSMutableArray *dateArray;

@property (weak, nonatomic) IBOutlet UILabel *shareRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliverCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *showCountLabel;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *peopleImageViews;

@property (weak, nonatomic) IBOutlet UIView *deliverView;
@property (weak, nonatomic) IBOutlet UIView *showView;

@end

@implementation CardDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navView.backgroundColor = kCOLOR(255, 255, 255, 1.0);
    
    _dateArray = [[NSMutableArray alloc] initWithCapacity:7];
    _spreadArray = [[NSMutableArray alloc] initWithCapacity:7];
    _showArray = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSDate *confromDate = [NSDate dateWithTimeIntervalSince1970:_recommendModel.createTime.integerValue/1000];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:confromDate];
    
    for (int i = 0; i < 7; i ++) {
        [components setDay:([components day] + (i == 0 ? 0 : 1))];
        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
        NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
        
        if (i == 0 || i == 6) {
            [dateday setDateFormat:@"MM月dd"];
            [_dateArray addObject:[dateday stringFromDate:beginningOfWeek]];
        } else {
            [dateday setDateFormat:@"dd"];
            [_dateArray addObject:[dateday stringFromDate:beginningOfWeek]];
        }
    }
    
    StatisticsApi *statisticsApi = [[StatisticsApi alloc] initWithEid:_recommendModel.eid];
    
    WEAKSELF
    [statisticsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([weakSelf isSuccessWithRequest:request.responseJSONObject]) {
            
            NSArray *tempArray = [StatisticsModel JCParse:request.responseJSONObject[@"data"][@"spreadList"]];
            for (StatisticsModel *statisticsModel in tempArray) {
                
                NSDate *tempDate = [NSDate dateWithString:statisticsModel.createDay format:@"yyyyMMdd"];
                
                if ([weakSelf isSameAndBeforeTodayWithCompareDate:tempDate]) {
                    [weakSelf.spreadArray addObject:statisticsModel.num];
                }
            }
            
            NSArray *tempArray1 = [StatisticsModel JCParse:request.responseJSONObject[@"data"][@"allShowList"]];
            for (StatisticsModel *statisticsModel in tempArray1) {
                
                NSDate *tempDate = [NSDate dateWithString:statisticsModel.createDay format:@"yyyyMMdd"];
                
                if ([weakSelf isSameAndBeforeTodayWithCompareDate:tempDate]) {
                    [weakSelf.showArray addObject:statisticsModel.num];
                }
            }
            
            NSString *spreadRate = request.responseJSONObject[@"data"][@"spreadRate"];
            
            weakSelf.shareRatioLabel.attributedText = [weakSelf addAttribute:[NSString stringWithFormat:@"%@%% 传递率", spreadRate]
                                                   andSecondName:[NSString stringWithFormat:@"%@%%", spreadRate]
                                                           color:Them_orangeColor];
            
            for (int i = 1; i < weakSelf.peopleImageViews.count + 1; i ++) {
                
                UIImageView *imageView = weakSelf.peopleImageViews[i - 1];
                if (i <= spreadRate.integerValue / 10) {
                    imageView.image = [UIImage imageNamed:@"home-personSelected"];
                }
            }
        
            ChartLineInfoView *deliverLineView = [[ChartLineInfoView alloc] initWithFrame:CGRectMake(0, 60, weakSelf.view.bounds.size.width, 200)];
            // 传入数值
            deliverLineView.maxValue = [weakSelf eventMaxNumberWithDataArray:weakSelf.spreadArray];
            deliverLineView.leftArray = [weakSelf benchmarkArrayWithDataArray:weakSelf.spreadArray];
            deliverLineView.bottomArray = weakSelf.dateArray;
            deliverLineView.dataArray = [weakSelf eventDataArrayWithDataArray:weakSelf.spreadArray];
            [weakSelf.deliverView addSubview:deliverLineView];
            
            ChartLineInfoView *showLineView = [[ChartLineInfoView alloc] initWithFrame:CGRectMake(0, 60, weakSelf.view.bounds.size.width, 200)];
            // 传入数值
            showLineView.maxValue = [weakSelf eventMaxNumberWithDataArray:weakSelf.showArray];
            showLineView.leftArray = [weakSelf benchmarkArrayWithDataArray:weakSelf.showArray];
            showLineView.bottomArray = weakSelf.dateArray;
            showLineView.dataArray = [weakSelf eventDataArrayWithDataArray:weakSelf.showArray];
            [weakSelf.showView addSubview:showLineView];
            
            
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
    
    _deliverCountLabel.attributedText = [self addAttribute:[NSString stringWithFormat:@"%@ 次传递", _recommendModel.spreadTimes]
                                             andSecondName:_recommendModel.spreadTimes
                                                     color:kCOLOR(68, 153, 255, 1.0)];
    
    _showCountLabel.attributedText = [self addAttribute:[NSString stringWithFormat:@"%d 次展现", _recommendModel.spreadTimes.intValue + _recommendModel.skipTimes.intValue]
                                          andSecondName:[NSString stringWithFormat:@"%d", _recommendModel.spreadTimes.intValue + _recommendModel.skipTimes.intValue]
                                                  color:kCOLOR(68, 153, 255, 1.0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isSameAndBeforeTodayWithCompareDate:(NSDate *)createDayDate{

    NSDate *todayDate = [NSDate date];
    
    NSComparisonResult result = [createDayDate compare:todayDate];
    switch (result) {
            //todayDate 比 createDayDate大
        case NSOrderedAscending:
            return YES;
            //todayDate 比 createDayDate小
        case NSOrderedDescending:
            return NO;
            //todayDate = createDayDate
        case NSOrderedSame:
            return YES;
        default:
            return NO;
    }
    return NO;
}

- (NSInteger)eventMaxNumberWithDataArray:(NSMutableArray *)dataArray {
    
    NSInteger tempMax = [[dataArray valueForKeyPath:@"@max.intValue"] integerValue];
    
    if (tempMax < 10) {
        if (tempMax % 2 == 0) {
            tempMax = tempMax + 2;
        } else {
            tempMax = tempMax + 1;
        }
    } else if (tempMax < 100) {
        tempMax = 100;
    } else if (tempMax < 1000) {
        tempMax = 1000;
    } else {
        tempMax = tempMax/1000 * (1000 + 1);
    }
    
    return tempMax;
}

- (NSMutableArray *)eventDataArrayWithDataArray:(NSMutableArray *)dataArray {
    
    NSInteger tempMax = [[dataArray valueForKeyPath:@"@max.intValue"] integerValue];
    
    if (tempMax < 10) {
        if (tempMax % 2 == 0) {
            tempMax = tempMax + 2;
        } else {
            tempMax = tempMax + 1;
        }
    } else if (tempMax < 100) {
        tempMax = 100;
    } else if (tempMax < 1000) {
        tempMax = 1000;
    } else {
        tempMax = tempMax/1000 * (1000 + 1);
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSString *number in dataArray) {
        [tempArray addObject:[NSString stringWithFormat:@"%.2f", number.floatValue/tempMax]];
    }
    
    return tempArray;
}

- (NSArray *)benchmarkArrayWithDataArray:(NSMutableArray *)dataArray {
    
    NSInteger tempMax = [[dataArray valueForKeyPath:@"@max.intValue"] integerValue];
    NSArray *tempArray = [[NSMutableArray alloc] init];
    
    if (tempMax < 10) {
        if (tempMax % 2 == 0) {
            tempMax = tempMax + 2;
        } else {
            tempMax = tempMax + 1;
        }
    } else if (tempMax < 100) {
        tempMax = 100;
    } else if (tempMax < 1000) {
        tempMax = 1000;
    } else {
        tempMax = tempMax/1000 * (1000 + 1);
    }
    
    if (tempMax < 1000) {
        tempArray = @[[NSString stringWithFormat:@"%td", tempMax], @"", [NSString stringWithFormat:@"%td", tempMax/2], @"", @""];
    } else if (tempMax == 1000) {
        tempArray = @[[NSString stringWithFormat:@"%tdk", tempMax/1000], @"", [NSString stringWithFormat:@"%td", tempMax/2], @"", @""];
    } else {
        tempArray = @[[NSString stringWithFormat:@"%tdk", tempMax/1000], @"", [NSString stringWithFormat:@"%tdk", tempMax/1000/2], @"", @""];
    }

    return tempArray;
}

- (NSMutableAttributedString *)addAttribute:(NSString *)attributeString andSecondName:(NSString *)secondString color:(UIColor *)color {
    NSMutableAttributedString *declareString = [[NSMutableAttributedString alloc] initWithString:attributeString];
    
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:22.0], NSFontAttributeName,
                                   color, NSForegroundColorAttributeName, nil];
    
    [declareString addAttributes:attributeDict range:NSMakeRange(0,
                                                                 secondString.length)];
    return declareString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
