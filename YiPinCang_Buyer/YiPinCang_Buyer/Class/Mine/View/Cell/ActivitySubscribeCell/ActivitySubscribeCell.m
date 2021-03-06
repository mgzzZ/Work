//
//  ActivitySubscribeCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/10.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ActivitySubscribeCell.h"

@implementation ActivitySubscribeCell


- (void)setModel:(ActivitySubscribeModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self.shopImg sd_setImageWithURL:[NSURL URLWithString:model.activity_pic] placeholderImage:YPCImagePlaceHolder];
    NSString *startTime = [YPC_Tools timeWithTimeIntervalString:model.start Format:@"MM-dd    HH:mm"];
    NSString *endTime = [YPC_Tools timeWithTimeIntervalString:model.end Format:@"HH:mm"];
    self.timeLab.text = [NSString stringWithFormat:@"%@~%@",startTime,endTime];
    self.oldtimeLab.text = model.transtime;
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
