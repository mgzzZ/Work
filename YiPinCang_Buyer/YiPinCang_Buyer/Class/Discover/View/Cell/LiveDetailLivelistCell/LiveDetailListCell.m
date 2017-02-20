//
//  LiveDetailListCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveDetailListCell.h"

@implementation LiveDetailListCell

    
- (void)setModel:(LiveDetailListDataModel *)model{
    if (_model != model) {
        _model = model;
    }
    if (model.store_avatar.length == 0) {
        [self.shopImg sd_setImageWithURL:[NSURL URLWithString:model.activity_pic] placeholderImage:YPCImagePlaceHolder];
    }else{
        [self.shopImg sd_setImageWithURL:[NSURL URLWithString:model.store_avatar] placeholderImage:YPCImagePlaceHolder];
    }
    NSString *startTime = [YPC_Tools timeWithTimeIntervalString:model.start Format:@"YYYY-MM-dd    HH:mm"];
    NSString *endTime = [YPC_Tools timeWithTimeIntervalString:model.end Format:@"HH:mm"];
    self.timeLab.text = [NSString stringWithFormat:@"%@~%@",startTime,endTime];
    
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
