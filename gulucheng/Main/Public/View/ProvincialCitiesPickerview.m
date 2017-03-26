//
//  ProvincialCitiesPickerview.m
//  GuluCheng
//
//  Created by 许坤志 on 16/7/30.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "ProvincialCitiesPickerview.h"
#import "ProvinceCityModel.h"

#define pickerViewHeight 216

@interface ProvincialCitiesPickerview () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) ProvinceCityModel *selectModel;

@property (nonatomic, strong) NSArray *secondAry;//二级数据源

@property (nonatomic, assign) NSInteger firstCurrentIndex;//第一行当前位置
@property (nonatomic, assign) NSInteger secondCurrentIndex;//第二行当前位置


@end

@implementation ProvincialCitiesPickerview

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        [self internalConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalConfig];
    }
    return self;
}

//懒加载
- (NSArray *)provinces {
    if (_provinces == nil) {
        // 解析
        NSString * path = [[NSBundle mainBundle] pathForResource:@"province-city" ofType:@"plist"];
        NSArray * tempArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray * array = [NSMutableArray array];
        // 遍历plist里面的字典
        for (NSDictionary * dict in tempArray) {
            // 字典-》模型
            ProvinceCityModel * pro = [ProvinceCityModel JCParse:dict];
            [array addObject:pro];
        }
        _provinces = array;
    }
    return _provinces;
}

- (void)internalConfig {
    _backView = [[UIView alloc] initWithFrame:self.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.0;
    [self addSubview:_backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_backView addGestureRecognizer:tap];
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.pickView];
}

- (void)showPickerWithProvinceName:(NSString *)provinceName cityName:(NSString *)cityName {
    
    if (provinceName.length > 0) {
        [_provinces enumerateObjectsUsingBlock:^(ProvinceCityModel *pro, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([pro.name isEqualToString:provinceName]) {
                _firstCurrentIndex = idx;
                _secondAry = pro.cities;
            }
        }];
    } else {
        _firstCurrentIndex = 0;
        _secondCurrentIndex = 0;
    }
    
    [_secondAry enumerateObjectsUsingBlock:^(NSString *cityString, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cityString isEqualToString:cityName]) {
            _secondCurrentIndex = idx;
        }
    }];

    
    [_pickView reloadAllComponents];
    [_pickView selectRow:_firstCurrentIndex inComponent:0 animated:NO];
    if (_secondAry.count > 0) {
        [_pickView selectRow:_secondCurrentIndex inComponent:1 animated:NO];
    }
    
    [self show];
}

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 0.6;
        self.pickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - pickerViewHeight, self.frame.size.width, pickerViewHeight);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 0;
        self.pickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+44, self.frame.size.width, pickerViewHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    if (self.hideProvincialCitiesPickerview) {
        self.hideProvincialCitiesPickerview();
    }
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate

// 返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// component组有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0){
        return self.provinces.count;
    } else {
        // 省份的位置
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        // 根据省份的位置得到city的count
        return [[self.provinces[provinceIndex] cities] count];
        
    }
}

// pickerView 显示的文字内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return [self.provinces[row] name];
    } else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        return [self.provinces[provinceIndex] cities][row];
    }
    return  @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        // 刷新指定的列
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
    NSString *cityName = @"";
    if (component == 0) {
        _selectModel = self.provinces[row];
    }
    if (component == 1) {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        _selectModel = self.provinces[provinceIndex];
        cityName = _selectModel.cities[row];
        
        if (_completion) {
            if (![cityName isEqualToString:@"请选择"]) {
                _completion(_selectModel.name, cityName);
            }
        }
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)cancleButtonAction:(UIButton *)sender {
    [self hide];
}

#pragma mark - 懒加载

- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 44, self.frame.size.width, pickerViewHeight)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
        [_pickView selectRow:0 inComponent:0 animated:NO];
    }
    return _pickView;
}

@end
