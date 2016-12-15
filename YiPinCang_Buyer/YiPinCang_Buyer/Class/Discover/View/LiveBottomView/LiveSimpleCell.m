//
//  LiveSimpleCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveSimpleCell.h"

@implementation LiveSimpleCell


- (void)setModel:(LiveSimpleData *)model{
    self.nameLab.text = model.name;
    self.commentLab.text = [NSString stringWithFormat:@"%@人看过",model.live_users];
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
