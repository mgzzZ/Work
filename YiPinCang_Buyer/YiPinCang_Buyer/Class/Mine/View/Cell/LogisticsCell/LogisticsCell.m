//
//  LogisticsCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/30.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LogisticsCell.h"

@implementation LogisticsCell


- (void)setModel:(LogistcsinContentModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.timeLab.text = model.time;
    self.textLab.text = model.context;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
