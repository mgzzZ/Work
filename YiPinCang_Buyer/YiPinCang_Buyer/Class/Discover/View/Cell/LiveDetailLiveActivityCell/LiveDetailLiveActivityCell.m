//
//  LiveDetailLiveActivityCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveDetailLiveActivityCell.h"

@implementation LiveDetailLiveActivityCell

    
    
    
    
    
- (void)setModel:(LiveActivityModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self.shopImg sd_setImageWithURL:[NSURL URLWithString:model.strace_contentStr] placeholderImage:YPCImagePlaceHolder];
    self.borderLab.text = model.brand_name;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    self.titleLab.text = model.strace_title;
    if (model.storage.integerValue <= 5) {
        self.numberLab.hidden = NO;
        self.numberLab.text = [NSString stringWithFormat:@"仅剩%@件库存",model.storage];
    }else{
        self.numberLab.hidden = YES;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
