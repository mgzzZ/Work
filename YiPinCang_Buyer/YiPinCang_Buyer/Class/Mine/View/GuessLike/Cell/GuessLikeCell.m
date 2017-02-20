//
//  GuessLikeCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "GuessLikeCell.h"

@implementation GuessLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GuessModel *)model{
    [self.bgImg sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:IMAGE(@"zhanweitu_img")];
    self.titleLab.text = model.goods_name;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    if ([model.hot isEqualToString:@"1"]  ) {
        //热销
        self.typeImg.hidden = NO;
        
    }else{
        // 不是热销
        self.typeImg.hidden = YES;
    }
}
@end
