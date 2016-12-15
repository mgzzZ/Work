//
//  FollowCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/10.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "FollowCell.h"

@implementation FollowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(FollowModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self.txImg sd_setImageWithURL:[NSURL URLWithString:model.store_avatar] placeholderImage:YPCImagePlaceHolder];
    self.nameLab.text = model.store_name;
    self.titleLab.text = model.store_description;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
