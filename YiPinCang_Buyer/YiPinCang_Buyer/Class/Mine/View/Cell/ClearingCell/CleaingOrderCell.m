//
//  CleaingOrderCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "CleaingOrderCell.h"

@implementation CleaingOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(Shoppingcar_dataModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self.bgImg sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:YPCImagePlaceHolder];
    self.titleLab.text = model.goods_name;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    self.typeLab.text = model.goods_spec;
    self.countLab.text = [NSString stringWithFormat:@"×%@",model.goods_num];
    
    
}

@end
