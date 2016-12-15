//
//  LiveBottomCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveBottomCell.h"

@implementation LiveBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(LiveTopViewModel *)model{
    if (_model != model) {
        _model = model;
    }
     [self.bgImg sd_setImageWithURL:[NSURL URLWithString:_model.store_avatar] placeholderImage:YPCImagePlaceHolder];
}
@end
