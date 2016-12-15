//
//  HelpDetailCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/11.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "HelpDetailCell.h"

@implementation HelpDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HelpDetailModel *)model{
    if (_model != model) {
        _model = model;
    }
    _nameLab.text = model.article_title;
    _timeLab.text = model.article_time;
}

@end
