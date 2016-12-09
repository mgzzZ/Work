//
//  OrderWaitSendWCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "OrderWaitSendWCell.h"
#import "GoodsModel.h"
@implementation OrderWaitSendWCell

- (void)setModel:(GoodsModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self.merchandiseImg sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:YPCImagePlaceHolder];
 
    self.merchandiseTitle.text = model.goods_name;
    self.merchandisePrice.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    self.merchandiseColor.text = model.goods_spec;
    self.merchandiseCount.text = [NSString stringWithFormat:@"×%@",model.goods_num];
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
