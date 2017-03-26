//
//  MyWalletFuncCell.m
//  GuluCheng
//
//  Created by 邹程 on 2017/3/14.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "MyWalletFuncCell.h"

@implementation MyWalletFuncCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFuncModel:(MyWalletFuncModel *)funcModel {
    _funcModel = funcModel;
    
    if (funcModel) {
        _funcImageView.image = [UIImage imageNamed:funcModel.funcImageName];
        _funcLable.text = funcModel.funcName;
        _valueLable.text = nil;
    }
}

@end
