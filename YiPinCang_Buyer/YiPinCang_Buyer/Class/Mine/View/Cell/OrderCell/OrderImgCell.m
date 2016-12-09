//
//  OrderImgCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/28.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "OrderImgCell.h"

@implementation OrderImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GoodsModel *)model{
    [self.orderImg sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:YPCImagePlaceHolder];
}

@end
